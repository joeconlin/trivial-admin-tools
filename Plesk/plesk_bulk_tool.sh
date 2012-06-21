#! binbash
# get a file with a list of elements to iterate through (domains, emails, etc)
# TODO: this should be set from command args so its not as jamokey. later..
FILE="items.txt"

# run as root
WHOAMI=`whoami`
if [ ! $WHOAMI == 'root' ]; then
    echo This script must run with root.
    exit 1
fi

if [ ! -f $FILE ]; then
    echo "$FILE file does not exit"
    exit 1
fi

# Start loop
# Example command. replace with the Plesk binary of your choosing
# ex: ./mail --create admin@example.com -cp-access true -passwd userpass -mbox_quota 50MB
while read EMAIL; do
/usr/local/psa/bin/mail.sh --update $EMAIL -cp-access false -mailbox false
done < $FILE ;