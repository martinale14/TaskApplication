import * as Font from 'expo-font';
import AppLoading from 'expo-app-loading';
import { StatusBar } from 'expo-status-bar';
import React, { Component } from 'react';
import Icon from 'react-native-vector-icons/FontAwesome';
import { SafeAreaView, View, Text, StyleSheet, FlatList, TouchableOpacity, CheckBox } from 'react-native';


class App extends Component {

  constructor(props) {
    super(props);
    this.state = {
      color: '#1976d2',
      fontsLoaded: false,
      tasks: [],
      title: '',
      description: '',
    };
    this.pressedOnce = this.pressedOnce.bind(this);
  }

  componentDidMount() {
    this.fetchData();

  }

  async loadFonts() {
    const fonts = await Font.loadAsync({
      'Ubuntu-Regular': {
        uri: require('./assets/ubuntuFont/Ubuntu-Regular.ttf'),
        display: Font.FontDisplay.FALLBACK,
      },
    });
    return Promise.all([fonts]);
  }

  pressedOnce() {
    console.log('Press');
  }

  fetchData() {
    fetch('http://192.168.20.64:3000/api/tasks')
      .then(res => res.json())
      .then(data => {
        console.log(data);
        this.setState({ tasks: data });
      });

    this.state.tasks.map((el) => el.isChecked = false);
  }

  addTask(e) {
    fetch('http://192.168.20.64:3000/api/tasks', {
      method: 'POST',
      body: JSON.stringify({ title: this.state.title, description: this.state.description }),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      }
    })
      .then(res => res.json())
      .then(data => {
        this.setState({
          title: '',
          description: ''
        });
        this.fetchData();
      })
      .catch(err => console.error(err));
  }

  render() {

    const btnHeight = 40;
    const btnWidth = 120;

    if (this.state.fontsLoaded) {

      const styles = StyleSheet.create({
        container: {
          flex: 1,
          backgroundColor: '#000',
          paddingTop: 22,
        },
        button: {
          backgroundColor: this.state.color,
          height: btnHeight,
          width: btnWidth,
          justifyContent: 'center',
          alignItems: 'center',
          borderRadius: 10,
          shadowOpacity: 1,
          shadowColor: this.state.color,
          shadowOffset: {
            height: 0,
            width: 0,
          },
          shadowRadius: 4,
          elevation: 5,
          flex: 1,
          marginLeft: 10,
        },
        myFont: {
          color: 'white',
          fontFamily: 'Ubuntu-Regular',
          fontSize: 22,
          height: 44,
          textAlignVertical: 'center',
          flex: 1,
        },
        list: {
          marginHorizontal: 20
        },
        floatButtons: {
          backgroundColor: this.state.color,
          width: 60,
          height: 60,
          borderRadius: 100,
          margin: 7,
          justifyContent: 'center',
          alignItems: 'center',
          right: 0,
          bottom: 0
        }
      });
      return (
        <SafeAreaView style={styles.container} >
          <FlatList
            keyExtractor={item => item._id}
            data={this.state.tasks}
            renderItem={({ item, index }) => {
              return (
                <View style={{
                  flexDirection: 'row',
                  padding: 10,
                }}>
                  <CheckBox value={item.isChecked} tintColors={{ true: 'white', false: 'white' }}
                    style={{
                      flex: 0.4,
                      justifyContent: 'center'
                    }} onValueChange={(val) => {
                      this.state.tasks[index].isChecked = val;
                      this.setState({});
                    }} />
                  <Text style={styles.myFont}>
                    {item.title}
                  </Text>
                  <Text style={{
                    margin: 2,
                    flex: 1,
                    textAlignVertical: 'center',
                    textAlign: 'center',
                    color: 'white',
                  }}>
                    {item.description}
                  </Text>
                  <View style={{
                    flex: 1,
                    justifyContent: 'center',
                    alignItems: 'center',
                  }}>
                    <TouchableOpacity style={{
                      width: 35,
                      height: 35,
                      padding: 0,
                      backgroundColor: this.state.color,
                      borderRadius: 100,
                      alignItems: 'center',
                      justifyContent: 'center',
                    }} onPress={this.pressedOnce} >
                      <Icon name="pencil" size={20} color="#fff" />
                    </TouchableOpacity>

                  </View>
                </View>);
            }}
            style={styles.list}
          />
          <View style={{
            position: 'absolute',
            right: 0,
            bottom: 0,
            margin: 20,
            flexDirection: 'row-reverse',
          }}>
            <TouchableOpacity onPress={this.pressedOnce}
              style={styles.floatButtons}>
              <Icon name="plus" size={25} color="#fff" />
            </TouchableOpacity>
            <TouchableOpacity onPress={this.pressedOnce}
              style={styles.floatButtons}>
              <Icon name="trash-o" size={25} color="#fff" />
            </TouchableOpacity>
          </View>
          <StatusBar style="auto" />
        </SafeAreaView>
      );
    } else {
      return <AppLoading startAsync={this.loadFonts}
        onFinish={() => {
          this.setState({ fontsLoaded: true });
        }}
        onError={console.warn} />;
    }
  }

}

export default App;