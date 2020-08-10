import React from 'react';
import { CircularProgress, makeStyles } from '@material-ui/core';

const useStyles = makeStyles({
    colorPrimary: {
        color: '#6992FF'
    }
})

const feedbackSpinner = () => {
    const classes = useStyles();
    return (
        <CircularProgress classes={{ colorPrimary: classes.colorPrimary }}/>
    )
}

export default feedbackSpinner
