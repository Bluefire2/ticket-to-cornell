import React, {Component} from 'react';
import successIcon from '../images/success.png';

export default ({text}) => {
    return (
        <div id="success-msg">
            <img src={successIcon} width="90px" height="90px"/>
            {text}
        </div>
    );
};