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

export default class ExpenseChartWidget extends React.PureComponent {
    render() {
        return (
            <div style={{ width: '100%', height: 300 }}>
                <ResponsiveContainer>
                <LineChart data={this.props.data}>
                    <CartesianGrid strokeDasharray="3 3" />
                    <XAxis dataKey="name" />
                    <YAxis />
                    <Tooltip />
                    <Legend />
                    <Line type="monotone" dataKey="Spended" stroke="#2591ff" />
                </LineChart>
                </ResponsiveContainer>
            </div>
        );
    }
}