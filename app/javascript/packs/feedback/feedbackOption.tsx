import React, { ChangeEvent } from 'react';

interface FeedbackOption {
    checked: boolean,
    value: number,
    name: string,
    onChange: (e: ChangeEvent<HTMLInputElement>) => void,
    title: string,
    summary?: string
}

const FeedbackOption: React.FC<FeedbackOption> = ({ 
    checked,
    name,
    value,
    onChange,
    title,
    summary
}) => (
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
            <span>{summary}</span>
        </div>
    </label>
);

export default FeedbackOption;
