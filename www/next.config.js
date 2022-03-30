// @ts-check

/**
 * @type {import('next').NextConfig}
 **/
module.exports = {
  reactStrictMode: true,
  // swcMinify: true,
  images: {
    domains: ["alytqvwillylytpmdjai.supabase.co"],
  },

  webpack: (config, { buildId, dev, isServer, defaultLoaders, webpack }) => {
    // Important: return the modified config
    // 
    config.resolve = { ...config.resolve,
      fallback: {
        url: require.resolve('url'),
        fs: require.resolve('fs'),
        assert: require.resolve('assert'),
        crypto: require.resolve('crypto-browserify'),
        http: require.resolve('stream-http'),
        https: require.resolve('https-browserify'),
        os: require.resolve('os-browserify/browser'),
        buffer: require.resolve('buffer'),
        stream: require.resolve('stream-browserify'),
        path: require.resolve('path-browserify'),
      },
    };

    config.plugins.push(
      new webpack.ProvidePlugin({
        process: 'process/browser',
        Buffer: ['buffer', 'Buffer'],
      }),
    );

    return config
  },
};
