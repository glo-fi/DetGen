#!/bin/sh

sleep 10
CERT=/usr/share/scripts/cacert.pem

while true
do
SITE=$(shuf -n 1 /usr/share/scripts/top-10k.txt)
WEBSITE=${SITE#*,}
HTTPS=https://$WEBSITE
wget --recursive -l 5 --page-requisites --connect-timeout=10 --tries=5 --html-extension --convert-links --header "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_2) AppleWebKit/601.3.9 (KHTML, like Gecko) Version/9.0.2 Safari/601.3.9" --header "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" --header "Accept-Language: en-US,en;q=0.5" --header "Accept-Encoding: gzip, deflate" --ca-certificate $CERT $HTTPS -P /downloads
done
