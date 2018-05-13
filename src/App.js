import React, {Component} from 'react';
import {connect} from 'react-redux';
import Modal from 'react-modal';
import SlidingPane from 'react-sliding-pane';
import 'react-sliding-pane/dist/react-sliding-pane.css';
import './App.css';
import Hands from './containers/hands';
import Decks from './containers/decks';
import PlayerDetails from './containers/player_details';
import ErrorMsg from './components/error_msg';

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

    openDeckPane() {
        this.setState({
            isPaneOpen: true
        });
    }

    closeDeckPane() {
        this.setState({
            isPaneOpen: false
        });
    }

    render() {
        return (
            <div className="App" ref={ref => this.el = ref}>
                <SlidingPane
                    isOpen={this.state.isPaneOpen}
                    title="Train and ticket decks"
                    width="800px"
                    onRequestClose={this.closeDeckPane.bind(this)}>
                    <Decks/>
                </SlidingPane>
                <div id="top-pane">
                    <PlayerDetails openDeckPane={this.openDeckPane.bind(this)}/>
                </div>
                <div id="map-container">
                    <Map/>
                </div>
                <div id="bottom-pane">
                    <Hands/>
                </div>
                {   this.props.error.length > 0 &&
                    <ErrorMsg text={this.props.error}/>
                }
            </div>
        );
    }
}

const mapStateToProps = ({gameState}) => {
    return {
        error: gameState.error
    };
};

export default connect(mapStateToProps)(App);
