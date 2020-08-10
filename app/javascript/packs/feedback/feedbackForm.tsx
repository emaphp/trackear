import React, { useState, useEffect } from 'react';

const SubmitButton = ({ disabled }) => (
    <button 
        type="submit"
        disabled={disabled}
        className="btn btn-primary btn-lg w-100 submit-button"
    >
        Enviar feedback
    </button>
);

interface IFeedbackOption {
    checked: boolean,
    value: string,
    name: string,
    onChange: () => {},
    title: string,
    description?: string
}

const FeedbackOption = ({ checked, name, value, onChange, title, description }: IFeedbackOption ) => (
    <label className="d-flex align-items-center feedback-option-item">
        <input
            type="radio" 
            value={value}
            checked={checked}
            onChange={onChange}
            name={name}
        />
        <div className="d-flex flex-column">
            <span className="font-weight-bold">{title}</span>
            <span>{description}</span>
        </div>
    </label>
);

const OtherDescription = ({ value, onChange }) => (
    <div className="d-flex flex-column description-container">
        <p className="other-title">Otro problema</p>
        <textarea
            className="w-100 description-area"
            value={value}
            onChange={onChange}
            rows={5}
            name="other-description"
        />
    </div>
);


const FeedbackForm = props => {
    const { onSuccess, options } = props;
    const [ formState, setFormState ] = useState({
        selectedOption: undefined,
        description: ''
    });
    const isOtherSelected = formState.selectedOption === 'other';

    function handleInputChange(e) {
        const { value, name } = e.target;
        setFormState({
            ...formState,
            selectedOption: name.includes('other') ? 'other' : value,
            description: name === 'other-description' ? value : ''
        })
    }

    function handleOnSubmit(e) {
        e.preventDefault();
        onSuccess();
    }

    const fetchedOptions = options.map(({ id, ...optionDetails }) => (
        <FeedbackOption 
            key={id}
            name="feedback"
            checked={formState.selectedOption === id}
            onChange={handleInputChange}
            value={id}
            {...optionDetails}
        />
    ));    

    return (
        <div className="d-flex flex-column align-items-center flex-grow-1 feedback-form-container">
            <p className="text-center">¿En qué te podemos ayudar? Tus comentarios son muy apreciados</p>
            <form onSubmit={handleOnSubmit} className="d-flex flex-column flex-grow-1 w-100">
                <div className="d-flex flex-column flex-grow-1">
                    {fetchedOptions}
                    {isOtherSelected ? (
                        <OtherDescription 
                            onChange={handleInputChange}
                            value={formState.description}
                        />
                    ) : (
                        <FeedbackOption 
                            checked={false}
                            onChange={handleInputChange}
                            value="other"
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
