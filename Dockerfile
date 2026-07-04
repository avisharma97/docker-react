FROM node:22-alpine AS builder

WORKDIR /app
COPY package*.json ./
RUN npm i
COPY . .

FROM builder AS test
CMD ["npm", "run", "test", "--", "--coverage"]

FROM builder AS build
RUN npm run build

FROM nginx:alpine
EXPOSE 80
COPY --from=build /app/build /usr/share/nginx/html
CMD ["nginx", "-g", "daemon off;"]