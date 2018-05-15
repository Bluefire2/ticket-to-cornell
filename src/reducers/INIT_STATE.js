import {init_state, setup_state} from '../ttc-ocaml/src/state.bs';
import {stateToObj} from '../util';

const url = new URL(window.location.href);
let nPlayers = url.searchParams.get("n_players");

if(nPlayers === null) nPlayers = 2;

export default stateToObj(setup_state(init_state(nPlayers, 0)));