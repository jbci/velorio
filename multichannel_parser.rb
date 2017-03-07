#!/home/j/.rvm/rubies/ruby-2.3.0/bin/ruby

# aFile = File.new("input_test.txt", "r")
#    # ... process the file
# aFile.close

require 'absolute_time'

start_time_b = AbsoluteTime.now


time_array = []

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

    time_array.push({channel: channel, start_time: start_time, end_time: (start_time.to_f + end_time.to_f).to_s, start_level: start_level, end_level: end_level, slope: slope})

    start_time = start_time.to_f + end_time.to_f
  end
end

p time_array
time_array.sort_by! {|k,v| k[:start_time].to_f}
time_array.uniq {|i| i[:start_time]}.each do |st|
  p "st------------:" + st[:start_time].to_s
  # p time_array.select {|section| section[:start_time] == st[:start_time] }
  tmp = time_array.select {|section| section[:start_time] == st[:start_time] }
  tmp.uniq {|i| i[:end_time]}.each do |et|
    tmp_et= et[:end_time]
    tmp_2 = tmp.select {|section| section[:end_time] == tmp_et }
    p tmp_2
  end
  # p tmp.sort_by {|k,v| k[:end_time].to_f}
  p tmp.count
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
