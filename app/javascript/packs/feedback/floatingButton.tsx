import React from 'react';

const FloatingButton = (props) => {
  const { onClick } = props;
  return (
    <button 
      className="btn btn-primary d-flex justify-content-center align-items-center floating-button"
      onClick={onClick}
    >
      <i className="far fa-comment-alt floating-button-icon"></i>
    </button>
  );
};

export default FloatingButton;
