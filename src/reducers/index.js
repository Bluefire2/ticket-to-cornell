import {combineReducers} from 'redux';
import dimensionsReducer from './dimensions';
import locationsReducer from './locations';
import gameStateReducer from './game_state';

const rootReducer = combineReducers({
    dimensions: dimensionsReducer,
    locations: locationsReducer,
    gameState: gameStateReducer
});

export default rootReducer;