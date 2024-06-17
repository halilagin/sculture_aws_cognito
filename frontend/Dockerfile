#FROM node:lts-alpine
FROM node:21-alpine3.19

# install simple http server for serving static content
#RUN npm install -g http-server

# make the 'app' folder the current working directory
WORKDIR /app

# copy both 'package.json' and 'package-lock.json' (if available)
COPY . .

# install project dependencies
RUN npm install



EXPOSE 4002
CMD [ "npm", "run", "dev" ]
