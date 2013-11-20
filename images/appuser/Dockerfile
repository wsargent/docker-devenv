FROM internal_registry:5000/base

# install user
run useradd -m -G root,adm,www-data,staff --home /home/appuser --shell /bin/zsh appuser
run echo "appuser:appuser" | chpasswd
run chmod 755 /home/appuser -R
run echo "appuser ALL=(ALL) ALL" > /etc/sudoers