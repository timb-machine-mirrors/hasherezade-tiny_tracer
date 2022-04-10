 #!/bin/bash
 
<< 'MULTILINE-COMMENT'
Linux runner for Tiny Tracer
1. Download the latest Intel Pin, and unpack it into your home directory, under the name "pin"
2. Compile tiny_tracer in both 64 and 32 bit version:
   + Make sure that tiny_tracer source is in ~/pin/source/tools/tiny_tracer
   + Go to tiny_tracer directory
   + Issue `make_linux.sh` to compile both 32-bit and 64-bit version. If everything went fine, you will obtain: `obj-ia32/TinyTracer.so` and: `obj-intel64/TinyTracer.so`
3. Now you can use the current script (`tiny_runner.sh`) to run your apps via TinyTracer.
4. To make the script runnable from any directory, you can add a symbolic link to your local `bin` directory. Example:
   ln -s /home/tester/pin/source/tools/tiny_tracer/tiny_runner.sh ~/bin/tiny_runner.sh

MULTILINE-COMMENT

echo "Linux runner for Tiny Tracer"
echo "Usage: <target_app> [target_module*]"
echo "*-optional; default: target app's main module"
 
if [ -z "$1" ]; then
  echo "ERROR: Target app not supplied."
  exit
fi

TARGET_APP=$1
echo "Traced App: $TARGET_APP";

TRACED_MODULE=$TARGET_APP

if [ -n "$2" ]; then
  TRACED_MODULE=$2
  echo "Traced Module: $TRACED_MODULE";
fi

TRACED_MODULE_BASENAME=`basename $TRACED_MODULE`

if [ -z "$TRACED_MODULE_BASENAME" ]; then
  echo "ERROR: Invalid path to the traced module."
  exit
fi

echo "Traced Module Name: $TRACED_MODULE_BASENAME";

TAG_FILE=$TRACED_MODULE".tag"

PIN_DIR=$HOME"/pin/"

PIN_TOOLS_DIR=$PIN_DIR"/source/tools/tiny_tracer/"

PIN_INSTALL_DIR64=$PIN_TOOLS_DIR"/obj-intel64/"
PIN_INSTALL_DIR32=$PIN_TOOLS_DIR"/obj-ia32/"

APP_TYPE=`file $TARGET_APP`

ELF_64="ELF 64-bit"
ELF_32="ELF 32-bit"

if [[ $APP_TYPE == *"$ELF_64"* ]];
then
    echo "The app is 64 bit."
    PIN_INSTALL_DIR=$PIN_INSTALL_DIR64
elif [[ $APP_TYPE == *"$ELF_32"* ]];
then
    echo "The app is 32 bit."
    PIN_INSTALL_DIR=$PIN_INSTALL_DIR32
else
    echo "ERROR: Not supported file type."
    exit
fi

PIN_CONFIGS_DIR=$PIN_TOOLS_DIR"/install32_64/"

SETTINGS_FILE=$PIN_CONFIGS_DIR"/TinyTracer.ini"

WATCH_BEFORE=$PIN_CONFIGS_DIR"/params.txt"

echo $SETTINGS_FILE
echo $WATCH_BEFORE

$PIN_DIR/pin -t $PIN_INSTALL_DIR/TinyTracer.so -s $SETTINGS_FILE -b $WATCH_BEFORE -m $TRACED_MODULE_BASENAME -o $TAG_FILE -- $TARGET_APP


