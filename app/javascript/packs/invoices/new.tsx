import React from "react";
import ReactDOM from 'react-dom';
import ThemedStyleSheet from 'react-with-styles/lib/ThemedStyleSheet';
import aphroditeInterface from 'react-with-styles-interface-aphrodite';
import DefaultTheme from 'react-dates/lib/theme/DefaultTheme';
import InvoiceForm from "../../invoices/components/form";

ThemedStyleSheet.registerInterface(aphroditeInterface);
ThemedStyleSheet.registerTheme({
    reactDates: {
        ...DefaultTheme.reactDates,
        color: {
            ...DefaultTheme.reactDates.color,
            hoveredSpan: {
                borderColor: '#eaecef',
                backgroundColor: '#e6f5ff',
            },
            selectedSpan: {
                borderColor: '#eaecef',
                backgroundColor: '#e6f5ff',
            },
            selected: {
                borderColor: '#eaecef',
                backgroundColor: '#bce4ff',
            }
        },
    },
});

const projectSlug = document.getElementById('project_slug').value
ReactDOM.render(
    <InvoiceForm projectId={projectSlug} />,
    document.getElementById('dateField')
)
