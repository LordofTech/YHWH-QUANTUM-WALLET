
import React from 'react';
import { View, Text, StyleSheet, Button } from 'react-native';

const {screen} = () => {
  return (
    <View style={styles.container}>
      <Text style={styles.title}>{title}</Text>
      <Button title="Next" onPress={() => alert('Next pressed')} color="#1E90FF" />
    </View>
  );
}};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#00AEEF',
    padding: 20,
    justifyContent: 'center',
  },
  title: {
    fontSize: 24,
    fontWeight: 'bold',
    color: 'white',
    textAlign: 'center',
  },
});

export default {screen};
