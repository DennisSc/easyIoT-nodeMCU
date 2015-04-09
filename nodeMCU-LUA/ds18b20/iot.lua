owpin = 4
easyiot_username = "admin"
easyiot_password = "test"
easyiot_port = 80
easyiot_server = "192.168.1.23"
easyiot_node_address = "N7S0"

-- character table string
local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'



function sendStatus(temperature)

command = 'ControlLevel/'..temperature
--print(command)

conn = nil
conn=net.createConnection(net.TCP, 0) 

-- send status to sensor node

conn:on("receive", function(conn, payload) 
                       success = true
                       print(payload) 
                       end) 

-- when connected, request page (send parameters to a script)
conn:on("connection", function(conn, payload) 
                       print('\nConnected') 
                       conn:send("POST /Api/EasyIoT/Control/Module/Virtual/"..easyiot_node_address.."/"..command.." HTTP/1.1\r\n" 
                        .."Host: "..easyiot_server.."\r\n" 
                              .."Content-Length: 0\r\n" 
                            .."Connection: keep-alive\r\n"
                            .."Authorization: Basic "..credentals.."\r\n"
                        .."Accept: */*\r\n" 
                        .."User-Agent: Mozilla/4.0 (compatible; esp8266 Lua; Windows NT 5.1)\r\n" 
                        .."\r\n")
                       end) 
-- when disconnected, let it be known
conn:on("disconnection", function(conn, payload) 
     print('\nSend status') 
     end)
                                             
conn:connect(easyiot_port, easyiot_server) 
end



 
 
-- encoding basic authorization
function enc(data)
    return ((data:gsub('.', function(x) 
        local r,b='',x:byte()
        for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end
        return r;
    end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
        if (#x < 6) then return '' end
        local c=0
        for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end
        return b:sub(c+1,c+1)
    end)..({ '', '==', '=' })[#data%3+1])
end 
 
 
credentals = enc(easyiot_username..":"..easyiot_password)

t=require("ds18b20")
t.setup(owpin)
addrs=t.addrs()
temperature1 = t.read()
t = nil
ds18b20 = nil
package.loaded["ds18b20"]=nil

print(temperature1)

sendStatus(temperature1)
conn = nil
