import React from 'react';
import './Button.css';

const Button = ({
    children,
    variant = 'primary',
    fullWidth = false,
    onClick,
    type = 'button',
    disabled = false,
    icon: Icon
}) => {
    return (
        <button
            type={type}
            className={`btn btn-${variant} ${fullWidth ? 'btn-full' : ''}`}
            onClick={onClick}
            disabled={disabled}
        >
            {Icon && <Icon size={20} className="btn-icon" />}
            {children}
        </button>
    );
};

export default Button;
