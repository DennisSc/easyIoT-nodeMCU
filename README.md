# easyIoT-nodeMCU
dimmer/switch/temperature scripts for nodeMCU, for interfacing with easyIoT home automation

this project intends to create home automation nodes based on ESP8266 wifi modules, and without the use of an additional
microcontroller. It can be roughly divided into two parts:

- the ESP8266 node, running nodeMCU firmware with additional lua scripts
- easyIoT home automation server to control the node

At current time, there are three types of node supported:

- mosFET-based dimmer
- relay switch
- dht11 moisture/temperature sensor

Tutorials on how to set up those node types and connect them to easyIoT will follow soon.
