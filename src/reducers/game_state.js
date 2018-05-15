import initialState from './INIT_STATE';
import * as constants from '../constants';
import {arrayToList, objToState, stateToObj} from "../util";
import {setup_state, current_player, draw_card_pile, take_route, decided_routes, select_route, next_player, draw_card_facing_up} from '../ttc-ocaml/src/state.bs';
import {first_turn} from '../ttc-ocaml/src/player.bs';

const modifyState = (state, fn) => {
    const camlState = objToState(state),
        newCamlState = fn(camlState);
    return stateToObj(newCamlState);
};

export default (state = initialState, action) => {
    switch (action.type) {
        case constants.DRAW_CARD_PILE:
            // draw a card from the train card pile
            // state.draw_card_pile
            return modifyState(state, draw_card_pile);
        case constants.TAKE_ROUTE:
            // draw a route card
            // state.take_route
            return modifyState(state, take_route);
        case constants.DECIDED_ROUTES:
            // choose destination tickets
            // state.decided_routes
            const indices = action.payload.map((elem, index) => elem ? index : -1).filter(elem => elem >= 0),
                ocamlIndices = arrayToList(indices);
            return modifyState(state, (st) => decided_routes(st, ocamlIndices));
        case constants.SELECT_ROUTE:
            // try to fill a route
            // state.select_route
            const route = action.payload.route,
                color = action.payload.color === -1 ? 0 : [action.payload.color];
            return modifyState(state, (st) => select_route(st, route, color));
        case constants.NEXT_PLAYER:
            // end the current player's turn, and move on to the next player
            // state.next_player
            const newState = modifyState(state, next_player),
                newPlayer = current_player(objToState(newState));

            if(first_turn(newPlayer) && newState.error.length === 0) {
                return modifyState(newState, setup_state);
            } else {
                return newState;
            }
        case constants.DRAW_CARD_FACING_UP:
            // draw a card from the face-up pile
            // state.draw_card_facing_up
            return modifyState(state, (st) => draw_card_facing_up(st, action.payload));
        default:
            return state;
    }
}