const path = require('path');
const webpack = require('webpack');

module.exports = () => {
    const root = path.resolve(__dirname);
    const dist = path.resolve(root, './dist');

    const config = {
        entry: './src/server/index.ts',
        mode: 'development',
        output: {
            path: dist,
            filename: 'app.server.js',
        },
        target: 'node',
        externals: [],
        plugins: [
            //https://github.com/christkv/require_optional/issues/10
            new webpack.ContextReplacementPlugin(/require_optional/),
        ],
        module: {
            rules: [
                {
                    test: /\.ts?$/,
                    use: ['ts-loader'],
                    exclude: /node_modules/,
                },
                {
                    test: /\.(js)$/,
                    use: [
                        {
                            loader: 'babel-loader',
                            options: {
                                presets: ['@babel/preset-env'],
                            },
                        },
                    ],
                    exclude: /node_modules/,
                },
            ],
        },
        resolve: {
            extensions: ['.ts', '.js'],
        },
    };
    return config;
};
