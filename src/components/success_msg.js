import React, {Component} from 'react';
import successIcon from '../images/success.png';

export default ({children}) => {
    return (
        <div id="success-msg">
            <img src={successIcon} width="90px" height="90px"/>
            {children}
        </div>
    );
};