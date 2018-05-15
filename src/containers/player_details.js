import React, {Component} from 'react';
import {bindActionCreators} from 'redux';
import {connect} from 'react-redux';
import {score, trains_remaining, color} from '../ttc-ocaml/src/player.bs';
import {current_player} from '../ttc-ocaml/src/state.bs';
import {nextPlayer} from "../actions/index";
import {objToState, playerColorFromIndex} from "../util";

class PlayerDetails extends Component {
    render () {
        const playerColor = playerColorFromIndex(color(this.props.player));
        return (
            <div id="player-details">
                <div id="player-details-name" className="player-detail">
                    Current player: <span id="player-name" style={{color: playerColor}}>{playerColor}</span>
                </div>
                <div id="player-details-score" className="player-detail">
                    Score: {score(this.props.player)}
                </div>
                <div id="player-details-trains" className="player-detail">
                    Trains remaining: {trains_remaining(this.props.player)}
                </div>
                <div>
                    <button id="view-decks-button"
                            className="pure-button pure-button-secondary"
                            onClick={this.props.openDeckPane}>
                        View decks
                    </button>
                    <button id="next-player-button"
                            className="pure-button pure-button-success"
                            onClick={this.props.nextPlayer}>
                        Next player
                    </button>
                </div>
            </div>
        )
    }
}

const mapStateToProps = ({gameState}) => {
    return {
        player: current_player(objToState(gameState))
    };
};

const mapDispatchToProps = dispatch => {
    return bindActionCreators({
        nextPlayer
    }, dispatch);
};

export default connect(mapStateToProps, mapDispatchToProps)(PlayerDetails);