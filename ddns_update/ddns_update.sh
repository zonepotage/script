#!/bin/sh
#chkconfig: 345 99 01


#DDNS自動更新Script

#Setting
LOGFILE="/usr/ddns/ip.log"
MYIPADDR="/usr/ddns/ipaddr.log"
DOMAIN="hostname.domain"
PASSWORD="updatepassword"
HOSTNAME="*"
URL="http://dyn.value-domain.com/cgi-bin/dyn.fcg?d=$DOMAIN&p=$PASSWORD&h=$HOSTNAME&i=$MYIPADDR"

#とりあえず記録
date >> $LOGFILE

#IPアドレス照合
NOWIP=`wget -q -O - http://dyn.value-domain.com/cgi-bin/dyn.fcg?ip`
PASTIP=`cut -f 1 $MYIPADDR`

#取得できなかった
if test "$NOWIP" = "" ; then
    echo "Getting IP address is Failed!!" >> $LOGFILE
    echo "*************************" >> $LOGFILE
    exit
fi

#変わってない
if test "$NOWIP" = "$PASTIP" ; then
    echo "IP address isn't changed." >> $LOGFILE
    echo "*************************" >> $LOGFILE
    exit
fi

#変わった
echo "IP address is changed to $NOWIP from $PASTIP" >> $LOGFILE
RES=`wget -q -O - $URL`
if [ `echo "$RES" | egrep "status=0"` ] ; then
    echo $NOWIP > $MYIPADDR
    echo "DDNS Updating is Successful." >> $LOGFILE
else
    echo "DDNS Updating is Failed!!!" >> $LOGFILE
fi
echo "*************************" >> $LOGFILE
exit

