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
                .attr('r', 5);
    }

    render() {
        return (
            <div id="mapContainer" style={{width: this.props.width, height: this.props.height}}>
                {this.props.map}
            </div>
        );
    }
}

const mapStateToProps = ({dimensions, locations}) => {
    return {
        width: dimensions.width,
        height: dimensions.height,
        locations: locations
    };
};

export default connect(mapStateToProps)(withFauxDOM(Map));