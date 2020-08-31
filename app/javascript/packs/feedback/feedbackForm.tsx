import React, { useState, ChangeEvent, FormEvent } from 'react';
import SubmitButton from './submitButton';
import SummaryTextArea from './summaryTextArea';
import FeedbackOption from './feedbackOption';
import { Option, FeedbackFormState } from './feedbackTypes';

interface FeedbackForm {
    onSubmit: (formState: FeedbackFormState) => void,
    options: Option[]
}

const FeedbackForm: React.FC<FeedbackForm> = props => {
    const { onSubmit, options } = props;
    const [ formState, setFormState ] = useState<FeedbackFormState>({
        selectedOption: undefined,
        summary: ''
    });
    const isOtherSelected = formState.selectedOption === -1;

    function handleInputChange(e: ChangeEvent<HTMLInputElement | HTMLTextAreaElement>) {
        const { value, name } = e.target;
        const isSummaryChange = name === 'summary';
        setFormState({
            ...formState,
            selectedOption: isSummaryChange ? -1 : parseInt(value),
            summary: isSummaryChange ? value : ''
        })
    }

    function handleOnSubmit(e: FormEvent<HTMLFormElement>) {
        e.preventDefault();
        onSubmit(formState);
    }

    const fetchedOptions: JSX.Element[] = options.map(({ id, title, summary }: Option) => (
        <FeedbackOption 
            key={id.toString()}
            name="feedback"
            checked={formState.selectedOption === id}
            onChange={handleInputChange}
            value={id}
            title={title}
            summary={summary}
        />
    ));    

    return (
        <div className="d-flex flex-column align-items-center flex-grow-1 feedback-form-container">
            <p className="text-center">¿En qué te podemos ayudar? Tus comentarios son muy apreciados</p>
            <form onSubmit={handleOnSubmit} className="d-flex flex-column flex-grow-1 w-100">
                <div className="d-flex flex-column flex-grow-1">
                    {fetchedOptions}
                    {isOtherSelected ? (
                        <SummaryTextArea 
                            onChange={handleInputChange}
                            value={formState.summary}
                        />
                    ) : (
                        <FeedbackOption 
                            checked={false}
                            onChange={handleInputChange}
                            value={-1}
                            title="Otro"
                            name="other"
                        />
                    )}
                </div>
                <SubmitButton disabled={!formState.selectedOption} />
            </form>
        </div>
    );
};

export default FeedbackForm;
