import React, { useState, useCallback } from "react";
import ReactDOM from "react-dom";
import moment from "moment";
import MomentUtils from '@material-ui/pickers/adapter/moment';
import Grid from '@material-ui/core/Grid';
import { LocalizationProvider } from '@material-ui/pickers';
import { DateRangePicker, DateRange } from "@material-ui/pickers";
import Button from '@material-ui/core/Button';
import { makeStyles } from '@material-ui/core/styles';

const useStyles = makeStyles({
  root: {
    backgroundColor: '#0091ff',
    border: 0,
    borderRadius: 25,
    boxShadow: 'none',
    color: 'white',
    height: 43,
    padding: '0 30px',
    textTransform: 'none',
    '&:hover': {
      backgroundColor: '#56b6ff',
      boxShadow: 'none'
    }
  },
});

function BasicDateRangePicker(props) {
  const classes = useStyles();
  const { from, to } = props;
  const initialDates: DateRange = [
    from ? moment(from) : null,
    to ? moment(to) : null
  ];
  const [selectedDate, handleDateChange] = useState<DateRange>(initialDates);

  const filterExpenses = useCallback((dates: DateRange) => {    
    const [startDate, endDate] = dates;
    
    if (startDate && endDate) {
      const format = 'YYYY-MM-DD';
      const service = `?from=${startDate.format(format)}&to=${endDate.format(format)}`;
      window.location.replace(service);
    }
  }, []);

  return (
    <LocalizationProvider dateAdapter={MomentUtils}>
      <Grid
        direction="row"
        container
        spacing={3}
        alignItems="center"
        justify="flex-end"
      >
        <Grid item xs={9}>
          <DateRangePicker
            startText="Start period"
            endText="End period"
            value={selectedDate}
            onChange={handleDateChange}
            calendars={1}
          />
        </Grid>
        <Grid item xs={3}>
          <Button
            className={classes.root}
            variant="contained"
            color="primary"
            onClick={() => filterExpenses(selectedDate)}
          >
            <i className="fas fa-search mr-1"></i>
            Filter
          </Button>
        </Grid>
      </Grid>
    </LocalizationProvider>
  );
}

const elem = document.getElementById('dateFilter');

if (elem) {
  const params = new URLSearchParams(window.location.search);

  document.addEventListener('DOMContentLoaded', () => {
    ReactDOM.render(
      <BasicDateRangePicker
        from={params.get('from') || null}
        to={params.get('to') || null}
      />,
      elem,
    )
  });
}
