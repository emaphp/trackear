import React, { ChangeEvent } from 'react';

interface SummaryTextArea {
    value: string,
    onChange: (e: ChangeEvent<HTMLTextAreaElement>) => void
}

const SummaryTextArea: React.FC<SummaryTextArea> = ({ value, onChange }) => (
    <div className="d-flex flex-column summary-container">
        <p className="other-title">Otro problema</p>
        <textarea
            className="w-100 summary-area"
            value={value}
            onChange={onChange}
            rows={5}
            name="summary"
        />
    </div>
);

export default SummaryTextArea