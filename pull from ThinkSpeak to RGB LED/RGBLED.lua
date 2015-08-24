-- RGB LED controller
-- Controls FETs to fire high-power RGB array
-- RGB array active-high at 2-5 V. Drive with 3.3 V outputs.
-- PWM duty range is 10 bits: 0-1023
-- Use GPIO 2,4,5

LEDpinR = 2
LEDpinG = 4
LEDpinB = 5
LEDPWMf = 200 -- Hz. 1-1000 Hz available through LUA
LED_PWM_MAX = 300 -- Power limit for high-power LEDs (w/o cooling)

gpio.mode(LEDpinR, gpio.OUTPUT)
gpio.mode(LEDpinG, gpio.OUTPUT)
gpio.mode(LEDpinB, gpio.OUTPUT)
pwm.start(LEDpinR)
pwm.start(LEDpinG)
pwm.start(LEDpinB)

print("Initiating RGB LED lib")

-- Use all three available PWM possibilities for LEDs
pwm.setup(LEDpinR, LEDPWMf, 0)
pwm.setup(LEDpinG, LEDPWMf, 0)
pwm.setup(LEDpinB, LEDPWMf, 0)

-- Set PWM mode. 0-1023
function setRGB_PWM(r,g,b)
	--print("LED input:  "..r.." : "..g.." : "..b)
	-- Truncate max intensity
	if r > LED_PWM_MAX then r = LED_PWM_MAX end
	if g > LED_PWM_MAX then g = LED_PWM_MAX end
	if b > LED_PWM_MAX then b = LED_PWM_MAX end
	-- Minus inputs are off = 0 PWM
	if r < 0 then r = 0 end
	if g < 0 then g = 0 end
	if b < 0 then b = 0 end
	-- Set actual PWM values
	pwm.setduty(LEDpinR, r)
	pwm.setduty(LEDpinG, g)
	pwm.setduty(LEDpinB, b)  
	--print("LED output: "..r.." : "..g.." : "..b)
end

-- Set non-PWM mode. ON/OFF
function setRGB(r,g,b)
  if r >= 1 then
    gpio.write(LEDpinR,gpio.HIGH)
  else
    gpio.write(LEDpinR,gpio.LOW)
  end

  if g >= 1 then
    gpio.write(LEDpinG,gpio.HIGH)
  else
    gpio.write(LEDpinG,gpio.LOW)
  end
  
  if b >= 1 then
    gpio.write(LEDpinB,gpio.HIGH)
  else
    gpio.write(LEDpinB,gpio.LOW)
  end
end

-- EOF