import React, {Component} from 'react';
import {connect} from 'react-redux';
import {bindActionCreators} from 'redux';
import Deck from '../components/deck';
import DestinationTicket from '../components/destination_ticket';
import TrainCard from '../components/train_card';
import {drawTrainCard, takeRoute, decidedRoutes, drawCardFacingUp} from "../actions/index";
import {choose_destinations} from '../ttc-ocaml/src/state.bs';
import {objToState, listToArray, destinationToObj} from "../util";

const trainDeckImage = require('../images/tcat_deck.png');

class Decks extends Component {
    constructor(props) {
        super(props);
        this.state = {
            selectedTickets: props.destinations.map(elem => false)
        };
    }

    ticketClickHandler(index) {
        const newSelectedTickets = this.state.selectedTickets.map(elem => elem); // need to explicitly copy the array
        newSelectedTickets[index] = !newSelectedTickets[index]; // invert value
        return () => {
            this.setState({
                selectedTickets: newSelectedTickets
            });
        }
    }

    faceUpCardClickHandler(index) {
        return () => this.props.drawCardFacingUp(index);
    }

    render() {
        return (
            <div id="decks-wrapper">
                <div id="decks-container">
                    <Deck clickHandler={this.props.drawTrainCard}
                          backgroundImage={`url(${trainDeckImage})`}
                          text="Draw Bus Card"/>
                    <Deck clickHandler={this.props.takeRoute}
                          backgroundImage={`url(${trainDeckImage})`}
                          text="Draw Route Tickets"/>
                </div>
                <div id="face-up-pile">
                    <fieldset>
                        <legend>Choose bus cards:</legend>
                        {this.props.faceUpCards.map((colorIndex, index) => {
                            return (
                                <div className="face-up-pile-card clickable"
                                     onClick={this.faceUpCardClickHandler(index).bind(this)} key={index}>
                                    <TrainCard color={colorIndex} amount={-1} key={index}/>
                                </div>
                            );
                        })}
                    </fieldset>
                </div>
                <div id="choose-destinations">
                    {
                        this.props.destinations.length !== 0 && // only render if we need to

                        <fieldset>
                            <legend>Choose destination tickets:</legend>
                            {this.props.destinations.map((destination, index) => {
                                const ticketSelected = this.state.selectedTickets[index];
                                return (
                                    <div className="choose-destinations-ticket clickable"
                                         onClick={this.ticketClickHandler(index).bind(this)} key={index}>
                                        <DestinationTicket {...destination} selected={ticketSelected}/>
                                    </div>
                                );
                            })}
                            <div id="choose-destinations-button-wrapper">
                                <button id="choose-destinations-button"
                                        className="pure-button pure-button-primary"
                                        onClick={() => this.props.decidedRoutes(this.state.selectedTickets)}>
                                    Select
                                </button>
                            </div>
                        </fieldset>
                    }
                </div>
            </div>
        )
    }
}

const mapStateToProps = ({gameState}) => {
    return {
        destinations: listToArray(choose_destinations(objToState(gameState))).map(destinationToObj), // :(
        faceUpCards: gameState.facing_up_trains
    };
};

const mapDispatchToProps = dispatch => {
    return bindActionCreators({
        drawTrainCard,
        takeRoute,
        decidedRoutes,
        drawCardFacingUp
    }, dispatch);
};

export default connect(mapStateToProps, mapDispatchToProps)(Decks);