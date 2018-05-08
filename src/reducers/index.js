import {combineReducers} from 'redux';
import dimensionsReducer from './dimensions';

const rootReducer = combineReducers({
    dimensions: dimensionsReducer
});

export default rootReducer;