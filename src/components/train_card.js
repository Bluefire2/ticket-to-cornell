import React, {Component} from 'react';
import {trainColorFromIndex} from "../util";

export default ({color, amount}) => {
    const actualColor = trainColorFromIndex(color),
        trainCardAmountStyle = amount === 0 ? {
            color: 'red'
        } : {};
    return (
        <div className="train-card" style={{borderColor: actualColor}}>
            <div className="train-card-amount" style={trainCardAmountStyle}>{amount}</div>
        </div>
    );
};