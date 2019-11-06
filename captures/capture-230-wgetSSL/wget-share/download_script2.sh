#!/bin/sh

sleep 10
CERT=/usr/share/scripts/cacert.pem

while true
do
SITE=$(shuf -n 1 /usr/share/scripts/top-10k.txt)
WEBSITE=${SITE#*,}
HTTPS=https://$WEBSITE
wget --recursive -l 5 -H --page-requisites --connect-timeout=10 --tries=5 --html-extension --convert-links --header "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/69.0.3497.100 Safari/537.36" --header "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" --header "Accept-Language: en-US,en;q=0.5" --header "Accept-Encoding: gzip, deflate" --ca-certificate $CERT $HTTPS -P /downloads
done
