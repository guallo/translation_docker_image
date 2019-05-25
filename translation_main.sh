#!/usr/bin/env bash

echo "starting translation_service..."
> /opt/translation_logs/service.log;
python -u /opt/translation_service/bin/__main__.py 2>&1 > /opt/translation_logs/service.log &
while ! grep -qs "Entering main loop" /opt/translation_logs/service.log
do
    sleep 1
    echo "waiting for translation_service to start"
done

echo "starting translation_hub_en_es..."
> /opt/translation_logs/hub_en_es.log
python -u /opt/translation_hub_en_es/bin/__main__.py 2>&1 > /opt/translation_logs/hub_en_es.log &
while ! grep -qs "Entering main loop" /opt/translation_logs/hub_en_es.log
do
    sleep 1
    echo "waiting for translation_hub_en_es to start"
done

echo "starting translation_hub_es_en..."
> /opt/translation_logs/hub_es_en.log
python -u /opt/translation_hub_es_en/bin/__main__.py 2>&1 > /opt/translation_logs/hub_es_en.log &
while ! grep -qs "Entering main loop" /opt/translation_logs/hub_es_en.log
do
    sleep 1
    echo "waiting for translation_hub_es_en to start"
done

trap "echo TRAPed signal, exiting..." HUP INT QUIT TERM

echo "[hit enter to exit] or run 'docker stop `hostname`'"
read

echo "finishing translation_hub_en_es..."
kill -SIGINT `ps -ao pid=,command= | grep "translation_hub_en_es/bin/__main__\\.py" | grep -v grep | grep -oE "[0-9]+"`
while ! grep -qs "Finished main loop" /opt/translation_logs/hub_en_es.log
do
    sleep 1
    echo "waiting for translation_hub_en_es to finish"
done

echo "finishing translation_hub_es_en..."
kill -SIGINT `ps -ao pid=,command= | grep "translation_hub_es_en/bin/__main__\\.py" | grep -v grep | grep -oE "[0-9]+"`
while ! grep -qs "Finished main loop" /opt/translation_logs/hub_es_en.log
do
    sleep 1
    echo "waiting for translation_hub_es_en to finish"
done

echo "finishing translation_service..."
kill -SIGINT `ps -ao pid=,command= | grep "translation_service/bin/__main__\\.py" | grep -v grep | grep -oE "[0-9]+"`
while ! grep -qs "Finished main loop" /opt/translation_logs/service.log
do
    sleep 1
    echo "waiting for translation_service to finish"
done

echo "exited $0"
