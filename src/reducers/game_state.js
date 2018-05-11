import initialState from './INIT_STATE';
import * as constants from '../constants';
import {objToState, stateToObj} from "../util";
import {draw_card_pile, take_route} from '../ttc-ocaml/src/state.bs';

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
        default:
            return state;
    }
}