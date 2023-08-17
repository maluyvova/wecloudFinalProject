import mongoose from 'mongoose';

const { Schema } = mongoose;

const AutoCollection = new Schema({
  ownerId: {
    type: String,
    required: 'Enter a Owner Id',
  },
  store: {
    type: Array,
    of: Object,
  },
});

export default AutoCollection;
