#!/bin/sh
echo " pre init script"
### skript zum erstellen .htacces und .htpasswd
echo 'AuthType Basic' > $HOME/.htaccess
echo 'AuthName '$(cat /tmp/phpmyadmin-basicauth-secret/phpmyadmin-authname) >>  $HOME/.htaccess
echo 'AuthUserFile /tmp/.htpasswd' >>  $HOME/.htaccess
echo 'Require user ' $(cat /tmp/phpmyadmin-basicauth-secret/phpmyadmin-username) >>  $HOME/.htaccess
htpasswd -b -c /tmp/.htpasswd $(cat /tmp/phpmyadmin-basicauth-secret/phpmyadmin-username) $(cat /tmp/phpmyadmin-basicauth-secret/phpmyadmin-password)
