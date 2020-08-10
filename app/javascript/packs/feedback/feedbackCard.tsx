// vendors
import React, { useState, useEffect } from 'react';
import SubmitSucceded from './submitSucceded';
import FeedbackForm from './feedbackForm';
import FeedbackSpinner from './feedbackSpinner';

const mockData = [
  {
      id: '0',
      title: 'Reportes',
      description: 'Horas trabajadas, ganancias, etc.'
  },
  {
      id: '1',
      title: 'AFIP',
      description: 'Tramites e inicio en AFIP'
  },
  {
      id: '2',
      title: 'Lorem Ipsum',
      description: 'Lorem ipsum dolor sit amet '
  }
];

const FeedbackCard = props => {
  const { onClose } = props;
  const [ success, setSuccess ] = useState(false);
  const [ loading, setLoading ] = useState(false);
  const [ options, setOptions ] = useState([]);

  async function getOptions() {
    setLoading(true);
    setTimeout(() => {
      setOptions(mockData)
      setLoading(false);
    }, 3000);
  } 

  async function submit() {
    setLoading(true);
    setTimeout(() => {
      setSuccess(true)
      setLoading(false);
    }, 3000);
  }

  useEffect(() => {
    getOptions();
  }, []);

  function renderContent() {
    if (loading) {
      return <FeedbackSpinner />
    }
    if (success) {
      return <SubmitSucceded />;
    }
    return (
      <FeedbackForm 
        options={options}
        onSuccess={() => submit()}
      />
    )
  }
  return (
    <div className="box d-flex flex-column align-items-center feedback-card-container">
       <i className="fas fa-times align-self-end close-icon" onClick={onClose}></i>
       <div className="d-flex flex-grow-1 flex-column justify-content-center">
        {renderContent()}
       </div>
    </div>
  )
}

export default FeedbackCard;
