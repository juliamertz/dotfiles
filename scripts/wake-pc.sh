#!/bin/sh
#

timeout 50 bash -c "while true; do if ping -c1 -i1 8.8.8.8 &>/dev/null; then echo "up"; break; fi; done"

