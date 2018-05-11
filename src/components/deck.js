import React, {Component} from 'react';

export default ({clickHandler, backgroundImage, text}) => {
    return (
        <div id="deck" onClick={clickHandler} style={{backgroundImage: backgroundImage}}>
            <div id="deck-text">{text}</div>
        </div>
    );
};