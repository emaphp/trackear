import React from 'react'

interface SubmitButton {
    disabled: boolean
}

const SubmitButton: React.FC<SubmitButton> = ({ disabled }) => (
    <button 
        type="submit"
        disabled={disabled}
        className="btn btn-primary btn-lg w-100 submit-button"
    >
        Enviar feedback
    </button>
);

export default SubmitButton;
