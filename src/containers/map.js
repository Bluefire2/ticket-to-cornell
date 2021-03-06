import React, {Component} from 'react';
import {connect} from 'react-redux';
import {bindActionCreators} from "redux";
import * as d3 from 'd3';
import config from '../config.json';
import {playerColorFromIndex, trainColorFromIndex, trainEnglishColorsToIndicesMap, trainIndexFromEnglishColor, getCategoryInput, equalCaseInsensitive, mod} from "../util";
import {selectRoute} from "../actions/index";
import {get_color, get_player, route_score} from '../ttc-ocaml/src/board.bs';

const url = new URL(window.location.href);
let nPlayers = url.searchParams.get("n_players");

if(nPlayers === null) {
    nPlayers = 2;
} else {
    nPlayers = parseInt(nPlayers);
}

// The idea: transform each route datum into multiple rectangle data, and then draw them using D3
const SCALE = config.scale,
    RECTANGLE_TO_SPACING_RATIO = 4,
    RECTANGLE_HEIGHT = 10,
    RECTANGLE_HEIGHT_TO_DOUBLE_ROUTE_SPACING = 10;

const createRectangleDatum = (x, y, theta, width, height, trainColor, route, routeID) => {
    return {
        x,
        y,
        theta, // needs to be passed in for orientation
        width,
        height,
        trainColor,
        // TODO: figure out why this doesn't work properly and why it need to be adjusted
        takenBy: Array.isArray(get_player(route)) ? get_player(route)[0] : -1,
        route,
        routeID
    }
};
const routeToRectangleArray = (route, index) => {
    const fromName = route[0][0],
        toName = route[1][0],
        uniqueRouteID = `${fromName}-${toName}`;

    const n = route[2], // number of rectangles to draw (route length)
        A = {x: route[0][1] / SCALE, y: route[0][2] / SCALE},
        B = {x: route[1][1] / SCALE, y: route[1][2] / SCALE},
        dx = B.x - A.x,
        dy = B.y - A.y,
        norm = Math.sqrt(dx ** 2 + dy ** 2),
        theta = Math.atan2(dy, dx),
        spacingDistance = norm / (n * (RECTANGLE_TO_SPACING_RATIO + 1) + 1),
        rectangleLength = spacingDistance * 4;

    const trainColor = trainColorFromIndex(get_color(route));

    const doubleRoute = route[5], // is it a double route?
        leftOrRight = doubleRoute ? route[6][0] : -1; // if so, is it a left or right double route?
    // Recursive for extra functional zing!
    return (function addRect(acc, i) {
        if(i === n) return acc;
        // These are the raw X and Y values for the rectangle
        const x = A.x + spacingDistance + i * (rectangleLength + spacingDistance),
            y = A.y - RECTANGLE_HEIGHT / 2;

        // Rotate (x, y) about (A.x, A.y) by theta
        // We still need to orient the rectangle after this! All this does is change the X and Y co-ordinates of
        // its top left corner.
        let xRotated = A.x + (x - A.x) * Math.cos(theta) - (y - A.y) * Math.sin(theta),
            yRotated = A.y + (x - A.x) * Math.sin(theta) + (y - A.y) * Math.cos(theta);

        if(doubleRoute) {
            // if it's a double route we need to transform left or right
            const sign = leftOrRight === 0 ? 1 : -1,
                transformDistance = RECTANGLE_HEIGHT / 2 + (RECTANGLE_HEIGHT / RECTANGLE_HEIGHT_TO_DOUBLE_ROUTE_SPACING);
            const [xTransform, yTransform] = [transformDistance * Math.sin(theta), -transformDistance * Math.cos(theta)].map(elem => elem * sign);

            xRotated += xTransform;
            yRotated += yTransform;
        }

        // color and taken are not implemented yet
        const datum =
            createRectangleDatum(xRotated, yRotated, theta, rectangleLength, RECTANGLE_HEIGHT, trainColor, route, uniqueRouteID);
        acc.push(datum);
        return addRect(acc, i + 1);
    })([], 0);
};

class Map extends Component {
    constructor(props) {
        super(props);
    }

    draw() {
        const routeRectanglesNested = this.props.game.routes.map(routeToRectangleArray),
            // flatten:
            routeRectangles = routeRectanglesNested.reduce((acc, elem) => acc.concat(elem), []);

        // // This is temporary, for my own convenience:
        // const routes = d3.select(this.faux).select('#map').selectAll('.route')
        //     .data(this.props.game.routes)
        //     .enter()
        //     .append('line') // route line (temporary)
        //         .style('stroke', 'black')
        //         .attr('x1', d => d[0][1] / SCALE)
        //         .attr('y1', d => d[0][2] / SCALE)
        //         .attr('x2', d => d[1][1] / SCALE)
        //         .attr('y2', d => d[1][2] / SCALE);

        console.log('updating');
        d3.select('#mapContainer').select('#map').selectAll('.route-path-rect').remove();

        // Draw the borders:
        const routePathBorders = d3.select('#mapContainer').select('#map').selectAll('.route-path')
            .data(routeRectangles)
            .enter()
            .append('rect')
            .on('click', d => this.claimRoute.bind(this)(d.route))
            .style('stroke', d => d.trainColor)
            .attr('class', d => `route-path-rect clickable ${d.takenBy > -1 ? 'route-path-rect-taken' : ''}`)
            .attr('route', d => `${d.routeID}`)
            .style('fill', d => playerColorFromIndex(d.takenBy))
            .attr('x', d => d.x)
            .attr('y', d => d.y)
            // orient the rectangle, by rotating about its top left corner:
            .attr('transform', d => `rotate(${d.theta * 180 / Math.PI}, ${d.x}, ${d.y})`)
            .attr('width', d => d.width)
            .attr('height', d => d.height);

        // Now draw the actual rectangles with zero opacity:
        // TODO: extract all this into a function or something
        const routePathRectangles = d3.select('#mapContainer').select('#map').selectAll('.route-path')
            .data(routeRectangles)
            .enter()
            .append('rect')
            .on('click', d => this.claimRoute.bind(this)(d.route))
            .on('mouseover', d => {
                this.routeTooltip.transition()
                    .duration(200)
                    .style("opacity", .9);
                this.routeTooltip.html(`${d.routeID} <br\> Points: ${route_score(d.route)}`)
                    .style("left", (d3.event.pageX) + "px")
                    .style("top", (d3.event.pageY - 28) + "px");
            })
            .on('mouseout', d => {
                this.routeTooltip.transition()
                    .duration(500)
                    .style("opacity", 0);
            })
            .style('stroke', d => d.trainColor)
            .attr('class', d => `route-path-rect clickable ${d.takenBy > -1 ? 'route-path-rect-taken' : ''}`)
            .attr('route', d => `${d.routeID}`)
            .style('opacity', 0)
            .attr('x', d => d.x)
            .attr('y', d => d.y)
            // orient the rectangle, by rotating about its top left corner:
            .attr('transform', d => `rotate(${d.theta * 180 / Math.PI}, ${d.x}, ${d.y})`)
            .attr('width', d => d.width)
            .attr('height', d => d.height);

        // This allows the interior of the "rectangle" to be transparent but still clickable
    }

    componentDidMount() {
        const svg = d3.select('#mapContainer').append('svg')
            .attr("id", "map")
            .attr("width", this.props.width)
            .attr("height", this.props.height);

        this.svg = svg;

        const locations = d3.select('#mapContainer').select('#map').selectAll('.location')
            .data(this.props.locations)
            .enter()
            .append('circle')
            .on('mouseover', d => {
                this.locationTooltip.transition()
                    .duration(200)
                    .style("opacity", .9);
                this.locationTooltip.html(d[0])
                    .style("left", (d3.event.pageX) + "px")
                    .style("top", (d3.event.pageY - 28) + "px");
            })
            .on('mouseout', d => {
                this.locationTooltip.transition()
                    .duration(500)
                    .style("opacity", 0);
            })
            .attr('data-tip', '')
            .attr('data-for', 'location-tip')
            .attr('cx', d => d[1] / SCALE)
            .attr('cy', d => d[2] / SCALE)
            .attr('r', 5)
            .attr('fill', 'red');

        this.locations = locations;

        const locationTooltip = d3.select("body").append("div")
            .attr("class", "tooltip-location")
            .style("opacity", 0);

        const routeTooltip = d3.select("body").append("div")
            .attr("class", "tooltip-route")
            .style("opacity", 0);

        this.locationTooltip = locationTooltip;
        this.routeTooltip = routeTooltip;

        this.draw();
    }

    componentDidUpdate() {
        this.draw();
    }

    claimRoute(route) {
        let trainColor = get_color(route),
            trainColorParsed = trainColorFromIndex(trainColor);
        // first check if we need to ask for the primary train colour (i.e. if the route is gray)
        if(trainColorParsed === 'grey') {
            const selectedColor =
                getCategoryInput(
                    'Enter train color to use for this route',
                    trainEnglishColorsToIndicesMap,
                    equalCaseInsensitive
                ).toLowerCase();
            trainColor = trainIndexFromEnglishColor(selectedColor);
        }
        // then, check if they want to use any wildcards, and if so, how many
        const amountOfWildcards = parseInt(
            getCategoryInput('How many wildcards do you want to use?',
                [0, 1, 2, 3, 4, 5, 6].map(elem => '' + elem)) // :(
        );
        this.props.selectRoute(route, trainColor, amountOfWildcards);
    }

    render() {
        return (
            <div id="mapContainer" style={{width: this.props.width, height: this.props.height}}>

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

const mapDispatchToProps = dispatch => {
    return bindActionCreators({
        selectRoute
    }, dispatch);
};

export default connect(mapStateToProps, mapDispatchToProps)(Map);