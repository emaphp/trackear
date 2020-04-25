const { environment } = require('@rails/webpacker')
const MomentLocalesPlugin = require('moment-locales-webpack-plugin');
const BundleAnalyzerPlugin = require('webpack-bundle-analyzer').BundleAnalyzerPlugin;

// Only en locale by default
environment.plugins.append('MomentLocales', new MomentLocalesPlugin());
environment.plugins.append('BundleAnalyzer', new BundleAnalyzerPlugin({ analyzerMode: 'static' }))

module.exports = environment
