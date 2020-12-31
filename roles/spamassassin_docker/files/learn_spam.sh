#!/bin/bash
#
for i in $(ls -l /home/vmail/ | awk '{print $9}' | grep -v '^$'); do
  /opt/report_spam.pl /home/vmail/$i/Maildir/.Spam/cur/
  #rm -rf /home/vmail/$i/Maildir/.Spam/cur/*
  /opt/report_spam.pl /home/vmail/$i/Maildir/.Spam/new/
  #rm -rf /home/vmail/$i/Maildir/.Spam/new/*
done
