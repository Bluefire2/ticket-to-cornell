import React, {Component} from 'react';
import logo from './logo.svg';
import './App.css';
import Hands from './containers/hands';
import Decks from './containers/decks';
import PlayerDetails from './containers/player_details';
import DestinationTicket from './components/destination_ticket';
import Modal from 'react-modal';
import SlidingPane from 'react-sliding-pane';
import 'react-sliding-pane/dist/react-sliding-pane.css';

import Map from './containers/map';

class App extends Component {
    constructor(props) {
        super(props);
        this.state = {
            isPaneOpen: false
        };
    }

    componentDidMount() {
        Modal.setAppElement(this.el);
    }

    render() {
        return (
            <div className="App" ref={ref => this.el = ref}>
                <button onClick={() => this.setState({ isPaneOpen: true })}>Click me to open right pane!</button>
                <SlidingPane
                    isOpen={this.state.isPaneOpen}
                    title='Train and ticket decks'
                    onRequestClose={() => {
                        this.setState({isPaneOpen: false});
                    }}>
                    <Decks/>
                </SlidingPane>
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
