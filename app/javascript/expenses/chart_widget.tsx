import React from "react";
import {
    LineChart,
    Line,
    XAxis,
    YAxis,
    CartesianGrid,
    Tooltip,
    Legend,
    ResponsiveContainer
} from 'recharts';

class CustomizedLabel extends React.PureComponent {
    render() {
      const {
        x, y, stroke, value,
      } = this.props;
  
      return <text x={x} y={y} dy={-4} fill={stroke} fontSize={10} textAnchor="middle">{value}</text>;
    }
}

class CustomizedAxisTick extends React.PureComponent {
    render() {
      const {
        x, y, stroke, payload,
      } = this.props;
  
      return (
        <g transform={`translate(${x},${y})`}>
          <text x={0} y={0} dy={10} fontSize={10} textAnchor="end" fill="#666" transform="rotate(-35)">{payload.value}</text>
        </g>
      );
    }
  }

export default class ExpenseChartWidget extends React.PureComponent {
    render() {
        return (
            <div style={{ width: '100%', height: 400 }}>
                <ResponsiveContainer>
                <LineChart
                    data={this.props.data}
                    margin={{
                        top: 25, right: 25, left: 25, bottom: 25,
                    }}
                >
                    <CartesianGrid strokeDasharray="3 3" />
                    <XAxis height={75} dataKey="name" tick={<CustomizedAxisTick />} />
                    <YAxis />
                    <Tooltip />
                    <Legend />
                    <Line type="monotone" dataKey="Spended" stroke="#2591ff" label={<CustomizedLabel />} />
                </LineChart>
                </ResponsiveContainer>
            </div>
        );
    }
}