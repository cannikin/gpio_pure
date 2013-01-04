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
    execute "echo \"#{value}\" > /sys/class/gpio/gpio#{PIN_MAP[pin]}/value"
    return value
  end


  # Reads a value from a pin
  def self.read(pin)
    set(pin, :in)
    return execute("cat /sys/class/gpio/gpio#{PIN_MAP[pin]}/value").to_i
  end


  # Removes the pin from service. Could be useful if you have other code using
  # sysfs and need to make a pin available to it. Note that clearing a pin
  # doesn't set it back to LOW, it remains whatever it was when last written to.
  def self.clear(*pins)
    pins = PIN_MAP.keys if pins.first == :all

    pins.each do |pin|
      execute "echo \"#{PIN_MAP[pin]}\" > /sys/class/gpio/unexport"
    end
    return true
  end


  # Sends commands to enable a pin and set communication direction. Note that
  # changing the direction of a pin from :out to :in will set the pin LOW no
  # matter what was there to begin with.
  def self.set(pin, direction)
    execute "echo \"#{PIN_MAP[pin]}\" > /sys/class/gpio/export"
    execute "echo \"#{direction}\" > /sys/class/gpio/gpio#{PIN_MAP[pin]}/direction"
  end


private


  # Runs a command and wraps it in a open3 call, checking for errors. If 
  # successful yields stdout to any passed block
  def self.execute(command)
    stdin, stdout, stderr = Open3.popen3(command)
    error = stderr.readlines

    if error.empty?
      return stdout.read.chomp
    else
      raise Error, error.join
    end
  end


end
