FROM node:18-alpine3.18

WORKDIR /usr/src/app

COPY . ./

RUN npm install

ENTRYPOINT ["node", "index.js"]