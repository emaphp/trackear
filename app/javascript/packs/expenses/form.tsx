import React, { useState, useCallback, useEffect } from "react";
import ReactDOM from 'react-dom';
import moment from 'moment'
import MomentUtils from '@material-ui/pickers/adapter/moment';
import { LocalizationProvider, StaticDatePicker } from '@material-ui/pickers';

const DATE_FIELD = document.getElementById('expense_from');
const INITIAL_DATE = DATE_FIELD.getAttribute('value') || undefined;
const DATE_FORMAT = 'YYYY-MM-DD'

const ExpenseForm = (props) => {
    const [date, setDate] = useState(moment(props.initialDate));

    const onChangeDate = useCallback((newDate: moment.Moment) => {
        setDate(newDate);
    }, []);

    useEffect(() => {
        DATE_FIELD.setAttribute('value', date.format(DATE_FORMAT));
    }, [date]);

    return (
        <LocalizationProvider dateAdapter={MomentUtils}>
            <StaticDatePicker
                label="Expense date"
                showTodayButton
                showToolbar
                autoOk
                orientation="landscape"
                openTo="date"
                value={date}
                onChange={onChangeDate}
            />
        </LocalizationProvider>
    )
}

ReactDOM.render(
    <ExpenseForm initialDate={INITIAL_DATE} />,
    document.getElementById('dateField')
)