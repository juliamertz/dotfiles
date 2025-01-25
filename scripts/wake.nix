{ mkScript, ... }:
mkScript [ "wake" "wol" ]
<|
  # sh
  ''
    # For a NIC on local subnet, use the broadcast-address of this subnet.
    # (e.g. subnet 192.168.10.0 with netmask 255.255.255.0, use 192.168.10.255)
    case $1 in
      "workstation")       
        IP=192.168.0.255
        MAC_ADDRESS=04:7c:16:eb:df:9b
        ;;
      *)              
        echo No such device
        exit 1
    esac

    wakeonlan -i $IP $MAC_ADDRESS
  ''
