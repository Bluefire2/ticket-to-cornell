// map dimensions: 2185 x 1743
import config from '../config.json';

const initial = {
    width: 2185 / config.scale,
    height: 1743 / config.scale
};

export default (state = initial, action) => {
    switch (action.type) {
        default:
            return state;
    }
}