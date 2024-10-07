#!/bin/sh

MAC_ADDRESS="2C:32:6A:D6:B4:B5"
STATUS=$(bluetoothctl info $MAC_ADDRESS)
FALLBACK_DEVICE="alsa_output.usb-Logitech_G735_Gaming_Headset-01.iec958-stereo"

if echo $STATUS | grep -q "Connected: yes"; then
    bluetoothctl disconnect $MAC_ADDRESS
    pactl set-default-sink $FALLBACK_DEVICE
else
    bluetoothctl connect $MAC_ADDRESS
    pactl set-default-sink bluez_output.$(echo $MAC_ADDRESS | tr '_' ':').1
fi  
