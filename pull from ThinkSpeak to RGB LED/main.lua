pollPeriod = 2

print("Polling ThingSpeak with timer each "..pollPeriod.." second")

function pollTS()
	
	-- This one gets and executes first command in TalkBack queue
	--getThingSpeak()
	
	-- This one reads from a channel with three fields (LED [R,G,B]) and sets LED PWM accordingly
	readLastThingSpeak()
end

-- Once per second, poll ThingSpeak server
tmr.alarm(3, pollPeriod*1000, 1, pollTS )
