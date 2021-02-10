FROM node:14-alpine AS builder

WORKDIR /app

RUN npm install -g @marp-team/marp-cli

ADD . .

RUN find . -maxdepth 2 -mindepth 2 -name "*.md" -not -name "README.md" -print0 | xargs -0 marp {} \;

RUN mkdir -p out && \
  find . -maxdepth 2 -mindepth 2 -name "*.html" -exec mv {} ./out/ \;


FROM nginx:stable-alpine
ENV NGINX_ENTRYPOINT_QUIET_LOGS=1
COPY --from=builder /app/out/* /usr/share/nginx/html/
ADD index.html /usr/share/nginx/html/index.html
RUN echo "server { listen 80; server_name localhost; location / { root /usr/share/nginx/html; index index.html; rewrite ^/([a-zA-Z0-9\-_]+)/?$ /\$1.html last; } }" > /etc/nginx/conf.d/default.conf
