import React, {Component} from 'react';
import {withFauxDOM} from 'react-faux-dom';
import {connect} from 'react-redux';
import * as d3 from 'd3';

class Map extends Component {
    constructor(props) {
        super(props);

        this.faux = this.props.connectFauxDOM('div', 'map');

        const svg = d3.select(this.faux).append('svg')
            .attr("id", "map")
            .attr("width", this.props.width)
            .attr("height", this.props.height);

        this.svg = svg;
    }

    render() {
        return (
            <div id="mapContainer" style={{width: this.props.width, height: this.props.height}}>
                {this.props.map}
            </div>
        );
    }
}

const mapStateToProps = state => {
    return {
        width: state.dimensions.width,
        height: state.dimensions.height
    };
};

export default connect(mapStateToProps)(withFauxDOM(Map));