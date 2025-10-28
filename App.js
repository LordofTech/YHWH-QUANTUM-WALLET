
import React from 'react';
import { SafeAreaView } from 'react-native';
import AppNavigator from './navigation/AppNavigator';

const App = () => {
  return (
    <SafeAreaView style={{ flex: 1 }}>
      <AppNavigator />
    </SafeAreaView>
  );
};

export default App;
