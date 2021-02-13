# wordpress-xdebug-nginx

*example docker-compose.yml*
```yaml
version: "3.8"

services:
  db:
    container_name: wordpress_mysql
    image: mysql:5.7
    volumes:
      - db_data:/var/lib/mysql
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: somewordpress
      MYSQL_DATABASE: wordpress
      MYSQL_USER: wordpress
      MYSQL_PASSWORD: wordpress
    ports:
      - "4343:3306"
  wordpress:
    container_name: wordpress
    image: digitalreach/wordpress-xdebug-nginx
    depends_on:
      - db
    volumes:
      - ./wordpress:/var/www/html/
    ports:
      - "6707:80"
      - "6618:443"
      - "5733:2222"
    restart: always
    environment:
      WORDPRESS_DB_HOST: db:3306
      WORDPRESS_DB_USER: wordpress
      WORDPRESS_DB_PASSWORD: wordpress
      WORDPRESS_DB_NAME: wordpress
      SSH_PASSWORD: somesshpassword
volumes:
  db_data: {}
  ```
