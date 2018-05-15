import React, {Component} from 'react';
import {trainColorCardFromIndex} from "../util";

export default ({color, amount}) => {
    const actualColor = trainColorCardFromIndex(color),
        trainCardAmountStyle = amount === 0 ? {
            color: 'red'
        } : {};
    return (
        <div className="train-card" style={{borderImage: actualColor}}>
            {amount > -1 &&
                <div className="train-card-amount" style={trainCardAmountStyle}>{amount}</div>
            }
        </div>
    );
};
