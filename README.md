# kmqtt
MQTT to Kronometrix Databus

## Description
The scope of MQTT to Kronometrix databus, is to allow data coming from one or many MQTT clients to be delivered to Kronometrix analytics platform.

## Functions

Kronometrix MQTT databus should be able to receive MQTT data messages from one or many MQTT clients, using the MQTT protocol and convert these messages to Kronometrix HTTP messages. Kronometrix MQTT databus should be able to perform the following core functions:

  * detect and receive push MQTT messages from a MQTT broker 
  
  * convert MQTT messages to valid Kronometrix data messages based on LMO data object defintions
  
  * send it forward to Kronometrix backend, using Kronometrix API
  
  * discard all the other traffic

## Input

  * MQTT data message

## Output

  * Kronometrix data message(s)
