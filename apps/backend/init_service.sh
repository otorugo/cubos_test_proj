#!/bin/sh

echo """
[Unit]
Description=Node Application Service Running in bg
After=network-online.target
Wants=network-online.target
[Service]
User=node
WorkingDirectory=/app
ExecStart=/usr/local/bin/npm run start
Restart=always

[Install]
WantedBy=multi-user.target

""" >/etc/systemd/system/appnode.service

systemctl start appnode.service
systemctl enable appnode.service
systemctl daemon-reload

nginx -g "daemon off;"