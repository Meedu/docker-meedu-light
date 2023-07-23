FROM meeduxyz/api:4.9.2

COPY dist/pc /var/www/pc
COPY dist/h5 /var/www/h5
COPY dist/backend /var/www/backend

COPY nginx/meedu-interface.conf /etc/nginx/http.d/meedu-interface.conf

# 定时任务
RUN echo "php /var/www/artisan schedule:run >> /dev/null 2>&1" | crontab -

# 安装supervisor
RUN apk add supervisor
COPY supervisor/meedu-queue.ini /etc/supervisor.d/meedu-queue.ini

# 覆盖php-fpm的配置
COPY php/php-fpm.d/ww.conf /usr/local/etc/php-fpm.d/www.conf

ENTRYPOINT supervisord && nginx && php-fpm