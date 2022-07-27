const express = require('express');
const bodyParser = require('body-parser');
const imagesRouter = require('./routers/images_router');
const videosRouter = require('./routers/videos_router');
const loopsRouter = require('./routers/loops_router');
const songsRouter = require('./routers/songs_router');

const app = express();

app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
app.use('/images', imagesRouter);
app.use('/videos', videosRouter);
app.use('/loops', loopsRouter);
app.use('/songs', songsRouter);

module.exports = app;