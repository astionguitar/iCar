import React from 'react';
import { Star, MapPin } from 'lucide-react';
import ServiceBadge from './ServiceBadge';
import './WorkshopCard.css';

const WorkshopCard = ({ workshop, onClick }) => {
    return (
        <div className="workshop-card" onClick={onClick}>
            <div className="workshop-image-container">
                <img src={workshop.image} alt={workshop.name} className="workshop-image" />
                <div className="workshop-rating">
                    <Star size={14} fill="#F59E0B" stroke="#F59E0B" />
                    <span>{workshop.rating}</span>
                    <span className="review-count">({workshop.reviewCount})</span>
                </div>
            </div>

            <div className="workshop-content">
                <h3 className="workshop-name">{workshop.name}</h3>

                <div className="workshop-info">
                    <div className="workshop-distance">
                        <MapPin size={16} />
                        <span>{workshop.distance}</span>
                    </div>
                    <span className="separator">•</span>
                    <span className="workshop-address-short">{workshop.address.split('-')[1]?.trim() || workshop.address}</span>
                </div>

                <div className="workshop-categories">
                    {workshop.categories.slice(0, 3).map((cat, index) => (
                        <ServiceBadge key={index}>{cat}</ServiceBadge>
                    ))}
                </div>
            </div>
        </div>
    );
};

export default WorkshopCard;
