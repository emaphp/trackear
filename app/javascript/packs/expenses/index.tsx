import React from "react";
import ReactDOM from "react-dom";
import moment from "moment";
import ExpenseDateRangeFilterWidget from "../../expenses/date_range_filter_widget";
import ExpenseChartWidget from "../../expenses/chart_widget";

const dateFilter = document.getElementById('dateFilter');
const params = new URLSearchParams(window.location.search);
const defaultFrom = moment().startOf('month');
const defaultTo = moment().endOf('month');

ReactDOM.render(
    <ExpenseDateRangeFilterWidget
        from={params.get('from') || defaultFrom}
        to={params.get('to') || defaultTo}
    />,
    dateFilter,
)

const chart = document.getElementById('chart');
  
if (chart) {
  ReactDOM.render(
    <ExpenseChartWidget data={window.data} />,
    chart,
  )
}