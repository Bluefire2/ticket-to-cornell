import React, {Component} from 'react';

export default ({from, to, points, completed}) => {
    const pointsClassName = `destination-ticket-points ${completed ? 'completed' : ''}`;
    return (
        <div className="destination-ticket">
            <div className="destination-ticket-top">{from}</div>
            <div className="destination-ticket-bottom">{to}</div>
            <div className={pointsClassName}>{points}</div>
        </div>
    );
};