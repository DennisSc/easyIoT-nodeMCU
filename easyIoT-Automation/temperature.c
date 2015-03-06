const String ESP8266_IP_ADDRESS = "192.168.0.100";
const String NODE_ADDRESS = "N5S0";
/*
  This code is running one time when program is enabled
*/
public void Setup()
{
}
/*
  This code is running periodicaly when program is enabled. 
  Cron job detirmine running period.
*/
public void Run()
{
  String response = QueryServer("GETTEMP");
  Console.WriteLine(response);
  ModuleHelper.SetProperty("Virtual", NODE_ADDRESS, "Sensor.Temperature", response.ToString());
  EventHelper.SetEvent("Virtual", NODE_ADDRESS, "Sensor.Temperature");
}
private static string QueryServer(String message)
{
try
	{
		Console.WriteLine("TCP client command: " + message + "\r\n");
		Int32 port = 43333;
		System.Net.Sockets.TcpClient client = new System.Net.Sockets.TcpClient( ESP8266_IP_ADDRESS, port);
		Byte[] data = System.Text.Encoding.ASCII.GetBytes(message);
		System.Net.Sockets.NetworkStream stream = client.GetStream();
		stream.Write(data, 0, data.Length);
		
		data = new Byte[256];
		String responseData = String.Empty;
		Int32 bytes = stream.Read(data, 0, data.Length);
		responseData = System.Text.Encoding.ASCII.GetString(data, 0, bytes);
		// Close everything.
		stream.Close();
		client.Close();
		return responseData;
	}
	catch(Exception e)
	{
		Console.WriteLine(e + "\r\n");
      Console.WriteLine(e.StackTrace + "\r\n");
	}
		
return "0.00";
}
