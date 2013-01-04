# GPIO Pure

A Ruby library for talking to the GPIO pins on a Raspberry Pi using the native
`/sys/class/gpio` functionality built into the Raspian OS.

## Usage

    require 'gpio'

    GPIO.write 0, 1  # Set the output of pin 0 high
    GPIO.write 0, 0  # Set the output of pin 1 low
    GPIO.read 1      # Read the current value of pin 1
    GPIO.clear 1     # Optional, removes the pin's virtual file from the OS
    
