import React, {Component} from 'react';

const DestinationTicket = ({from, to, points, completed, selected}) => {
    const pointsClassName = `destination-ticket-points ${completed ? 'completed' : ''}`;
    return (
        <div className="destination-ticket">
            <div className="destination-ticket-top">{from}</div>
            <div className="destination-ticket-bottom">{to}</div>
            <div className={pointsClassName}>{points}</div>
            {
                selected &&
                <div className="destination-ticket-selected-marker"/>
            }
        </div>
    );
};

DestinationTicket.defaultProps = {
    selected: false
};

export default DestinationTicket;