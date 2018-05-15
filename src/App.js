import React, {Component} from 'react';
import {connect} from 'react-redux';
import Modal from 'react-modal';
import SlidingPane from 'react-sliding-pane';
import 'react-sliding-pane/dist/react-sliding-pane.css';
import './App.css';
import Map from './containers/map';
import Hands from './containers/hands';
import Decks from './containers/decks';
import PlayerDetails from './containers/player_details';
import ErrorMsg from './components/error_msg';
import SuccessMsg from './components/success_msg';
import WinScreen from './containers/win_screen';

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
                {this.props.error.length > 0 && <ErrorMsg>{this.props.error}</ErrorMsg>}
                {this.props.success.length > 0 && <SuccessMsg>{this.props.success}</SuccessMsg>}
                {this.props.lastRound && <WinScreen/>}
            </div>
        );
    }
}

const mapStateToProps = ({gameState: {error, success, last_round}}) => {
    return {
        error,
        success,
        lastRound: last_round
    };
};

export default connect(mapStateToProps)(App);
