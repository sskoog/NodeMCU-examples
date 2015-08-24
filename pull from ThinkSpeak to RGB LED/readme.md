Read data from ThingSpeak cloud service with HTTP sockets.

function getThingSpeak()
Reads and executes the highest priority task from ThingSpeak TalkBack app and extracts three bytes of data for a RGB power LED.
ThingSpeak API command used: 
GET http://api.thingspeak.com/talkbacks/TALKBACK_ID/commands/execute?api_key=API_KEY


function readLastThingSpeak()
Reads the last (newest) data from a specific ThingSpeak channel. Extracts three bytes from field1-3 and applies PWM to a RGB power LED accordingly.
ThingSpeak API command used: 
GET http://api.thingspeak.com/channels/CHANNEL_READ_ID/feeds/last?api_key=CHANNEL_READ_API

Add your channel and API keys in the 'getThingSpeak.lua' file.
The 'main.lua' file executes the periodic polling with sockets.

         