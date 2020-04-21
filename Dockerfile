FROM node:lts-alpine3.9

RUN apk add --no-cache tini && npm install -g docsify-cli@latest

WORKDIR /docs

EXPOSE 3000
EXPOSE 35729

ENTRYPOINT ["/sbin/tini", "--"]
CMD [ "docsify", "serve", "." ]