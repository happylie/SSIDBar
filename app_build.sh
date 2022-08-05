#!/usr/bin/env bash

export LANG="ko_KR.UTF-8"
export LC_ALL="ko_KR.UTF-8"
export HOME_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $HOME_PATH

DISPLAY=:0.0
export DISPLAY

date_format="+%Y-%m-%d %H:%M:%S"
echo -e "[+][$(date "$date_format")] Start SSIDBar App Build Script"

cd ~/Applications
export APP_PATH=`pwd -P`
if [ -d "${APP_PATH}/SSIDBar.app" ]
then
    echo -e "[+][$(date "$date_format")] Re Make Directory SSIDBar App"
    rm -r "${APP_PATH}/SSIDBar.app"
    mkdir -p "${APP_PATH}/SSIDBar.app/Contents/MacOS"
    mkdir "${APP_PATH}/SSIDBar.app/Contents/Resources"
else 
    echo -e "[+][$(date "$date_format")] Make Directory SSIDBar App"
    mkdir -p "${APP_PATH}/SSIDBar.app/Contents/MacOS"
    mkdir "${APP_PATH}/SSIDBar.app/Contents/Resources"
fi

cd $HOME_PATH
go mod download

if [ -e "err.log" ]
then
    rm err.log
    echo -e "[+][$(date "$date_format")] Make Errorlog File"
fi

GOMAXPROCS=1 go build -o SSIDBar 2>err.log

if [ -s "err.log" ]
then
    echo -e "[+][$(date "$date_format")] SSIDBar App Build Error"
    exit 2
fi

cp SSIDBar ${APP_PATH}/SSIDBar.app/Contents/MacOS
cp assets/AppIcon.icns ${APP_PATH}/SSIDBar.app/Contents/Resources
cp assets/info.plist ${APP_PATH}/SSIDBar.app/Contents
rm SSIDBar

echo -e "[+][$(date "$date_format")] End SSIDBar App Build Script"
