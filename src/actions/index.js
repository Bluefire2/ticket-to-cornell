import * as constants from '../constants';

export function drawCard() {
    return {
        type: constants.DRAW_CARD_PILE
    };
}

export function takeRoute() {
    return {
        type: constants.TAKE_ROUTE
    };
}