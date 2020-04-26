import React, { useState, useCallback, useEffect } from "react";
import ReactDOM from 'react-dom';
import moment from 'moment'
import MomentUtils from '@material-ui/pickers/adapter/moment';
import { LocalizationProvider, StaticDatePicker } from '@material-ui/pickers';

const DATE_FIELD = document.getElementById('expense_from');
const INITIAL_DATE = DATE_FIELD.getAttribute('value');
const DATE_FORMAT = 'YYYY-MM-DD'

const ExpenseForm = (props) => {
    const [date, setDate] = useState(moment(props.initialDate));

    const onChangeDate = useCallback((newDate: moment.Moment) => {
        DATE_FIELD.setAttribute('value', newDate.format(DATE_FORMAT));
        setDate(newDate);
    }, []);

    useEffect(() => {
        DATE_FIELD.setAttribute('value', date.format(DATE_FORMAT));
    }, []);

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