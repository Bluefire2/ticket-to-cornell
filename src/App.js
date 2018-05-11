import React, {Component} from 'react';
import logo from './logo.svg';
import './App.css';
import Hands from './containers/hands';
import PlayerDetails from './containers/player_details';
import DestinationTicket from './components/destination_ticket';

import Map from './containers/map';

class App extends Component {
    render() {
        return (
            <div className="App">
                <div id="top-pane">
                    <PlayerDetails/>
                </div>
                <div id="map-container">
                    <Map/>
                </div>
                <div id="bottom-pane">
                    <DestinationTicket from="Becker House" to="Comstock Hall" points={15} />
                    <Hands/>
                </div>
            </div>
        );
    }
}

export default App;
