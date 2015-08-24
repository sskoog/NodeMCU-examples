Post data to ThingSpeak channel field 1 with HTTP sockets.

'postThingSpeak.lua'
Sets up a socket and sends a GET request to ThingSpeak server.
API method used:
GET http://api.thingspeak.com/update?api_key=CHANNEL_API_KEY&field1=yourData

'init.lua'
Config this with your SSID and password before trying the scripts.

'LEDlib.lua'
Some wrappers to control the on-board 'system' LED.

'PIR2.lua'
Interfaces the cheap BIS0001-based pyroelectric movement sensor through pin polling.

