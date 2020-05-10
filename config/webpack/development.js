process.env.NODE_ENV = process.env.NODE_ENV || 'development'

const environment = require('./environment')

environment.plugins.append('BundleAnalyzer', new BundleAnalyzerPlugin({ analyzerMode: 'static' }))

module.exports = environment.toWebpackConfig()
