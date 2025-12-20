import React from 'react';
import './Input.css';

const Input = ({
    label,
    type = 'text',
    placeholder,
    value,
    onChange,
    icon: Icon,
    error
}) => {
    return (
        <div className="input-wrapper">
            {label && <label className="input-label">{label}</label>}
            <div className={`input-container ${error ? 'input-error' : ''}`}>
                {Icon && <Icon size={20} className="input-icon" />}
                <input
                    type={type}
                    className="input-field"
                    placeholder={placeholder}
                    value={value}
                    onChange={onChange}
                />
            </div>
            {error && <span className="input-error-message">{error}</span>}
        </div>
    );
};

export default Input;
