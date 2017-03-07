
require 'serialport' # use Kernel::require on windows, works better.

#params for serial port
port_str = "/dev/ttyUSB0"  #may be different for you
baud_rate = 115200
data_bits = 8
stop_bits = 1
parity = SerialPort::NONE

sp = SerialPort.new(port_str, baud_rate, data_bits, stop_bits, parity)

i = 1
initial_value = 90

p "iniciando ejecución: "
80.times do
  value = initial_value - i
  # p 'comando : ' + '1 '+value.to_s
  sp.write('1 '+value.to_s)
  # p sp.read
  sleep 0.1
  i = i + 1
end
sp.write('1 85')

#just write forever
# while true do
#   sp.write(i.to_s(2))
#   sleep 10
# end
