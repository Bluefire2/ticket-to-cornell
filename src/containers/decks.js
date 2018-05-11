import React, {Component} from 'react';
import {connect} from 'react-redux';
import {bindActionCreators} from 'redux';
import TrainDeck from '../components/train_deck';
import {drawTrainCard} from "../actions/index";

class Decks extends Component {
    render () {
        return (
            <div id="decks-container">
                <TrainDeck clickHandler={this.props.drawTrainCard}/>
            </div>
        )
    }
}

const mapDispatchToProps = dispatch => {
    return bindActionCreators({
        drawTrainCard
    }, dispatch);
};

export default connect(null, mapDispatchToProps)(Decks);