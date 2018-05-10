// Convert OCaml List to JS Array
export const listToArray = list => {
    const listToArrayStep = (list, acc) => {
        acc.push(list[0]);
        if(list[1] !== 0) {
            return listToArrayStep(list[1], acc);
        } else {
            return acc;
        }
    };

    return listToArrayStep(list, []);
};

const stateToObjMap = [
    'player_index',
    'players',
    'routes',
    'destination_deck',
    'destination_trash',
    'choose_destinations',
    'train_deck',
    'facing_up_trains',
    'train_trash',
    'taking_routes',
    'error',
    'turn_ended'
];

// Convert OCaml State to JS State Object
export const stateToObj = state => {
    return stateToObjMap.reduce(
        (acc, elem, index) => {
            acc[elem] = state[index];
            return acc;
        },
        {}
    );
};

// Convert JS State Object to OCaml State
export const objToState = obj => {
    const state = [];
    for(const [key, value] of Object.entries(obj)) {
        const i = stateToObjMap.indexOf(key);
        state[i] = value;
    }
    return state;
};