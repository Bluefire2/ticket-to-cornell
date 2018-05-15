import React, {Component} from 'react';
import {connect} from 'react-redux';
import DestinationTicket from '../components/destination_ticket';
import {completed_ticket} from '../ttc-ocaml/src/state.bs';
import {objToState} from "../util";

class DestinationHand extends Component {
    render() {
        return (
            <div id="destination-hand">
                <fieldset>
                    <legend>Destination Tickets:</legend>
                    {this.props.tickets.map((card, index) => {
                        const props = {
                            from: card[0],
                            to: card[1],
                            points: card[2],
                            completed: false // completed_ticket(card[0], card[1], objToState(this.props.gameState))
                        };
                        return <DestinationTicket {...props} key={index}/>;
                    })}
                </fieldset>
            </div>
        );
    }
}

const mapStateToProps = ({gameState}) => {
    return {
        gameState
    };
};

export default connect(mapStateToProps)(DestinationHand);