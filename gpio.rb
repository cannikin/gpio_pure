require 'open3'

class GPIO

  class Error < StandardError; end

  # Maps wiringPi pins to Broadcom chip pins: 
  # https://projects.drogon.net/raspberry-pi/wiringpi/pins/
  PIN_MAP = { 0 => 17,  1 => 18,  2 => 21,  3 => 22,  4 => 23,  5 => 24,
              6 => 25,  7 => 4,   8 => 0,   9 => 1,   10 => 8,  11 => 7,
              12 => 10, 13 => 9,  14 => 11, 15 => 14, 16 => 15, 17 => 28,
              18 => 29, 19 => 30, 20 => 31 }
  
  # Writes a value to a pin
  def self.write(pin, value)
    set(pin, :out)
    execute "echo \"#{value}\" > /sys/class/gpio/gpio#{PIN_MAP[pin]}/value" do |out|
      return value
    end
  end


  # Reads a value from a pin
  def self.read(pin)
    set(pin, :in)
    execute "cat /sys/class/gpio/gpio#{PIN_MAP[pin]}/value" do |out|
      return out.to_i
    end
  end


  # Removes the pin from service. Could be useful if you have other code using
  # sysfs and need to make a pin available to it.
  def self.clear(pin)
    execute "echo \"#{PIN_MAP[pin]}\" > /sys/class/gpio/unexport" do |out|
      return true
    end
  end


  # Sends commands to enable a pin and set communication direction
  def self.set(pin, direction)
    execute "echo \"#{PIN_MAP[pin]}\" > /sys/class/gpio/export" do |out|
      execute "echo \"#{direction}\" > /sys/class/gpio/gpio#{PIN_MAP[pin]}/direction" do |out|
        return true
      end
    end
  end


private


  # Runs a command and wraps it in a open3 call, checking for errors
  def self.execute(command)
    stdin, stdout, stderr = Open3.popen3(command)
    error = stderr.readlines

    if error.empty?
      yield(stdout.read.chomp)
    else
      raise Error, error.join
    end
  end


end
