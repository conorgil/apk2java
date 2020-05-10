#!/bin/sh

##
# Variables
##
echo "apk file: $1"
APK_PATH=$1
APK_NAME=$(basename ${1})
DIRECTORY=$(dirname ${1})

##
# Command helpers
##
dex2jar="/opt/dex-tools-${DEX2JAR_VERSION}/d2j-dex2jar.sh"
cfr="java -jar /opt/cfr.jar"
jd="/opt/jd-cli"

##
# Let the work begin!
##

# Verify that 7z is installed
command -v 7z >/dev/null 2>&1 || { echo >&2 "This script requires 7z.  Aborting."; exit 1; }

# Display usage if zero arguments are provided
if [ $# -eq 0 ]
  then
    echo "Usage: extract.sh <test.apk>"
    exit 1
fi

# Extract files from the APK
echo "[7z] Extracting files from the APK to: $APK_PATH.files/"
mkdir $APK_PATH.files
7z x $APK_PATH -o$APK_PATH.files/

echo "[dex2jar] Creating temporary JAR file: $APK_NAME.jar"
$dex2jar $APK_PATH -o $APK_NAME.jar

echo "[CFR] Decompiling JAR file to Java source files. Output dir: $APK_PATH.cfr.src/"
$cfr --outputdir $APK_PATH.cfr.src/ $APK_NAME.jar

# echo "[jd-cli] Decompiling JAR file to Java source files. Output dir: $APK_PATH.jdcli.src/"
# $jd --logLevel $JD_CLI_LOG_LEVEL --outputDir $APK_PATH.jdcli.src/ $APK_NAME.jar

echo "Removing temporary JAR file: $APK_NAME.jar"
rm $APK_NAME.jar
