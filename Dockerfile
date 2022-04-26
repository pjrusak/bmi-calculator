FROM nginx:1.21.6-alpine

ARG webApp=./build
USER nginx
COPY --chown=nginx:nginx ${webApp} /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]