{
  writeShellScriptBin,
  wakeonlan,
  lib,
}:
# For a NIC on your local subnet, use the broadcast-address of this subnet.
# (e.g. subnet 192.168.10.0 with netmask 255.255.255.0, use 192.168.10.255)
writeShellScriptBin "wake" # sh
  ''
    case $1 in
      "workstation")       
        IP=192.168.0.255
        MAC_ADDRESS=04:7c:16:eb:df:9b
        ;;
      *)              
        echo No such device
        exit 1
    esac

    ${lib.getExe wakeonlan} -i $IP $MAC_ADDRESS
  ''

# Doesn't have a darwin package...
# ${lib.getExe wol} --verbose --ipaddr=$IP $MAC_ADDRESS
