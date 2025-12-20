import React from 'react';
import './ServiceBadge.css';

const ServiceBadge = ({ children, active = false, onClick }) => {
    return (
        <span
            className={`service-badge ${active ? 'active' : ''} ${onClick ? 'clickable' : ''}`}
            onClick={onClick}
        >
            {children}
        </span>
    );
};

export default ServiceBadge;
