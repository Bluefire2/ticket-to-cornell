import React, {Component} from 'react';

export default ({from, to, points}) => {
    return (
        <div className="destination-ticket">
            <div className="destination-ticket-top">{from}</div>
            <div className="destination-ticket-bottom">{to}</div>
            <div className="destination-ticket-points">{points}</div>
        </div>
    );
};