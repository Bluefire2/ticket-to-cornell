const applyToObjectField = (obj, field, fn) => {
    obj[field] = fn(obj[field]);
};

// Convert OCaml List to JS Array
export const listToArray = list => {
    if(list === 0) return [];
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

// Convert JS Array to OCaml List
export const arrayToList = array => {
    const arrayToListStep = (array, i) => {
        if(array.length === i) {
            return 0;
        } else {
            return [array[i], arrayToListStep(array, i + 1)];
        }
    };

    return arrayToListStep(array, 0);
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

const stateListFields = [
    'players',
    'routes',
    'destination_deck',
    'destination_trash',
    'choose_destinations',
    'train_deck',
    'facing_up_trains',
    'train_trash'
];

// Convert OCaml State to JS State Object
export const stateToObj = state => {
    return stateToObjMap.reduce(
        (acc, elem, index) => {
            if(stateListFields.includes(elem)) {
                acc[elem] = listToArray(state[index]);
            } else {
                acc[elem] = state[index];
            }
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
        if(stateListFields.includes(key)) {
            state[i] = arrayToList(value);
        } else {
            state[i] = value;
        }
    }
    return state;
};

// Convert BuckleScript colour indices to actual colours
export const trainColorFromIndex = i => {
    switch(i) {
        case 0:
            return 'red';
        case 1:
            return 'green';
        case 2:
            return 'blue';
        case 3:
            return 'yellow';
        case 4:
            return 'pink';
        case 5:
            return 'orange';
        case 6:
            return 'white';
        case 7:
            return 'black';
        case 8:
            // TODO: figure out a colour to use for Wild
            return 'black'; // Wild
        case 9:
        default:
            return 'grey';
    }
};

// TODO: do the same for player colours

export const destinationToObj = destination => {
    return {
        from: destination[0],
        to: destination[1],
        points: destination[2]
    }
};