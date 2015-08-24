-- LED support functions
-- Using the on-board LED on ESP-12 dev board (NodeMCU 0.9)
-- LED at GPIO16 = LUA pin 0
LEDpin = 0

gpio.mode(LEDpin, gpio.OUTPUT)
gpio.write(LEDpin, gpio.HIGH)  -- Active-low = High is off.

print("Blink LED initiated")
	 
function blinkLED_busy()
-- Occupy processor with only blinking a LED
  while 1 do
	  gpio.write(LEDpin, gpio.LOW)
	  tmr.delay(1000000)   -- wait 1,000,000 us = 1 second
	  gpio.write(LEDpin, gpio.HIGH)
	  tmr.delay(1000000)   -- wait 1,000,000 us = 1 second
	end
end

function blinkLED2Hz()
-- Blink LED with timer calls
  tmr.alarm(6, 500, 1, function()
    -- Toggle LED pin  
    if (gpio.read(LEDpin)==1) then
	  gpio.write(LEDpin,gpio.LOW)
	else
	  gpio.write(LEDpin,gpio.HIGH)
	end  
  end)
end

function LED_flash()
-- Light up LED for 300 ms or so, with timer support
  gpio.write(LEDpin,gpio.LOW)
  tmr.alarm(6, 300, 0, function()
 	  gpio.write(LEDpin,gpio.HIGH)
  end)
end

function LED_on()
-- Light up system LED
  gpio.write(LEDpin,gpio.LOW)
end

function LED_off()
  gpio.write(LEDpin,gpio.HIGH)
end

-- EOF