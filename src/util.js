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