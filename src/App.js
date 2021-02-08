import React, { Component } from 'react';
import './App.css';

import Layout from './Componets/Layout';
import Header from './Componets/Header';
import Container from './Componets/Container';
import Card from './Componets/Card';


class App extends Component {
  render() {
    return (
      <Layout>
<<<<<<< HEAD
        <Header title="Red Panda Gram"/>
=======
        <Header title="The Red Panda Corner"/>
>>>>>>> demo
        <Container>
          <Card cards={ this.state.cards } />
        </Container>
      </Layout>
    );
  }

  state = {
      cards: []
  };

  componentDidMount() {
      fetch('https://www.reddit.com/r/redpandas/top.json?t=all&count=20')
      .then(res => res.json())
      .then((data) => {
          console.log(data.data.children);
          this.setState({ cards: data.data.children })
      })
      .catch(console.log)
  }
}

export default App;
