#!/bin/sh

#// Данный скрипт предназначен для формирования резервного копирования баз postgres 
#// и отправка уведомления об этом на электронную почту
#//
#// This script is designed to create a backup of postgre and
#// and send notification of this to e-mail

#/////////////   Устанавливаем дату и другие реквизиты  //////////////////////////
DATA=`date +"%Y-%m-%d_%H-%M"`
PATHCORE=/home/user/backups
BACKUPRES=$PATHCORE/backupres.log
FORBODY=$PATHCORE/backupres_log.txt
n=1048576
#// Перечисление наименование баз перечислены через '\n'
#// Enumeration of database name are listed through '\n'
LISTBASE=$'listOne\nlistTwo\nlistThree\nlistFour\nlistFive'

#////////////  Бэкапим базу данных base1c и сразу сжимаем /////////////////////////
while read -r line; do

        #проверить наличие папки
        if [ -d "$line" ]
        then
        #       echo "Check folder - $line succesfully!"
        /usr/bin/pg_dump -U postgres -c $line | pigz > $PATHCORE/$line/$DATA-$line.dump.gz
        else
        #       echo "Folder $1 not exist. Create..."
        mkdir -p $PATHCORE/$line
        /usr/bin/pg_dump -U postgres -c $line | pigz > $PATHCORE/$line/$DATA-$line.dump.gz
        fi

#//////////////////////////   delete old files  ////////////////////////////////////
oldfile=`ls -1rt $PATHCORE/$line | head -1`
path=$PATHCORE/$line
colfile=`ls $PATHCORE/$line/ | wc -l`
if [ $colfile -gt 4 ]
then
rm $path/$oldfile
fi
find $path -type f -mtime +30 -exec rm -f {} \;

done <<< "$LISTBASE"

#/////////////////////////////   logging file backup //////////////////////////////
# Записываем информацию в лог с секундами
echo " \n  " >> $BACKUPRES
echo " \n  " >> $FORBODY

echo "Start backup base1c from `date +"%Y-%m-%d_%H-%M-%S"`\n  " >> $BACKUPRES
echo "Start backup base1c from `date +"%Y-%m-%d_%H-%M-%S"`\n  " >> $FORBODY

echo "One es databases backed up as scheduled \n  " >> $BACKUPRES
echo "One es databases backed up as scheduled \n  " >> $FORBODY

#transition name base postrgress
echo " \n  " >> $BACKUPRES
echo " \n  " >> $FORBODY

while read -r linee; do
for file in `find $PATHCORE/$linee/ -type f`
do
sum=`stat --printf="%s" $file`
result=`LC_NUMERIC="en_US.UTF-8" printf %.2fMb $(echo "$sum/$n" | bc -l)`
shortfile=`basename $file`
   echo  $shortfile "  " $result "\n  " >> $BACKUPRES
   echo  $shortfile "  " $result "\n  " >> $FORBODY
done

echo " \n  " >> $BACKUPRES
echo " \n  " >> $FORBODY
done <<< "$LISTBASE"

echo " end list\n  " >> $BACKUPRES
echo " end list\n  " >> $FORBODY

#///////////////////////////////  sending letter  ///////////////////////////////////

# Будет отображаться "От кого"
FROM=noreply@mail.ru
# Кому
MAILTO=technical@mail.ru
# Тема письма
NAME="postgres backup onec a scheduled operation serv"
# Тело письма
BODY=`cat $FORBODY`

SMTPSERVER=smtp.mail.ru
# Логин и ... от учетной записи
SMTPLOGIN=noreply@mail.ru
SMTPPASS=passemail

# Отправляем письмо
/usr/bin/sendEmail -f $FROM -t $MAILTO -o message-charset=utf-8  -u $NAME -m $BODY -s $SMTPSERVER -o tls=yes -xu $SMTPLOGIN -xp $SMTPPASS
echo " " > $FORBODY                                                                                                                                                    
