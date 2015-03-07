--
--print("init")
--dofile("dht22.lua").read(4,false,false)
--tmr.delay(1000000)
--print("read")
--myval = dofile("dht22.lua").read(4,false,false)
--print(myval)
--


print("Initializing...")
print("reading last dimmer value from memory..")
file.open("value.txt","r")
LED1_current = tonumber(file.readline())
file.close()
print("read "..LED1_current.."\r\n")


SWITCH1_state = 0
LED1_target=000


pwm.setup(3, 1000, LED1_current)
pwm.start(3)


Fadetime1=1000

Stepcounter1=0
PosStepcounter1=0
DimTimer1=0


wifi.setmode(wifi.STATION)
wifi.sta.config("MYSSID","MYPASSWORD")



srv=net.createServer(net.TCP) 
  srv:listen(43333,function(conn) 
    conn:on("receive",function(conn,payload)
    	
     	print("Input: "..payload) 
     	if string.find(payload,"GETTEMP") then
		print("Received temperature request")
		--print("init")
      		dofile("dht22.lua").read(4,false,false)
      		tmr.delay(1000000)
      		print("reading value")
      		myval = (dofile("dht22.lua").read(4,false,false)/10)
      		print("read "..myval)
		conn:send(myval)
	  
     	elseif string.find(payload,"GETHUM") then
     		print("Received humidity request")
     		--print("init")
     		dofile("dht22.lua").read(4,false,true)
     		tmr.delay(1000000)
     		print("reading value")
      		myval = (dofile("dht22.lua").read(4,false,true)/10)
      		print("read "..myval)
      		conn:send(myval)

     	elseif string.find(payload,"SWITCH1") then
     		SWITCH1_state=tonumber(string.sub(payload, 9) )
     		print("Received SWITCH1 target Value: "..SWITCH1_state)
        	if SWITCH1_state == 1 then
        		pwm.setduty(3, 1023)
          		LED1_current = 1023
		elseif SWITCH1_state == 0 then
        		pwm.setduty(3, 0)
          		LED1_current = 0
        	end
		print("saving dimmer value to memory..")
		file.open("value.txt","w")
		file.writeline(LED1_current)
		file.close()
     

     
     	elseif string.find(payload,"LED1") then
    		LED1_target=tonumber(string.sub(payload, 13) )
     		print("Received LED1 Target Value: "..LED1_target)
		print("saving dimmer value to memory..")
		file.open("value.txt","w")
		file.writeline(LED1_target)
		file.close()
     
     		Stepcounter1=(LED1_target)-(LED1_current)
     
     		if (Stepcounter1) < 0 then
      			PosStepcounter1=(Stepcounter1)*-1
      		else PosStepcounter1=(Stepcounter1)
     		end
     
     		if (PosStepcounter1) == 0 then
      			PosStepcounter1=(PosStepcounter1)+1
      		else PosStepcounter1=(PosStepcounter1)
     		end
          
     		DimTimer1=(Fadetime1)/(PosStepcounter1)

     		if (DimTimer1) == 0 then 
      			DimTimer1=(DimTimer1)+1
      		else DimTimer1=(DimTimer1)
     		end

      		print (Fadetime1)
	      	print (Stepcounter1)
      		print (PosStepcounter1)
      		print (DimTimer1)
      		print (LED1_current)
      		print (LED1_target)


	   	tmr.alarm(0, (DimTimer1), 1, function() 
     			if LED1_current < LED1_target then 
      				LED1_current = (LED1_current + 1) 
      				pwm.setduty(3, LED1_current)
    			elseif LED1_current > LED1_target then 
      				LED1_current = (LED1_current - 1) 
      				pwm.setduty(3, LED1_current)
    			elseif LED1_current == LED1_target then 
    				tmr.stop(0)
     			end
     		end) --end timer function

     end -- end if
     
    end) -- end srv conn:on receive function

    conn:on("sent",function(conn)
        print("Closing connection")
        conn:close()
    end) -- end srv conn:on sent function

  end) -- end srv:listen function

print ("easyIoT dimmer/switch/temperature sensor for nodeMCU")
print ("Based on QuinLED_ESP8266_V0.4")
print ("Version 0.6 (c) 2015 by DennisSc")
