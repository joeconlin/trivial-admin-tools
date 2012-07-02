Summary
===========

User this script if you're migrating many exchange mailboxes and want to do so in a semi automated manner. Using this script, along with the windows task scheduler, you can segregate users being moved and to whichever mailbox DB you prefer.

Usage
===========

* Put this directory of scripts on one of your Exchange 2010 servers (something with access to the Exchange powershell). You will need to update the file and folder paths accordingly so things are saved in the right places.

* Update the variables in move.ps1 to match your needs (emails, mailbox db names, etc)

* Create a job in your windows task scheduler to execute the script, run as a user with Exchange admin privileges. I use a wrapper batch file for starting this because the windows task scheduler is a pain in the ass and this made it execute more reliably. 

* After the script runs, you will get an email alerting you of its completion, along with a log file of the actions taken. The log file will show you the output of the move commands, so look for any errors that might happen to appear. 