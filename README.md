This project was bootstrapped with [Create React App](https://github.com/facebookincubator/create-react-app).

## Setup information
Setting this project up is very simple on any system that supports [NPM](https://www.npmjs.com/), since it is compiled using [BuckleScript](https://bucklescript.github.io/).

1. Clone the repository and `cd` into the root directory.
2. Run `npm install` to install all of the required modules. *Make sure to run it in the root directory!*
3. Run `npm run start`, again in the root directory, and the game will run in your default browser.
4. By default, the game runs with two human players. If you want to have more players (up to 5), adjust the `n_players` parameter in the query string. If the game runs on `http://localhost:3000/`, then to run it with 4 players, navigate to `http://localhost:3000/?n_players=4`.
5. To add AI players to the game, adjust the `n_bots` parameter in the query string. For example, to play a game with 5 players, 2 of which are AI-controlled, navigate to `http://localhost:3000/?n_players=5&n_bots=2`.