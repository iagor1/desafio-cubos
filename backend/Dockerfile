FROM node:lts-alpine3.19

WORKDIR /usr/src/app/

COPY . .

RUN npm install

ENTRYPOINT ["node", "index.js"]