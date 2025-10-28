
import React from 'react';
import { createStackNavigator } from '@react-navigation/stack';
import { NavigationContainer } from '@react-navigation/native';
import WelcomeScreen from '../screens/WelcomeScreen';
import IdentityStoredScreen from '../screens/IdentityStoredScreen';
import ManageDigitalAssetsScreen from '../screens/ManageDigitalAssetsScreen';
import FutureOfMoneyScreen from '../screens/FutureOfMoneyScreen';
import AccessCodeInputScreen from '../screens/AccessCodeInputScreen';
import AccountCreationScreen from '../screens/AccountCreationScreen';
import AccountConfirmationScreen from '../screens/AccountConfirmationScreen';
import PINCodeSetupScreen from '../screens/PINCodeSetupScreen';
import DeviceConnectionScreen from '../screens/DeviceConnectionScreen';

const Stack = createStackNavigator();

const AppNavigator = () => {
  return (
    <NavigationContainer>
      <Stack.Navigator initialRouteName="WelcomeScreen">
        <Stack.Screen name="WelcomeScreen" component={WelcomeScreen} />
        <Stack.Screen name="IdentityStoredScreen" component={IdentityStoredScreen} />
        <Stack.Screen name="ManageDigitalAssetsScreen" component={ManageDigitalAssetsScreen} />
        <Stack.Screen name="FutureOfMoneyScreen" component={FutureOfMoneyScreen} />
        <Stack.Screen name="AccessCodeInputScreen" component={AccessCodeInputScreen} />
        <Stack.Screen name="AccountCreationScreen" component={AccountCreationScreen} />
        <Stack.Screen name="AccountConfirmationScreen" component={AccountConfirmationScreen} />
        <Stack.Screen name="PINCodeSetupScreen" component={PINCodeSetupScreen} />
        <Stack.Screen name="DeviceConnectionScreen" component={DeviceConnectionScreen} />
      </Stack.Navigator>
    </NavigationContainer>
  );
};

export default AppNavigator;
