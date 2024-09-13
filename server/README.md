<h1 align="center">Survivor backend </h1>

## 💼 Technologies and Tools:
<div align="center">
  <code><img height="80" src="https://github.com/aimeric44uwu/aimeric44uwu/blob/main/img/nodejs.png?raw=true" alt="nodejs"></code>
  <code><img height="80" src="https://github.com/aimeric44uwu/aimeric44uwu/blob/main/img/mongodb.png?raw=true" alt="mongodb"></code>
</div>

<br/>

## 👨‍💻 About This Project:
this is the server side of the project survivor
this project is build using [NodeJs](https://nodejs.org/) and [MongoDB](https://www.mongodb.com/)

<br/>

## Installation
Use the package manager [npm](https://www.npmjs.com/) to install required dependencies.
```bash
npm i
```
<br/>

setup [MongoDB](https://www.mongodb.com/) using the [Guide on their site](https://www.mongodb.com/docs/manual/installation/)

<br/>

if you want to use [nodemon](https://www.npmjs.com/package/nodemon) you'll have to install it globally:
```bash
npm install -g nodemon # or using yarn: yarn global add nodemon
```
You can also install [nodemon](https://www.npmjs.com/package/nodemon) as a development dependency:
```bash
npm install --save-dev nodemon # or using yarn: yarn add nodemon -D
```

fill a .env file by following the .env.example

<br/>

## Usage

possible commands are : 
```bash
# run with nodemon to auto reload the code
npm run dev

# run in production
npm run start

# check lint errors
npm run lint

# auto fix lint errors
npm run lintfix
```

to run with pm2 :
```bash
# for development environment
pm2 reload ecosystem.config.js --only soul-connection-api-dev --env development

# for prod environment
pm2 start ecosystem.config.js --only soul-connection-api-prod --env production
```
