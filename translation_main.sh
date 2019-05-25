#!/usr/bin/env bash

echo "starting translation_service..."
> /opt/translation_logs/service.log;
python -u /opt/translation_service/bin/__main__.py 2>&1 > /opt/translation_logs/service.log &
while ! grep -qs "Entering main loop" /opt/translation_logs/service.log
do
    sleep 1
    echo "waiting for translation_service to start"
done

echo "starting translation_hub..."
> /opt/translation_logs/hub.log
python -u /opt/translation_hub/bin/__main__.py 2>&1 > /opt/translation_logs/hub.log &
while ! grep -qs "Entering main loop" /opt/translation_logs/hub.log
do
    sleep 1
    echo "waiting for translation_hub to start"
done

trap "echo TRAPed signal, exiting..." HUP INT QUIT TERM

echo "[hit enter to exit] or run 'docker stop `hostname`'"
read

echo "finishing translation_hub..."
kill -SIGINT `ps -ao pid=,command= | grep "translation_hub/bin/__main__\\.py" | grep -v grep | grep -oE "[0-9]+"`
while ! grep -qs "Finished main loop" /opt/translation_logs/hub.log
do
    sleep 1
    echo "waiting for translation_hub to finish"
done

echo "finishing translation_service..."
kill -SIGINT `ps -ao pid=,command= | grep "translation_service/bin/__main__\\.py" | grep -v grep | grep -oE "[0-9]+"`
while ! grep -qs "Finished main loop" /opt/translation_logs/service.log
do
    sleep 1
    echo "waiting for translation_service to finish"
done

echo "exited $0"
