#!/bin/sh

sleep 10
CERT=/usr/share/scripts/cacert.pem

while true
do
SITE=$(shuf -n 1 /usr/share/scripts/non-existent.txt)
HTTPS=https://$WEBSITE
wget --recursive -l 5 --page-requisites --connect-timeout=10 --tries=5 --html-extension --convert-links --header "User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:54.0) Gecko/20100101 Firefox/54.0" --header "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" --header "Accept-Language: en-US,en;q=0.5" --header "Accept-Encoding: gzip, deflate" --ca-certificate $CERT $HTTPS -P /downloads
done
