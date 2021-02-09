FROM node:15.7.0
LABEL "maintainer"="github.com/jtreutel"

EXPOSE 3000

WORKDIR /app
ENV PATH /app/node_modules/.bin:$PATH

# start app
CMD npm start

# install app dependencies
COPY package.json ./
#COPY package-lock.json ./

RUN npm install --silent
RUN npm install react-scripts@3.4.3 -g --silent

COPY . ./