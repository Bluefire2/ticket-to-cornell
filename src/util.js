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
            return '#f43434'; // red
        case 1:
            return '#2e9030'; // green
        case 2:
            return '#3e7aab'; // blue
        case 3:
            return '#e5d31e'; // yellow
        case 4:
            return '#f66f98'; // pink
        case 5:
            return '#f6882c'; // orange
        case 6:
            return 'white';
        case 7:
            return 'black';
        case 8:
            return 'black'; // Wild
        case 9:
        default:
            return 'grey';
    }
};

// Convert BuckleScript colour indices to actual colours
export const trainColorCardFromIndex = i => {
    switch(i) {
        case 0:
            return 'linear-gradient(#f43434, #f43434) 1'; // red
        case 1:
            return 'linear-gradient(#2e9030, #2e9030) 1'; // green
        case 2:
            return 'linear-gradient(#3e7aab, #3e7aab) 1'; // blue
        case 3:
            return 'linear-gradient(#e5d31e, #e5d31e) 1'; // yellow
        case 4:
            return 'linear-gradient(#f66f98, #f66f98) 1'; // pink
        case 5:
            return 'linear-gradient(#f6882c, #f6882c) 1'; // orange
        case 6:
            return 'linear-gradient(white, white) 1';
        case 7:
            return 'linear-gradient(black, black) 1';
        case 8:
            return 'linear-gradient(#00C0FF 0%, #FFCF00 49%, #FC4F4F 100%) 1'; // Wild
        case 9:
        default:
            return 'linear-gradient(grey, grey) 1';
    }
};

export const playerColorFromIndex = i => {
    switch(i) {
        case 0:
            return 'blue';
        case 1:
            return 'red';
        case 2:
            return 'yellow';
        case 3:
            return 'green';
        case 4:
            return 'black';
        default:
            return 'grey';
    }
};

export const destinationToObj = destination => {
    return {
        from: destination[0],
        to: destination[1],
        points: destination[2]
    }
};
