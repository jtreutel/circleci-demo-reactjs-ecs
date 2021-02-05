FROM node:15.7.0
LABEL "maintainer"="github.com/jtreutel"

EXPOSE 3000

WORKDIR /app
ENV PATH /app/node_modules/.bin:$PATH

# install app dependencies
#COPY package.json ./
#COPY package-lock.json ./
#COPY node_modules/ node_modules/
COPY . ./
#RUN npm install --silent
#RUN npm install react-scripts@3.4.3 -g --silent
RUN npm install 
RUN npm install react-scripts@3.4.3 -g

# start app
ENTRYPOINT npm start