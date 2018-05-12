import * as constants from '../constants';

export function drawTrainCard() {
    return {
        type: constants.DRAW_CARD_PILE
    };
}

export function takeRoute() {
    return {
        type: constants.TAKE_ROUTE
    };
}

export function chooseDestinations(destinations) {
    return {
        type: constants.DECIDED_ROUTES,
        payload: destinations
    };
}