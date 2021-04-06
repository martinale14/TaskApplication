const { query } = require("express");

module.exports = {

    entry: './src/app/index.js',
    output: {
        path: __dirname + '/src/public/js',
        filename: 'bundle.js'
    },
    module:{
        rules: [
            {
                loader: 'babel-loader',
                test: /\.js$/,
                exclude: /node_modules/,
                options: {
                    presets: ['@babel/react', '@babel/env'],
                    plugins: ['@babel/proposal-class-properties']
                }
            }
        ]
    },
    resolve:{
        fallback:{
            "buffer": false,
            "path": false,
            "querystring": false,
            "zlib": false
        }
    }

}