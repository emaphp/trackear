// vendors
import React, { useState, useEffect } from 'react';
import * as Rails from "@rails/ujs"
import axios from 'axios';
import SubmitSucceded from './submitSucceded';
import FeedbackForm from './feedbackForm';
import FeedbackSpinner from './feedbackSpinner';
import { Option, FeedbackFormState } from './feedbackTypes';

interface FeedbackCard {
  onClose: () => {}
}

interface FeedbackCardState {
  success: boolean,
  loading: boolean,
  options: Option[]
}

const FeedbackCard: React.FC<FeedbackCard> = props => {
  const { onClose } = props;
  const [ fetchState, setFetchState ] = useState<FeedbackCardState>({
    success: false,
    loading: true,
    options: []
  });

  function startLoading(): void {
    setFetchState({
      ...fetchState,
      loading: true
    });
  }

  function stopLoading(): void {
    setFetchState({
      ...fetchState,
      loading: false
    });
  }

  function saveOptions(options: Option[]): void {
    setFetchState({
      ...fetchState,
      loading: false,
      options
    })
  }

  function showMessage(): void {
    setFetchState({
      ...fetchState,
      loading: false,
      success: true
    })
  }

  async function getOptions(): Promise<void> {
    startLoading()
    const service = '/feedback_options.json';
    axios.get(service)
      .then(res => saveOptions(res.data))
      .catch(e => {
        const limitReached= e.response.status === 403;
        if (limitReached) {
          showMessage()
        } else {
          onClose()
        }
      });
  } 

  async function submit(formState: FeedbackFormState): Promise<void>{
    startLoading()
    const token = Rails.csrfToken();
    const isOther= formState.selectedOption === -1;
    const service = `/${isOther ? 'other_' : ''}submissions.json`;
    const payload = {
      authenticity_token: token,
      feedback_option_id: formState.selectedOption,
      summary: formState.summary
    };

    axios.post(service, payload)
      .then(res => showMessage())
      .catch(e => stopLoading())
  }

  useEffect(() => {
    getOptions();
  }, []);

  function renderContent(): JSX.Element {
    const { loading, success, options } = fetchState;
    if (loading) {
      return <FeedbackSpinner />
    }
    if (success) {
      return <SubmitSucceded />;
    }
    return (
      <FeedbackForm 
        options={options}
        onSubmit={submit}
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
