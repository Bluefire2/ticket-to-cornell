import React, {Component} from 'react';
import {connect} from 'react-redux';
import TrainHand from '../components/train_hand';
import DestinationHand from './destination_hand';
import {destination_tickets, train_cards} from '../ttc-ocaml/src/player.bs';
import {listToArray} from "../util";

class Hands extends Component {
    render () {
        return (
            <div id="hands-container">
                <TrainHand cards={listToArray(train_cards(this.props.player))}/>
                <DestinationHand tickets={listToArray(destination_tickets(this.props.player))}/>
            </div>
        )
    }
}

const mapStateToProps = ({gameState}) => {
    const currentPlayerIndex = gameState.player_index;
    return {
        player: gameState.players[currentPlayerIndex]
    };
};

export default connect(mapStateToProps)(Hands);