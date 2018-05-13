import React, {Component} from 'react';
import errorIcon from '../images/error.png';

export default ({text}) => {
    // TODO: make it so that when the user clicks the error message, it disappears
    return (
        <div id="error-msg">
            <img src={errorIcon} width="90px" height="90px"/>
            {text}
        </div>
    );
};