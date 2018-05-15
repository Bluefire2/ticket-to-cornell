import React, {Component} from 'react';
import {connect} from 'react-redux';
import {score} from '../ttc-ocaml/src/player.bs';
import {playerColorFromIndex} from "../util";

class WinScreen extends Component {
    render() {
        // TODO: insert a "player X won" banner or something
        return (
            <div id="win-screen">
                <table id="score-table">
                    <tr>
                        <th>Player</th>
                        <th>Score</th>
                    </tr>
                    {this.props.players.sort((a, b) => score(a) < score(b)).map(player => {
                        const playerColor = playerColorFromIndex(player[0]);
                        return (
                            <tr>
                                <td style={{color: playerColor}}>{playerColor.toUpperCase()}</td>
                                <td>{score(player)}</td>
                            </tr>
                        );
                    })}
                </table>
            </div>
        );
    };
}

const mapStateToProps = ({gameState: {players}}) => {
    return {
        players
    };
};

export default connect(mapStateToProps)(WinScreen);