import React, {Component} from 'react';
import {connect} from 'react-redux';
import {bindActionCreators} from 'redux';
import Deck from '../components/deck';
import DestinationTicket from '../components/destination_ticket';
import {drawTrainCard, takeRoute} from "../actions/index";
import {choose_destinations} from '../ttc-ocaml/src/state.bs';
import {objToState, listToArray, destinationToObj} from "../util";

const trainDeckImage = require('../images/tcat_deck.png');

class Decks extends Component {
    render() {
        return (
            <div id="decks-wrapper">
                <div id="decks-container">
                    <Deck clickHandler={this.props.drawTrainCard}
                          backgroundImage={`url(${trainDeckImage})`}
                          text="Draw Train Card"/>
                    <Deck clickHandler={this.props.takeRoute}
                          backgroundImage={`url(${trainDeckImage})`}
                          text="Draw Route Tickets"/>
                </div>
                <div id="choose-destinations">
                    <fieldset>
                        <legend>Choose destination tickets:</legend>
                        {this.props.destinations.map((destination, index) => {
                            return <DestinationTicket {...destination} key={index}/>
                        })}
                    </fieldset>
                </div>
            </div>
        )
    }
}

const mapStateToProps = ({gameState}) => {
    return {
        destinations: listToArray(choose_destinations(objToState(gameState))).map(destinationToObj) // :(
    };
};

const mapDispatchToProps = dispatch => {
    return bindActionCreators({
        drawTrainCard,
        takeRoute
    }, dispatch);
};

export default connect(mapStateToProps, mapDispatchToProps)(Decks);