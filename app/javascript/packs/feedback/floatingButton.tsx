import React from 'react';

interface FloatingButtonProps {
  onClick: (e: React.MouseEvent<HTMLButtonElement>) => void
}

const FloatingButton: React.FC<FloatingButtonProps> = (props) => {
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
