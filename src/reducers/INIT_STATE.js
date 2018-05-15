import {init_state, setup_state, end_state1, end_state2, end_state3} from '../ttc-ocaml/src/state.bs';
import {stateToObj} from '../util';

const url = new URL(window.location.href);
let nPlayers = url.searchParams.get("n_players"),
    nBots = url.searchParams.get("n_bots");

if(nPlayers === null) {
    nPlayers = 2;
} else {
    nPlayers = parseInt(nPlayers);
}

if(nBots === null) {
    nBots = 2;
} else {
    nBots = parseInt(nBots);
}

export default stateToObj(setup_state(init_state(nPlayers, nBots)));
// export default stateToObj(end_state3);