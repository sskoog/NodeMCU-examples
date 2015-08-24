-- PIR sensor

-- GPIO no 6
PIRpin = 6
movementsSinceLast = -1  -- Counter: Number of movements between TS posts. -1 for idle between posts
gpio.mode(PIRpin, gpio.INPUT)

print("PIR2 initiated")


function pollPIR()
-- Setup timer 5 to poll PIR output
  print("Polling PIR pin...")
  tmr.alarm(5, 250, 1, function() 
    if (gpio.read(PIRpin)==1) then
	  LED_on()
	  if movementsSinceLast < 0 then
		movementsSinceLast = movementsSinceLast + 1	
		sendPIRnow()
	  else
		movementsSinceLast = movementsSinceLast + 1	
	  end
	else
	  LED_off()
	end  
  end)
end

-- Send data immediately. Use only if more than 15 sec since last post
function sendPIRnow()
	print("Sending directly")
	postThingSpeak(movementsSinceLast)
	movementsSinceLast = 0
	-- Restart timer on 15 sec countdown
	tmr.stop(3)
	tmr.alarm(3, 15*1000, 1, sendPIRtimer )		
end

function sendPIRtimer()
	print("Sending @ 15 sec timer")
	if movementsSinceLast == 0 then
		-- No movements, but TS doesn't know about it yet
		postThingSpeak(0) 
		print("Posting zero movements")
		movementsSinceLast = -1
	else if movementsSinceLast >= 1 then
		print(movementsSinceLast.." new movements to post")
		-- One or more movements, report all to TS
		postThingSpeak(movementsSinceLast) 
		movementsSinceLast = 0
	else
		-- Nothing to post. ThingSpeak already knows that there are no movementsSinceLast
		print("Nothing to post")
	end
	end 
end

 -- Run post function every 15 sec as default
tmr.alarm(3, 15*1000, 1, sendPIRtimer )
pollPIR()

-- EOF