import React, {Component} from 'react';
import DestinationTicket from './destination_ticket';

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
                            points: card[2]
                        };
                        return <DestinationTicket {...props} key={index}/>;
                    })}
                </fieldset>
            </div>
        );
    }
}

export default DestinationHand;