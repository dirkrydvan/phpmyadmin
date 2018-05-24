### skript zum erstellen .htacces und .htpasswd
echo 'AuthType Basic' > ../.htaccess
echo 'AuthName '$(cat /tmp/phpmyadmin-basicauth-secret/phpmyadmin-authname) >> ../.htaccess
echo 'AuthUserFile /tmp/.htpasswd' >> ../.htaccess
echo 'Require user ' $(cat /tmp/phpmyadmin-basicauth-secret/phpmyadmin-username) >> ../.htaccess
htpasswd -b -c /tmp/.htpasswd $(cat /tmp/phpmyadmin-basicauth-secret/phpmyadmin-username) $(cat /tmp/phpmyadmin-basicauth-secret/phpmyadmin-password)
