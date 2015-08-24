-- Source: http://captain-slow.dk/2015/04/16/posting-to-thingspeak-with-esp8266-and-nodemcu/

CHANNEL_API_KEY = "yyyyyyyyyyyyyyyy" -- Movement channel. Field1: PIR1

print("Starting ThingSpeak communication")

postNo = 0

function postThingSpeak(sendData)
    connout = nil
    connout = net.createConnection(net.TCP, 0)
 
    connout:on("receive", function(connout, payloadout)
        if (string.find(payloadout, "Status: 200 OK") ~= nil) then
            uart.write(0," OK!\n\n ");
        else
		    uart.write(0," ERROR! Reason: \n"..payloadout.."\n");
        end
    end)
 
    connout:on("connection", function(connout, payloadout)
 
        uart.write(0,"Posting no "..postNo.."...");    
 
        connout:send("GET /update?api_key="..CHANNEL_API_KEY.."&field1=" .. sendData
        .. " HTTP/1.1\r\n"
        .. "Host: api.thingspeak.com\r\n"
        .. "Connection: close\r\n"
        .. "Accept: */*\r\n"
        .. "User-Agent: Mozilla/4.0 (compatible; esp8266 Lua; Windows NT 5.1)\r\n"
        .. "\r\n")
    end)
 
    connout:on("disconnection", function(connout, payloadout)
        connout:close();
        collectgarbage();
    end)
 
    connout:connect(80,'api.thingspeak.com')
	postNo = postNo+1
end
 
