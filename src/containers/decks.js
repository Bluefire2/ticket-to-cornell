import React, {Component} from 'react';
import {connect} from 'react-redux';
import {bindActionCreators} from 'redux';
import Deck from '../components/deck';
import {drawTrainCard, takeRoute} from "../actions/index";

const trainDeckImage = require('../images/tcat_deck.png');

class Decks extends Component {
    render () {
        return (
            <div id="decks-container">
                <Deck clickHandler={this.props.drawTrainCard}
                      backgroundImage={`url(${trainDeckImage})`}
                      text="Draw Train Card"/>
            </div>
        )
    }
}

const mapDispatchToProps = dispatch => {
    return bindActionCreators({
        drawTrainCard,
        takeRoute
    }, dispatch);
};

export default connect(null, mapDispatchToProps)(Decks);