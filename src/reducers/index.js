import {combineReducers} from 'redux';
import dimensionsReducer from './dimensions';
import locationsReducer from './locations';

const rootReducer = combineReducers({
    dimensions: dimensionsReducer,
    locations: locationsReducer
});

export default rootReducer;