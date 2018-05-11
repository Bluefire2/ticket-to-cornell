import React, {Component} from 'react';
import {connect} from 'react-redux';
import {score, trains_remaining} from '../ttc-ocaml/src/player.bs';

class PlayerDetails extends Component {
    render () {
        return (
            <div id="player-details">
                <div id="player-details-name">
                    Current player: {this.props.playerIndex}
                </div>
                <div id="player-details-score">
                    Score: {score(this.props.player)}
                </div>
                <div id="player-details-trains">
                    Trains remaining: {trains_remaining(this.props.player)}
                </div>
            </div>
        )
    }
}

const mapStateToProps = ({gameState}) => {
    const currentPlayerIndex = gameState.player_index;
    return {
        player: gameState.players[currentPlayerIndex],
        playerIndex: gameState.player_index
    };
};

export default connect(mapStateToProps)(PlayerDetails);