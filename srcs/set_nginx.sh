rm /etc/nginx/sites-enabled/default
if [ $AUTOINDEX = "on" ]; then
	cp /root/autoindex_on/localhost.conf /etc/nginx/sites-available/
else 
	cp /root/autoindex_off/localhost.conf /etc/nginx/sites-available/
fi
ln -s /etc/nginx/sites-available/localhost.conf /etc/nginx/sites-enabled/localhost.conf

