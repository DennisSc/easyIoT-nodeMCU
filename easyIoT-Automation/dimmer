// dimmer node N3S0 (red LED)

const String ESP8266_IP_ADDRESS = "192.168.0.100";
const String NODE_ADDRESS = "N3S0";

/*
This code is running one time when program is enabled
*/
public void Setup()
{
	EventHelper.ModuleChangedHandler((o, m, p) =>
	{
		if (m.Domain == "Virtual" && m.Address == NODE_ADDRESS) 
		{
  			Console.WriteLine("\r\n"+ m.Domain +" "+ m.Address +" in program id "+ Program.ProgramId.ToString() +" property "+ p.Property +" value "+ p.Value);
          	Console.WriteLine("Program was triggered by change of "+ p.Property +" for node id "+ m.Address);
          	switch (p.Property)
            {
              case "Sensor.DimmerLevel":
              	int myVal;
  	          	myVal = ConvertRange(0, 100, 0, 1023, Convert.ToInt32(p.Value));
				Console.WriteLine("Mapped "+ p.Property  +" value of "+ p.Value +" to pwm value "+ myVal);
				sendCommand(myVal.ToString());
              	break;
              case "Sensor.DigitalValue":
              	Console.WriteLine("triggering \"Sensor.DimmerLevel\" event...\r\n");
              	sendToServer("SWITCH1="+p.Value);
              	ModuleHelper.SetProperty(m.Domain, m.Address, "Sensor.DimmerLevel", (Convert.ToInt32(p.Value)*100).ToString());
            	EventHelper.SetEvent(m.Domain, m.Address, "Sensor.DimmerLevel");
              	break;
              default:
              	break;
            } //end switch
        }//end if
	return true;
	});//end EventHelper
}

/*
This code is running periodicaly when program is enabled.
Cron job detirmine running period.
*/
public void Run()
{}

private void sendCommand(string value)
{
	sendToServer("LED1_target="+value); // LED1 - here we set channel
}

private void sendToServer(String message)
{
	try
	{
		Console.WriteLine("TCP client command:" + message + "\r\n");
		Int32 port = 43333;
		System.Net.Sockets.TcpClient client = new System.Net.Sockets.TcpClient( ESP8266_IP_ADDRESS, port);
		Byte[] data = System.Text.Encoding.ASCII.GetBytes(message);
		System.Net.Sockets.NetworkStream stream = client.GetStream();
		stream.Write(data, 0, data.Length);
		// Close everything.
		stream.Close();
		client.Close();
	}
	catch(Exception e)
	{
		Console.WriteLine(e.StackTrace + "\r\n");
	}
}

private static int ConvertRange(
    int originalStart, int originalEnd, // original range
    int newStart, int newEnd, // desired range
    int value) // value to convert
{
    double scale = (double)(newEnd - newStart) / (originalEnd - originalStart);
    return (int)(newStart + ((value - originalStart) * scale));
}

