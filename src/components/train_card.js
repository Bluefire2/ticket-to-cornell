import React, {Component} from 'react';
import {trainColorFromIndex} from "../util";

export default ({color, amount}) => {
    const actualColor = trainColorFromIndex(color);
    return (
        <div className="train-card" style={{borderColor: actualColor}}>
            <div className="train-card-amount">{amount}</div>
        </div>
    );
};