import React, { useState, useEffect } from 'react';
import ReactDOM from 'react-dom';
import FloatingButton from './floatingButton';
import FeedbackCard from './feedbackCard';

const FeedbackModal = () => {
    const [ open, setOpen ] = useState(false);

    function toggleModal() {
        setOpen(!open);
    }

    useEffect(() => {
        if (open && window.innerWidth < 600) {
            document.body.style.overflowY = 'hidden'
        } else {
            document.body.style.overflowY = 'scroll'
        }
    }, [ open ]);

    return (
        <div className="feedback-modal-container">
            {open ? (
               <FeedbackCard onClose={toggleModal} />
            ): (
                <FloatingButton onClick={toggleModal} />
            )}
        </div>
    );
};

ReactDOM.render(
    <FeedbackModal />,
    document.getElementById('feedback-modal')
);
