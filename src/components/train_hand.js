import React, {Component} from 'react';
import TrainCard from './train_card';

class TrainHand extends Component {
    render() {
        return (
            <div id="train-hand">
                {this.props.cards.map((card, index) => {
                    return <TrainCard color={card[0]} amount={card[1]} key={index}/>;
                })}
            </div>
        );
    }
}

export default TrainHand;