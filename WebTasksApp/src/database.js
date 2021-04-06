const mongoose = require('mongoose');
const URI = 'mongodb://localhost/mern-crud-test'

mongoose.connect(URI, {useNewUrlParser: true, useUnifiedTopology: true, useFindAndModify: false})
    .then(db => console.log('Db is connected'))
    .catch(err => console.error(err));

module.exports = mongoose;