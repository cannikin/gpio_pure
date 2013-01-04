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
    output = `echo "#{value}" > /sys/class/gpio/gpio#{PIN_MAP[pin]}/value`
    if output == ''
      return value
    else
      raise Error, output
    end
  end


  # Reads a value from a pin
  def self.read(pin)
    set(pin, :in)
    output = `cat /sys/class/gpio/gpio#{PIN_MAP[pin]}/value`
    return output.chomp.to_i
  end


  # Removes the pin from service
  def self.clear(pin)
    output = `echo "#{PIN_MAP[pin]}" > /sys/class/gpio/unexport`
    if output == ''
      return true
    else
      raise Error, output
    end
  end


private


  # Sends commands to enable a pin and set communication direction
  def self.set(pin, direction)
    stdin, stdout, stderr = Open3.popen3(%Q{echo "#{PIN_MAP[pin]}" > /sys/class/gpio/export})
    error = stderr.readlines

    if error.empty?
      stdin, stdout, stderr = Open3.popen3(%Q{echo "#{direction}" > /sys/class/gpio/gpio#{PIN_MAP[pin]}/direction})
      error = stderr.readlines

      if error.empty?
        return true
      else
        raise Error, error.join
      end
    else
      raise Error, error.join
    end
  end

end
