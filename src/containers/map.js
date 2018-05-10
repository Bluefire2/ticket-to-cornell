import React, {Component} from 'react';
import {withFauxDOM} from 'react-faux-dom';
import {connect} from 'react-redux';
import * as d3 from 'd3';

import config from '../config.json';

const SCALE = config.scale;

class Map extends Component {
    constructor(props) {
        super(props);

        this.faux = this.props.connectFauxDOM('div', 'map');

        const svg = d3.select(this.faux).append('svg')
            .attr("id", "map")
            .attr("width", this.props.width)
            .attr("height", this.props.height);

        this.svg = svg;

        const locations = d3.select(this.faux).select('#map').selectAll('.location')
            .data(this.props.locations)
            .enter()
            .append('circle')
                .attr('cx', d => d[1] / SCALE)
                .attr('cy', d => d[2] / SCALE)
                .attr('r', 5)
                .attr('fill', 'red');

        // The idea: transform each route datum into multiple rectangle data, and then draw them using D3
        const RECTANGLE_TO_SPACING_RATIO = 4,
            RECTANGLE_HEIGHT = 10;
        const createRectangleDatum = (x, y, width, height, color, taken) => {
            return {
                x,
                y,
                width,
                height,
                color,
                taken
            }
        };
        const routeToRectangleArray = route => {
            const n = route[2], // number of rectangles to draw (route length)
                A = {x: route[0][1] / SCALE, y: route[0][2] / SCALE},
                B = {x: route[1][1] / SCALE, y: route[1][2] / SCALE},
                dx = A.x - B.x,
                dy = A.y - B.y,
                norm = Math.sqrt(dx ** 2 + dy ** 2),
                direction = Math.atan2(dy, dx),
                spacingDistance = norm / (n * (RECTANGLE_TO_SPACING_RATIO + 1) + 1),
                rectangleLength = spacingDistance * 4;

            return (function addRect(acc, i) {
                if(i === n) return acc;
                // TODO: rotate the x and y co-ordinates based on the direction of the gradient
                const x = A.x + spacingDistance + i * (rectangleLength + spacingDistance),
                    y = A.y; // no rotation

                // color and taken are not implemented yet
                const datum = createRectangleDatum(x, y, rectangleLength, RECTANGLE_HEIGHT, null, false);
                acc.push(datum);
                return addRect(acc, i + 1);
            })([], 0);
        };

        const routeRectanglesNested = this.props.game.routes.map(routeToRectangleArray),
            // flatten:
            routeRectangles = routeRectanglesNested.reduce((acc, elem) => acc.concat(elem), []);

        console.log(routeRectangles);

        // This is temporary, for my own convenience:
        const routes = d3.select(this.faux).select('#map').selectAll('.route')
            .data(this.props.game.routes)
            .enter()
            .append('line') // route line (temporary)
                .style('stroke', 'black')
                .attr('x1', d => d[0][1] / SCALE)
                .attr('y1', d => d[0][2] / SCALE)
                .attr('x2', d => d[1][1] / SCALE)
                .attr('y2', d => d[1][2] / SCALE);

        const routePaths = d3.select(this.faux).select('#map').selectAll('.route-path')
            .data(routeRectangles)
            .enter()
            .append('rect')
                .style('stroke', 'black') // black for now
                .style('stroke-width', 3)
                .attr('x', d => d.x)
                .attr('y', d => d.y)
                .attr('width', d => d.width)
                .attr('height', d => d.height);
    }

    render() {
        return (
            <div id="mapContainer" style={{width: this.props.width, height: this.props.height}}>
                {this.props.map}
            </div>
        );
    }
}

const mapStateToProps = ({dimensions, locations, gameState}) => {
    return {
        width: dimensions.width,
        height: dimensions.height,
        locations: locations,
        game: gameState
    };
};

export default connect(mapStateToProps)(withFauxDOM(Map));