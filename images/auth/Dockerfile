from server:4444/base:latest
# install user
run useradd -m -G root,adm,www-data,staff --shell /bin/bash appuser
run echo "appuser:\$1\$..." | chpasswd -e
run chmod 755 /home/appuser -R
run echo "appuser ALL=(ALL) ALL" > /etc/sudoers