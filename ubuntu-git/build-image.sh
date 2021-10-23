#!/bin/bash

# builds the image using a shell script

# command-line parameter(s)

PARM_1=$1

echo "PARM_1: $PARM_1"
echo

# name of the image to build
IMAGE_NAME="keithroberts/ubuntu-git:latest"

# command to pass to docker to build the image
BUILD_COMMAND="$IMAGE_NAME $PARM_1"

echo "BUILD_COMMAND: $BUILD_COMMAND"
echo

START_TIME=$(date +"%d %B %Y %H:%M:%S.%N")
echo "START_TIME: $START_TIME"
echo

NANO_START_TIME=$(date +%s.%N)

# echo the user and hostname and full path to the build script
echo $USER@$HOSTNAME:"`pwd`\$ docker build -t $BUILD_COMMAND . | tee BUILD-NOTES" > BUILD-NOTES

echo "START_TIME: $START_TIME" >> BUILD-NOTES
echo >> BUILD-NOTES

# tell docker to build the image and pipe the build output to a file
docker build -t $BUILD_COMMAND . | tee -a BUILD-NOTES

END_TIME=$(date +"%d %B %Y %H:%M:%S.%N")

echo
echo "END_TIME: $END_TIME"

echo >> BUILD-NOTES
echo "END_TIME: $END_TIME" >> BUILD-NOTES

NANO_END_TIME=$(date +%s.%N)

BUILD_TIME=$(echo "$(date +%s.%N) - $NANO_START_TIME" | bc)

printf "Build time was: %.3f seconds \n" $BUILD_TIME | tee -a BUILD-NOTES
