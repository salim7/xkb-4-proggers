#!/bin/bash

SYMBOLS_PATH="/usr/share/X11/xkb/symbols/"
EVDEV_PATH="/usr/share/X11/xkb/rules/evdev.xml"
EVDEV_RULE="/usr/share/X11/xkb/rules/evdev"

# directory of this script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# get current keyboard layout
CURRENT_LAYOUT=$(setxkbmap -v | awk -F "+" '/symbols/ {print $2}')

clear
echo "=============================================="
echo "== XKB-4-PROGGERS                           =="
echo "==   Adds a keyboard layout practical for   =="
echo "==   developers with non-US keyboards.      =="
echo "== ---------------------------------------- =="
echo "== https://github.com/salim7/xkb-4-proggers =="
echo "=============================================="
echo ""
echo "=== LAYOUT INFORMATION ======================="
echo " * Caps-Lock becomes the new modifier key"
echo " * [SHIFT]+[CAPS-LOCK] is the new Caps-Lock"
echo " * [CAPS-LOCK]+[A]: '"
echo " * [CAPS-LOCK]+[S]: \""
echo " * [CAPS-LOCK]+[D]: \\"
echo " * [CAPS-LOCK]+[F]: ["
echo " * [CAPS-LOCK]+[G]: ]"
echo " * [CAPS-LOCK]+[H]: \`"
echo " * [CAPS-LOCK]+[J]: {"
echo " * [CAPS-LOCK]+[K]: }"
echo " * [CAPS-LOCK]+[L]: /"
echo " * [CAPS-LOCK]+[Ö]: ;"

echo ""
read -p "Your current layout ($CURRENT_LAYOUT) will be used as a basis. Continue? [Y/n] " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Nn]$ ]]
then
  echo "Cancelled"
  echo
  exit
fi


# copy the template
echo ""
echo "==> preparing the new layout..."
cp $DIR/prg.template $DIR/prg

# replace the current keyboard layout in layout template
sed -i -e "s/%CURRENT_LAYOUT%/${CURRENT_LAYOUT}/g" $DIR/prg
echo "==> created new keyboard layout: $DIR/prg"

echo ""
echo "==> Copying original files for backup..."
set -x
cp $EVDEV_PATH evdev.xml.bak
cp $EVDEV_RULE evdev.bak
set +x

echo ""
echo "I will need sudo now to move the new layout to $SYMBOLS_PATH and edit $EVDEV_PATH and $EVDEV_RULE"

sudo mv $DIR/prg $SYMBOLS_PATH

# register the layout in evdev.xml
NEW_EVDEV_LAYOUT="  <layout>\\
      <configItem>\\
        <name>prg<\/name>\\
        <shortDescription>pr<\/shortDescription>\\
        <description>${CURRENT_LAYOUT}-Programming<\/description>\\
      <\/configItem>\\
    <\/layout>\\
  <\/layoutList>"

echo ""
echo -n "==> Adding prg as a new keyboard-layout..."
if grep -Fq "<name>prg</name>" $EVDEV_PATH
then
  echo ""
  echo "WARN: Programming layout (prg) already exists in $EVDEV_PATH, skipping..."
else
  sudo sed -i -e "s/<\/layoutList>/$NEW_EVDEV_LAYOUT/g" $EVDEV_PATH
  echo " [OK]"
fi

# modify the rule in evdev such that gnome keyboard daemon does not overwrite the second layout group
echo ""
echo -n "==> Modifying evdev-rules..."
NEW_EVDEV_RULE="\\
 * $CURRENT_LAYOUT = +$CURRENT_LAYOUT"
if grep -q "\\s\+\\*\\s\+$CURRENT_LAYOUT\\s\+=\\s\++$CURRENT_LAYOUT" $EVDEV_RULE
then
  echo ""
  echo "WARN: $EVDEV_RULE already modified... skipping"
else
  sudo sed -i -e "s/\!\\s\+model\\s\+layout\[2\]\\s\+=\\s\+symbols\\s*$/&$NEW_EVDEV_RULE/g" $EVDEV_RULE
  echo " [OK]"
fi

echo ""
echo "==> Deleting XKB cache: sudo dpkg-reconfigure xkb-data"
sudo dpkg-reconfigure xkb-data

echo ""
echo "=============================================="
echo "> Done. You can now use your new keyboard layout. Go to the input settings and add: ${CURRENT_LAYOUT}-Programming"
echo ""