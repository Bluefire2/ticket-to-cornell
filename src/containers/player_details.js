import React, {Component} from 'react';
import {connect} from 'react-redux';
import {score, trains_remaining} from '../ttc-ocaml/src/player.bs';

class PlayerDetails extends Component {
    render () {
        return (
            <div id="player-details">
                <div id="player-details-name" className="player-detail">
                    Current player: {this.props.playerIndex}
                </div>
                <div id="player-details-score" className="player-detail">
                    Score: {score(this.props.player)}
                </div>
                <div id="player-details-trains" className="player-detail">
                    Trains remaining: {trains_remaining(this.props.player)}
                </div>
                <div>
                    <button id="view-decks-button"
                            className="pure-button pure-button-secondary">
                        View decks
                    </button>
                    <button id="next-player-button"
                            className="pure-button pure-button-success">
                        Next player
                    </button>
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