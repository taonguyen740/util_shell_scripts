chmod 644 /etc/profile.d/scriptlog.sh
cat <<EOF >/etc/profile.d/scriptlog.sh
#===================================
# Script Name   : scriptlog.sh
# Description   : This script outputs the operation log for each user to the specified directory.
#===================================

LOGDIR=/var/log/script
LOGFILE=\`whoami\`_\`date '+%Y%m%d%H%M%S'\`.log

P_PROC=\`ps -ef|grep \$PPID|grep bash|awk '{print \$8}'\`

if [ "\`whoami\`" != "root" ] && [ "\$P_PROC" = -bash ];then
  #/bin/script -faq \${LOGFILE}
  # タイムスタンプを追加
  /bin/script -faq >(awk '{print strftime("%Y-%m-%d %H:%M:%S "), \$0} {fflush() }'>> \${LOGDIR}/\${LOGFILE})
  exit
fi
EOF

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
