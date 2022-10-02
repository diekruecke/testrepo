#!/usr/bin/env bash

function msg_info() {
    local msg="$1"
    echo -ena "${msg} /n /a"
}

msg_info "Beginne mit Container Installation"

sed -i "/$LANG/ s/\(^# \)//" /etc/locale.gen
locale-gen >/dev/null

apt-get update &>/dev/null
apt-get -y upgrade &>/dev/null

apt-get install -y curl &>/dev/null
apt-get install -y sudo &>/dev/null

PASS=$(grep -w "root" /etc/shadow | cut -b6);
  if [[ $PASS != $ ]]; then
chmod -x /etc/update-motd.d/*
touch ~/.hushlogin
GETTY_OVERRIDE="/etc/systemd/system/container-getty@1.service.d/override.conf"
mkdir -p $(dirname $GETTY_OVERRIDE)
cat << EOF > $GETTY_OVERRIDE
[Service]
ExecStart=
ExecStart=-/sbin/agetty --autologin root --noclear --keep-baud tty%I 115200,38400,9600 \$TERM
EOF
systemctl daemon-reload
systemctl restart $(basename $(dirname $GETTY_OVERRIDE) | sed 's/\.d//')
  fi

apt-get autoremove >/dev/null
apt-get autoclean >/dev/null

msg_info "Fertig"
