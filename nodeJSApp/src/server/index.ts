import express from 'express';
import mongoose from 'mongoose';
import bodyParser from 'body-parser';
import cors from 'cors';
import generalRoutes from './routes/general';

const app = express();
const port = 3000;

// mongoose connection
const uri: string = process.env.MONGO_DATABASE_URL || '';

mongoose.Promise = global.Promise;
console.log(`DB URL ${uri}`);
mongoose.connect(uri, {
});

// Access-Control-Allow-Origin: *
app.use(cors());

// bodyparser setup
const options = {
  inflate: true,
  limit: 10000,
  type: 'text/plain',
};
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.raw(options));
app.use(bodyParser.json());
generalRoutes(app);
app.get('/', (req, res) => res.send('Server is running'));

app.listen(port, () => {
  console.log(`App running on port ${port}.`);
});
