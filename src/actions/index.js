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

export function decidedRoutes(destinations) {
    return {
        type: constants.DECIDED_ROUTES,
        payload: destinations
    };
}

export function selectRoute(route, color) {
    return {
        type: constants.SELECT_ROUTE,
        payload: {route, color}
    };
}

export function nextPlayer() {
    return {
        type: constants.NEXT_PLAYER
    };
}