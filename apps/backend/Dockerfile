FROM node:bullseye-slim


WORKDIR /app
COPY . /app

RUN apt update \
    && apt install nginx -y \
    && apt install systemctl -y \
    && systemctl stop nginx \
    && npm install

# RUN mv init_service.sh /etc/init.d
RUN mv nginx.conf /etc/nginx/sites-enabled/default


EXPOSE 80
# CMD ["nginx", "-g", "daemon off;"]
CMD ["bash", "init_service.sh"]