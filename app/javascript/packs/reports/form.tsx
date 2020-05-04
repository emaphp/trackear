import React, { useState, useCallback, useEffect } from "react";
import ReactDOM from 'react-dom';
import moment from 'moment'
import MomentUtils from '@material-ui/pickers/adapter/moment';
import { LocalizationProvider, DateRangePicker, DateRange } from '@material-ui/pickers';

const FROM_FIELD = document.getElementById('report_from');
const TO_FIELD = document.getElementById('report_to');
const INITIAL_FROM_VALUE = FROM_FIELD.getAttribute('value') || undefined;
const INITIAL_TO_VALUE = TO_FIELD.getAttribute('value') || undefined;
const DATE_FORMAT = 'YYYY-MM-DD'

const ReportForm = (props) => {
    const { initialFrom, initialTo } = props;
    const from = initialFrom || undefined;
    const to = initialTo || undefined;
    const initialDates: DateRange = [moment(from), moment(to)];
    const [dates, setDates] = useState<DateRange>(initialDates);

    const onChangeDate = useCallback((newDates: DateRange) => {
        setDates(newDates);
    }, []);

    useEffect(() => {
        const [from, to] = dates;

        if (from) {
            FROM_FIELD.setAttribute('value', from.format(DATE_FORMAT));
        }

        if (to) {
            TO_FIELD.setAttribute('value', to.format(DATE_FORMAT));
        }
    }, [dates]);

    return (
        <LocalizationProvider dateAdapter={MomentUtils}>
            <DateRangePicker
                startText="Start period"
                endText="End period"
                value={dates}
                onChange={onChangeDate}
                calendars={1}
            />
        </LocalizationProvider>
    )
}

ReactDOM.render(
    <ReportForm initialFrom={INITIAL_FROM_VALUE} initialTo={INITIAL_TO_VALUE} />,
    document.getElementById('dateField')
)