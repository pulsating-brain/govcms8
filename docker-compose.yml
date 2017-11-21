version: '2'
services:
  web:
    image: govcms/govcms8
    ports: 
      - 80:80
      - 443:443
    hostname: demo.mark-fuller.net.au
    links:
      - database
    depends_on:
      - database
    volumes:
      - /var/website-backups:/var/website-backups
    environment:
      MTSQL_ROOT_PASSWORD: mysqlpass
  database:
    image: mariadb:10.1.21
    environment:
      MYSQL_ROOT_PASSWORD: mysqlpass
    command:
      --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci
    volumes:
      - /var/website-backups:/var/website-backups
      
