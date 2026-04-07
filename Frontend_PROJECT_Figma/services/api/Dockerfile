FROM node:24-alpine

WORKDIR /app

COPY package.json ./
COPY services/api/package.json ./services/api/package.json
COPY apps/web/package.json ./apps/web/package.json

RUN npm install

COPY . .

RUN npm run build --workspace services/api

WORKDIR /app/services/api

CMD ["sh", "-c", "npm run migration:run && npm run seed && node dist/main.js"]
