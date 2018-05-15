import {init_state, setup_state, end_state1, end_state2, end_state3} from '../ttc-ocaml/src/state.bs';
import {stateToObj} from '../util';

const url = new URL(window.location.href);
let nPlayers = url.searchParams.get("n_players");

if(nPlayers === null) {
    nPlayers = 2;
} else {
    nPlayers = parseInt(nPlayers);
}

export default stateToObj(setup_state(init_state(nPlayers, 0)));
// export default stateToObj(end_state3);