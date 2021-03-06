#!/home/j/.rvm/rubies/ruby-2.3.0/bin/ruby

# aFile = File.new("input_test.txt", "r")
#    # ... process the file
# aFile.close

require 'absolute_time'

start_time_b = AbsoluteTime.now

start_level = 0
start_time = 0
channel, end_time, end_level = 0

time_array = []

IO.foreach("input_test.txt") do |line|
  # channel, start_time, end_time, end_level = line.split(' ')
  channel, start_level, end_level, end_time = line.split(' ')
  channel = channel.gsub('c','').to_i

  slope = (end_level.to_f - start_level.to_f) / (end_time.to_f)

  # p line
  # p 'ch: ' + channel.to_s + 'start_time: ' + start_time.to_s + ', end_time: ' + (start_time.to_f + end_time.to_f).to_s +
  ', start_level: ' + start_level.to_s + ', end_level: ' + end_level.to_s  + ', slope: ' + slope.to_s

  time_array.push({channel: channel, start_time: start_time, end_time: (start_time.to_f + end_time.to_f).to_s, start_level: start_level, end_level: end_level, slope: slope})
  #start_level = end_level
  start_time = start_time.to_i + end_time.to_i
end
#
p time_array

require 'serialport' # use Kernel::require on windows, works better.

#params for serial port
port_str = "/dev/ttyUSB0"  #may be different for you
baud_rate = 115200
data_bits = 8
stop_bits = 1
parity = SerialPort::NONE

sp = SerialPort.new(port_str, baud_rate, data_bits, stop_bits, parity)

time_array.each do |span|
  start_time_c = AbsoluteTime.now
  # p 'span'
  ch = span[:channel]
  st = span[:start_time]
  et = span[:end_time]
  sl = span[:start_level]
  el = span[:end_level]
  slope = span[:slope]
  # p et.to_i
  # p el.to_i
  while (AbsoluteTime.now - start_time_b) < et.to_i do
    set_level = sl.to_f + (AbsoluteTime.now - start_time_c) * slope
    sp.write(ch.to_s + ' ' + (100 - set_level.to_i).to_s)
    # p 'set_level : ' + set_level.to_s
    sleep 0.1
    # p et
    # p start_time_b
    # p AbsoluteTime.now
    # p (AbsoluteTime.now - start_time_b).to_s
  end

  # p et
end

end_time = AbsoluteTime.now
puts "Function took #{end_time - start_time_b} seconds to complete."
