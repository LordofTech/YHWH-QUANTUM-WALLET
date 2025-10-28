const { getDefaultConfig } = require('metro-config');
const path = require('path');

module.exports = (async () => {
  const config = await getDefaultConfig();

  return {
    ...config,
    resolver: {
      ...config.resolver,
      assetExts: [...config.resolver.assetExts, 'svg', 'bin', 'db', 'mp4', 'jpg', 'jpeg', 'png'],  // Add other extensions if necessary
      sourceExts: [...config.resolver.sourceExts, 'js', 'jsx', 'ts', 'tsx', 'json', 'svg'],
      extraNodeModules: {
        'react-native-svg': path.resolve(__dirname, 'node_modules/react-native-svg'),
      },
    },
    transformer: {
      ...config.transformer,
      babelTransformerPath: require.resolve('react-native-svg-transformer'),
    },
  };
})();
