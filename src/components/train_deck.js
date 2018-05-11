import React, {Component} from 'react';

const deckImage = require('../images/tcat_deck.png');

export default ({clickHandler}) => {
    return (
        <div id="train-deck" onClick={clickHandler}>
            <div id="train-deck-text">Draw Train Card</div>
        </div>
    );
};