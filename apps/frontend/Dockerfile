FROM nginx:alpine

WORKDIR /app
COPY . /app
# RUN mv init_service.sh /etc/init.d
RUN mv nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80