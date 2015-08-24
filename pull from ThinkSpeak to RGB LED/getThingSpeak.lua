-- Sources of inspiration
-- http://captain-slow.dk/2015/04/16/posting-to-thingspeak-with-esp8266-and-nodemcu/
-- https://github.com/mattcallow/esp8266-sdk/blob/master/apps/06thingspeak/user/user_main.c
-- https://github.com/tangophi/esp8266_iot_enabler/blob/master/user/user_main.c 
-- https://github.com/iobridge/ThingSpeak-Arduino-Examples/blob/master/Yun/TalkBack_to_Arduino.ino

-- This script fetches a few fields from a channel at ThingSpeak.com
-- 'getThingSpeak' utilizes the "TalkBack" function of queued commands
-- 'getLastThingSpeak' reads a channel and extracts the freshest data from the three first fields
-- Expected ThingSpeak data: uint[3] with LED intensity [Red;Green;Blue] from 0-1024. Caution! 0 can be confused in the code with zero-length data!) Use -1 for off instead.

-- Talkback mode (get and execute mode): Utilized by 'getThingSpeak()'
THINGSPEAK_API = "api.thingspeak.com";
TALKBACK_API_KEY = "yyyyyyyyyyyyyy"
TALKBACK_ID = "xxxx"

-- Channel mode (read last post only): Utilized by 'getLastThingSpeak()'
CHANNEL_READ_ID = "xxxxx"
CHANNEL_READ_API = "yyyyyyyyyyyyyy"

print("Starting ThingSpeak Talkback Communication")

getNo = 0

function printLongLine()
  print(" - - - - - - - - - - - - - - - - - - - - ")
end

-- Get and "execute" (remove from cue) value from ThingSpeak TalkBack
function getThingSpeak()
    sockTS = nil
    sockTS = net.createConnection(net.TCP, 0)

    sockTS:on("disconnection", function(sock, payload)
        print("Socket disconnected")
		sock:close();
        collectgarbage();
    end)
	
    sockTS:on("receive", function(sock, payload)
		getNo = getNo+1
		
		if string.len(payload) < 20 then
			print("False receive: Sparse payload!")
			printLongLine()
			return
		end
	
		if (string.find(payload, "Status: 200 OK") == nil) then
            print("HTTP status NOK!")
			print(payload)
			printLongLine()
			return
        end
	
		lastline = ""
		for line in payload:gmatch("[^\r\n]+") do
			lastline = line
		end
		print("Last line of received data: "..lastline)
		
		print("Extracting all numbers: ")
		cnt=1
		numbers = {}
		for line in lastline:gmatch("[%d]+") do
			numbers[cnt] = tonumber(line)
			print("No "..cnt.." = "..numbers[cnt])
			cnt = cnt+1
		end
		
		-- Do something with the numbers extracted
		if #numbers < 1 then
			print("ERROR! No numbers in payload!")
		elseif #numbers < 3 then
			if numbers[1] == 0 then
				-- Data is of zero length = No new data found!
				print("No new data!")
				return
			end
			setRGB_PWM(numbers[1],numbers[1],numbers[1])
		else
			-- 3 or more data provided
			setRGB_PWM(numbers[1],numbers[2],numbers[3])
		end
		
		-- Debugging
		--print("\n\n"..payload)

	end)
 
	-- Callback at successful connection
    sockTS:on("connection", function(sock, payloadout)

		sendstring = "GET http://"..THINGSPEAK_API.."/talkbacks/"..TALKBACK_ID.."/commands/execute?api_key="..TALKBACK_API_KEY
		.. " HTTP/1.1\r\n"
        .. "Host: api.thingspeak.com\r\n"
        .. "Connection: close\r\n"
        .. "Accept: */*\r\n"
        .. "User-Agent: Mozilla/4.0 (compatible; esp8266 Lua; Windows NT 5.1)\r\n"
        .. "\r\n"
		
		printLongLine()
		print("Requesting TalkBack ID "..TALKBACK_ID)
        --print("Requesting TalkBack:\n"..sendstring);    
		--printLongLine()
		sock:send(sendstring)
    end)
 
    sockTS:connect(80,'api.thingspeak.com')
end


-- Peek at the last values in specified data channel and API key
function readLastThingSpeak()
    sockTS = nil
    sockTS = net.createConnection(net.TCP, 0)
	
    sockTS:on("receive", function(sock, payload)
        getNo = getNo+1
		--print("Receive data:\n"..payload.."\n");
		
		if (string.find(payload, "Status: 200 OK") == nil) then
           	print("RCV #"..getNo..": HTTP NOK") 
			return
        end
		-- Everything is OK
		lastline = ""
		for line in payload:gmatch("[^\r\n]+") do
			lastline = line
		end
		--print("Last line on received data:\n"..lastline)

		numbers = {}
		cnt = 1
		for line in payload:gmatch("field%d+\":\"%d+\"-") do
			--print(line)
			tmp = string.gsub(line,"field%d+\":\"","")
			numbers[cnt] = tonumber(tmp)
			--print(tmp.." = "..numbers[cnt])
			cnt = cnt+1
		end
		--print("Numbers extracted: ")
		--for key,value in pairs(numbers) do print("  "..key.." = "..value) end

		-- Do something with the numbers extracted
		if #numbers < 1 then
			print("ERROR! No numbers in payload!")
			return
		elseif #numbers < 3 then
			if numbers[1] == 0 then
				-- Data is of zero length = No new data found!
				print("No new data! data[1] = 0")
				return
			end
			setRGB_PWM( numbers[1], numbers[1], numbers[1] )
		else
			-- 3 or more data provided
			setRGB_PWM( numbers[1], numbers[2], numbers[3] )
		end
		print("RCV #"..getNo..": HTTP OK. RGB data: ".. numbers[1].." "..numbers[2].." "..numbers[3])
    end)
 
	-- Callback at successful connection 
    sockTS:on("connection", function(sock, payloadout)
 
		sendstring = "GET /channels/"..CHANNEL_READ_ID.."/feeds/last?api_key="..CHANNEL_READ_API
        .. " HTTP/1.1\r\n"
        .. "Host: "..THINGSPEAK_API.."\r\n"
        .. "Connection: close\r\n"
        .. "Accept: */*\r\n"
        .. "User-Agent: Mozilla/4.0 (compatible; esp8266 Lua; Windows NT 5.1)\r\n"
        .. "\r\n"

		print("Requesting last field entries in ThingSpeak channel "..CHANNEL_READ_ID)
		sock:send(sendstring)
    end)
 
    sockTS:connect(80,'api.thingspeak.com')
end