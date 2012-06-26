#!/bin/bash
# Postini user dump
# Joe Conlin <joe@joeconlin.org> 

# Customization Settings
#Postini Info
PSTEMAIL="postini%40domain.com"  # url encoded value of your postini admin account
PSTPASS="your_url_encoded_password" # url encoded password value
ORGID="100000000" # put your Org ID here. This can be a parent org or a child org
PSTSYSTEM="ac-s7" # your Postini system. ac-s7 is for System 7. other systems are untested SORRY!

#email to send postini userlist to
email=support@domain.tld
message="Please see the attached spreadsheet for Postini user counts this period."

date=`date +%Y%m%d` #set todays date

file=/tmp/postiniusers${date}.csv #name of csv file

cookies=/tmp/pstcookie.txt # temp location  to store cookies

#------ End Customization ---------------# 

#this logs into postini and gets the session details
wget -O - --cookies=on --keep-session-cookies  --save-cookies $cookies --referer=https://login.postini.com/exec/login --post-data 'email=$PSTEMAIL&pword=$PSTPASS&Login.x=30&Login.y=14&action=login' https://login.postini.com/exec/login |grep adminstart | wget --keep-session-cookies  --load-cookies $cookies --save-cookies $cookies --force-html -i - -O /dev/null


# This gets the userlist
wget --cookies=on --keep-session-cookies  --save-cookies $cookies --load-cookies $cookies  'https://$PSTSYSTEM.postini.com/exec/admin_listusers_download?sortkeys=address%3Aa&type_of_user=all&lastorglist=&childorgs=1&type_of_encrypted_user=ext_encrypt_any&aliases=0&targetorgid=$ORGID&type=usersets&pagenum=1&pagesize=25' -O /tmp/users.txt

#this processes the userlist to give a count of users per domain, sorted
cat /tmp/users.txt | cut -d "," -f1 | cut -d '@' -f2 | sort -b -d -f | uniq -c | sort > $file

#now mail this sucker (requires Mutt to be installed!)
echo "$message" | mutt -a $file -s "Postini Userlist $date" $email

#Cleanup
rm -f $cookies $file /tmp/users.txt
