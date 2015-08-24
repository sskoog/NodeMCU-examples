<h1>NodeMCU-examples</h1>
Some simple experiments with ESP8266 running NodeMCU and lua, interfacing with sensors and ThingSpeak.com
<BR><BR>
The examples are developed using the following setup. It might work with other setups too, but be prepared to make minor adjustments.

<h2>Hardware used</h2>
<ul>
<li>
<p>ESP-12 NodeMCU0.9 dev-board with on-board USB-to-serial (http://www.dx.com/p/385190)</p>
</li>
<li>
<p>PIR sensor "I052116" based on the "biss0001" chip (http://www.dx.com/p/139624)</p>
</li>
<li>
<p>High-power RGB LED with FET-buffered outputs</p>
</li>
</ul>

<h2>Software used</h2>
LuaLoader 0.87
<BR>
<BR>
The Lua scripts uses a couple of timers for task timing. Make sure you are not merging with code that are using the same timer channels.
The init file initializes the WiFi connection. All other files using sockets assume a working WiFi connection and IP.
<b>CONFIGURE THE INIT FILE FIRST!</b>
