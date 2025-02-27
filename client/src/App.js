import React, { Component } from 'react';
import Axios from 'axios';

import Nav from './Nav';
import RoomIndex  from './RoomIndex';
import About  from './About';
import NewRoom  from './NewRoom';
import Room  from './Room';
import { Switch, Route, Redirect } from 'react-router-dom'

import {DOMAIN_NAME, API_ROUTE} from './constants'

class App extends Component {

  getRooms = async () => (
    (await Axios.get(`/${API_ROUTE}/rooms`)).data
  )

  render() {
    const { gapi } = this.props;
    return (
      <div id="app">
        <Nav/>
        <Switch>
          <Route exact path='/' render={() => (
            <Redirect to="/rooms" />
          )} />
          <Route exact path='/about' component={About}/>
          <Route exact path='/new' component={NewRoom}/>
          <Route exact path='/rooms' render={() => (
            <RoomIndex gapi={gapi} />
          )}/>
          <Route path='/rooms/:room_id' render={({match}) => (
            <Room
              room_id={match.params.room_id}
              gapi={gapi}
            />
          )} />
        </Switch>
      </div>
 );
  }
}

export default App;
