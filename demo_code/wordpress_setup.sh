# こちらも今回は使用しない

# RDSのエンドポイントを入力
DatabaseHost=


# DBのパスワードを入力
DbPass=Zaq12wsx

mysql -uroot -p$DbPass -h$DatabaseHost -e "create user 'wordpress-user'@'$DatabaseHost' identified by 'wordpress';"
mysql -uroot -p$DbPass -h$DatabaseHost -e "create database wordpress;"
mysql -uroot -p$DbPass -h$DatabaseHost -e "grant all privileges on wordpress.* to 'wordpress-user'@'$DatabaseHost' identified by 'wordpress';"
mysql -uroot -p$DbPass -h$DatabaseHost -e "flush privileges;"