print(wifi.sta.getip())

wifi.setmode(wifi.STATION)
wifi.sta.config("MYSSID","myP@ssW0rd")

tmr.delay(1000000)
node.compile("ds18b20.lua")
node.compile("iot.lua")

tmr.alarm(1, 10000, 1, function() 
     print(wifi.sta.getip()) 
     dofile('iot.lc') 
     end )