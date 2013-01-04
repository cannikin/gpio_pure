# GPIO Pure

A Ruby library for talking to the GPIO pins on a Raspberry Pi using the native
`/sys/class/gpio` functionality built into the Raspian OS.

## A note on pins

Pin numbering on the Raspberry Pi can be confusing. You will see references to
three different numbering schemes:

1. The physical pins on the Raspberry Pi, numbered 1 - 26
2. The GPIO pin number that the on-board Broadcom chip understands (jumps around
   from 17 to 31 back to 0...these are all over the place)
3. The wiringPi numbering scheme, numbered from 0 - 16. wiringPi is a popular
   C library that gives you access to the GPIO pins in a more programmatic way.
   The author, [Gordon](https://projects.drogon.net/raspberry-pi/wiringpi/) 
   did what the Arduino does which is re-number the pins in numerical order
   regardless of what the actual on-board chip calls them internally. The
   wiringPi numbering scheme is what gpio_pure uses. For more info, see:
   https://projects.drogon.net/raspberry-pi/wiringpi/
   
## Usage

    require 'gpio'

    GPIO.write 0, 1  # Set the output of pin 0 high
    GPIO.write 0, 0  # Set the output of pin 1 low
    GPIO.read 1      # Read the current value of pin 1
    GPIO.clear 1     # Optional, removes the pin's virtual file from the OS

