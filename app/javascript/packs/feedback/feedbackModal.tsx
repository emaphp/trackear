import React, { useState, useEffect } from 'react';
import ReactDOM from 'react-dom';
import FloatingButton from './floatingButton';
import FeedbackCard from './feedbackCard';

const FeedbackModal: React.FC = () => {
    const [ open, setOpen ] = useState<boolean>(false);

    function toggleModal() {
        setOpen(!open);
    }

    useEffect(() => {
        if (open && window.innerWidth < 600) {
            document.body.classList.add('hide-scrollbar');
        } else {
            document.body.classList.remove('hide-scrollbar');
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
