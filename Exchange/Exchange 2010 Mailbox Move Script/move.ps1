# move.ps1
# a script to enqueue mailbox accounts from a file list for exchange migration
# 

# use the exch powershell 
add-pssnapin Microsoft.Exchange.Management.PowerShell.E2010

# define the userlist, backed up userlist, and target mailbox store variables here.
$userlist = 'C:\users.txt'
$archived_userlist = 'C:\archived\'+'users-{0:yyyyMMdd-HHmm}.txt' -f (Get-Date)
$targetdb = '<your mailbox db>'

# log to this file
$log = 'C:\log\'+'move-{0:yyyyMMdd-HHmm}.log' -f (Get-Date)

#Notification addresses
$emfrom = 'sentfrom@email.com'
$emto = 'youremail@email.com'
$smtpserver = 'smtp.baloney.com'



#-- End Variables -- #


# check if the userlist is not blank
If ((Get-Content $userlist)) {

   # start the hackey shitty windows logging. 'better than nothing' - every windows utility
   Start-Transcript $log

   # enqueue the mailbox moves
   Get-Content $userlist |New-MoveRequest -TargetDatabase $targetdb -BadItem 40

   #backup the userlist and serialize it with the date.
   Move-Item $userlist $archived_userlist
   
   #Force creation of a new, clean userlist file
   New-Item $userlist -type file -force

   Stop-Transcript
   
   #hack for shitty windows log formatting
   $a = Get-Content $log
   $a > $log

   # email the log
   Send-MailMessage -To $emto -From $emfrom -subject "Results of Exchange Migration Script Run" -Body "We found users added to the migration file so we have attempted to enqueue them for migration. here is the output from the exchange user migration script run for tonight." -SmtpServer $smtpserver -Attachments $log

}