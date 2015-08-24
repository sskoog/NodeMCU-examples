-- Skoog init-lua file
-- Setup WiFi autoconnect to router and stay always-on
-- Change baud @ UART0
-- Launch runfile1 after 2 sec grace time

baud = 230400
uart.setup(0,baud,8,0,1,0)
-- Wait half a sec, prevent "baud rate bad"
tmr.delay(500000)
print("\n\nHello @ "..baud.." baud 8N1")

-- Define environment variables
runfile1 = "PIR2.lua"
runfile2 = "postThingSpeak.lua"
runfile3 = "LEDlib.lua"
SSID = "yourSSID"
SSID_PASSWORD = "yourPassword"

-- Chip & WiFi settings feedback
print("Chip:      ",node.chipid())
print("Heap:      ",node.heap())

wifi.setmode(wifi.STATION)
wifi.sta.config(SSID,SSID_PASSWORD,1)
wifi.sta.autoconnect(1)
uart.write(0,"Waiting for IP")
tmr.alarm(1, 500, 1, function()
  if (wifi.sta.getip()== nil) then
	  uart.write(0,".")
  else
    tmr.stop(1)
    print("\nWiFi mode: " .. wifi.getmode())
    print("MAC:       " .. wifi.ap.getmac())
    print("IP:        " .. wifi.sta.getip())
    --print("PhyMode:   "..wifi.getphymode())
    print("\nWill launch files in 2 seconds")
	print(" - - - - - - - - - - - - - - - - - - - - -\n")
    tmr.alarm(2,2000,0,function() dofile(runfile1) dofile(runfile2) dofile(runfile3) end )
  end
end)
