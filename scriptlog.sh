#===================================
# Script Name   : scriptlog.sh
# Description   : This script outputs the operation log for each user to the specified directory.
#===================================

LOGDIR=/var/log/script
LOGFILE=\`whoami\`.log

P_PROC=`ps -ef|grep $PPID|grep bash|awk '{print $8}'`

if [ "`whoami`" != "root" ] && [ "$P_PROC" = -bash ];then
  #/bin/script -faq ${LOGFILE}
  # タイムスタンプを追加
  /bin/script -fq >(awk '{print strftime("%F %T "), $0} {fflush() }'>> ${LOGDIR}/${LOGFILE})
  exit
fi

cat <<EOF >/etc/logrotate.d/scriptlog
/var/log/script/*.log
{
    daily
    rotate 93
    missingok
    notifempty
    copytruncate
    dateext
    dateformat .%Y%m%d
    compress
    su root root
}
EOF
