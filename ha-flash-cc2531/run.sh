#!/bin/sh

CONFIG_PATH=/data/options.json
SHARE_DIR=/share

IS_COORDINATOR="$(jq '.coordinator' $CONFIG_PATH)"
IS_ZIGBEE3="$(jq '.zigbee3' $CONFIG_PATH)"
ROUTER_LEVEL=$(jq -r '.router_level' $CONFIG_PATH)
# start server
echo "Start flashing tool for cc2531.."
cd /flash_cc2531
echo "$(./cc_chipid)"
if ! ./cc_chipid | grep "ID = b524"; then echo "[ERROR] ChipID mismatch. Check the gpio wiring." && exit 1; fi

if [ "$IS_COORDINATOR" == "true" ]; then
  if [ "$IS_ZIGBEE3" == "true" ]; then
    echo "Select coordinator firmware for ver 3.0"
    echo "Download and Extract a firmware.."
    wget https://github.com/Koenkk/Z-Stack-firmware/raw/master/coordinator/Z-Stack_3.0.x/bin/CC2531_20190425.zip
    unzip CC2531_20190425.zip
    if [ ! -f CC2531ZNP-with-SBL.hex ]; then echo "[ERROR] Fail to download or extract. There is no hex file." && exit 1; fi
    echo "Found CC2531ZNP-with-SBL.hex. Flash firmware.."
    ./cc_erase
    ./cc_write CC2531ZNP-with-SBL.hex
  else
    echo "Select coordinator firmware for ver 1.2"
    echo "Download and Extract a firmware.."
    wget https://github.com/Koenkk/Z-Stack-firmware/raw/master/coordinator/Z-Stack_Home_1.2/bin/default/CC2531_DEFAULT_20190608.zip
    unzip CC2531_DEFAULT_20190608.zip
    if [ ! -f CC2531ZNP-Prod.hex ]; then echo "[ERROR] Fail to download or extract. There is no hex file." && exit 1; fi
    echo "Found CC2531ZNP-Prod.hex. Flash firmware.."
    ./cc_erase
    ./cc_write CC2531ZNP-Prod.hex
  fi
else
  echo "Select router firmware.."
  echo "Download and Extract a firmware.."
  wget https://github.com/Koenkk/Z-Stack-firmware/raw/master/router/CC2531/bin/CC2531_router_2019_02.zip
  unzip CC2531_router_2019_02.zip
  case $ROUTER_LEVEL in
    0)
      echo "ROUTER: standard firmware"
      if [ ! -f router-cc2531-std.hex ]; then echo "[ERROR] Fail to download or extract. There is no hex file." && exit 1; fi
      echo "Found router-cc2531-std.hex. Flash firmware.."
      ./cc_erase
      ./cc_write router-cc2531-std.hex
      ;;
    1)
      echo "ROUTER: firmware with additional diagnostic messages"
      if [ ! -f router-cc2531-diag.hex ]; then echo "[ERROR] Fail to download or extract. There is no hex file." && exit 1; fi
      echo "Found router-cc2531-diag.hex. Flash firmware.."
      ./cc_erase
      ./cc_write router-cc2531-diag.hex
      ;;
    2)
      echo "ROUTER: firmware with additional diagnostic messages and USB support"
      if [ ! -f router-cc2531-diag-usb.hex ]; then echo "[ERROR] Fail to download or extract. There is no hex file." && exit 1; fi
      echo "Found router-cc2531-diag-usb.hex. Flash firmware.."
      ./cc_erase
      ./cc_write router-cc2531-diag-usb.hex
      ;;
    *)
      echo "Unknown router_level. Choose 0, 1 or 2."
      ;;
  esac
fi
