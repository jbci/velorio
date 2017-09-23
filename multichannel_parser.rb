#!/home/j/.rvm/rubies/ruby-2.3.0/bin/ruby

# aFile = File.new("input_test.txt", "r")
#    # ... process the file
# aFile.close

require 'absolute_time'

start_time_b = AbsoluteTime.now


time_array_1 = []
final_array= []

in_files = ["input_test_1.txt", "input_test_2.txt", "input_test_3.txt"]

in_files.each do |file|
  start_level = 0
  start_time = 0
  channel = 0
  end_time, end_level = 0.0
  IO.foreach(file) do |line|
    # channel, start_time, end_time, end_level = line.split(' ')
    channel, start_level, end_level, end_time = line.split(' ')
    channel = channel.gsub('c','').to_i

    slope = (end_level.to_f - start_level.to_f) / (end_time.to_f)

    # p line
    #p 'ch: ' + channel.to_s + ', start_time: ' + start_time.to_s + ', end_time: ' + (start_time.to_f + end_time.to_f).to_s + ', start_level: ' + start_level.to_s + ', end_level: ' + end_level.to_s  + ', slope: ' + slope.to_s

    time_array_1.push({channel: channel, start_time: start_time, end_time: (start_time.to_f + end_time.to_f).to_s, start_level: start_level, end_level: end_level, slope: slope})

    start_time = start_time.to_f + end_time.to_f
  end
end
#print time_array_1;

test_array = [
  {channel: 1, start_time: 0, end_time: 5, start_level: 0, end_level: 100, slope: 20},
  {channel: 2, start_time: 0, end_time: 7.5, start_level: 0, end_level: 100, slope:13.33},
  {channel: 3, start_time: 0, end_time: 10, start_level: 0, end_level: 100, slope: 10},
  {channel: 1, start_time: 5, end_time: 15, start_level: 100, end_level: 30, slope: -7},
  {channel: 2, start_time: 7.5, end_time: 17.5, start_level: 100, end_level: 30, slope:-7},
  {channel: 3, start_time: 10, end_time: 20, start_level: 100, end_level: 30, slope: -7}
]
test_array = time_array_1
time_array = []
test_array.uniq { |h| h[:channel] }.each_with_index do |channel, channel_index|
  p "channel: " + channel.to_s
  time_array << test_array.select  { |h| h[:channel] == channel[:channel] }.sort_by { |h| h[:start_time]}
end

p "time_array"
time_array.map { |h| p h }

require 'serialport' # use Kernel::require on windows, works better.

#params for serial port
port_str = "/dev/cu.usbserial-A600615j"  #may be different for you
baud_rate = 115200
data_bits = 8
stop_bits = 1
parity = SerialPort::NONE

sp = SerialPort.new(port_str, baud_rate, data_bits, stop_bits, parity)


execution_start = AbsoluteTime.now
last_end_time = 100000000


while AbsoluteTime.now < execution_start + last_end_time do
  time_array.each do |hash_array|
    actual_element = hash_array.select { |h| h[:start_time].to_i < (AbsoluteTime.now - execution_start) && h[:end_time].to_i > (AbsoluteTime.now - execution_start)}
    # p actual_element.size
    # p actual_element
    ch = actual_element[0][:channel]
    st = actual_element[0][:start_time]
    et = actual_element[0][:end_time]
    sl = actual_element[0][:start_level]
    el = actual_element[0][:end_level]
    slope = actual_element[0][:slope]

    relative_start_time = st
    ahora = AbsoluteTime.now - execution_start
    set_level = sl.to_f + (ahora - st.to_f).to_f * slope
    sp.write(ch.to_s + ' ' + (95 - set_level.to_i).to_s)
    p actual_element
    p (AbsoluteTime.now - execution_start).to_s + " channel: " + (ch.to_s + ' value: ' + (95 - set_level.to_i).to_s).to_s
    p relative_start_time
    sleep 0.06

  end
end

#
# require 'serialport' # use Kernel::require on windows, works better.
#
# #params for serial port
# port_str = "/dev/ttyUSB0"  #may be different for you
# baud_rate = 115200
# data_bits = 8
# stop_bits = 1
# parity = SerialPort::NONE
#
# sp = SerialPort.new(port_str, baud_rate, data_bits, stop_bits, parity)
#
# time_array.each do |span|
#   start_time_c = AbsoluteTime.now
#   # p 'span'
#   ch = span[:channel]
#   st = span[:start_time]
#   et = span[:end_time]
#   sl = span[:start_level]
#   el = span[:end_level]
#   slope = span[:slope]
#   # p et.to_i
#   # p el.to_i
#   while (AbsoluteTime.now - start_time_b) < et.to_i do
#     set_level = sl.to_f + (AbsoluteTime.now - start_time_c) * slope
#     sp.write(ch.to_s + ' ' + (100 - set_level.to_i).to_s)
#     # p 'set_level : ' + set_level.to_s
#     sleep 0.1
#     # p et
#     # p start_time_b
#     # p AbsoluteTime.now
#     # p (AbsoluteTime.now - start_time_b).to_s
#   end
#
#   # p et
# end

end_time = AbsoluteTime.now
puts "Function took #{end_time - start_time_b} seconds to complete."
