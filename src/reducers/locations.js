import {locations as locations_ht} from '../ttc-ocaml/src/board.bs';
import {listToArray} from '../util';

const initLocations = listToArray(locations_ht);

// TODO: does this need to be a reducer? In theory, the list of locations never changes.
export default (state = initLocations, action) => {
    switch (action.type) {
        default:
            return state;
    }
}