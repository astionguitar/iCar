import React from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { Star, MapPin, Clock, ChevronLeft, CheckCircle } from 'lucide-react';
import Button from '../components/Button';
import ServiceBadge from '../components/ServiceBadge';
import { workshops } from '../data/mockData';
import './WorkshopDetails.css';

const WorkshopDetails = () => {
    const { id } = useParams();
    const navigate = useNavigate();
    const workshop = workshops.find(w => w.id === parseInt(id));

    if (!workshop) {
        return <div className="container">Oficina não encontrada</div>;
    }

    return (
        <div className="workshop-details-page">
            <div className="workshop-header-image">
                <img src={workshop.image} alt={workshop.name} />
                <button className="back-button" onClick={() => navigate(-1)}>
                    <ChevronLeft size={24} />
                </button>
            </div>

            <div className="container workshop-content-wrapper">
                <div className="workshop-header-info">
                    <div className="flex justify-between items-start">
                        <div>
                            <h1 className="workshop-title">{workshop.name}</h1>
                            <div className="flex items-center gap-sm text-secondary text-sm">
                                <MapPin size={16} />
                                <span>{workshop.address}</span>
                            </div>
                        </div>
                        <div className="workshop-rating-large">
                            <Star size={20} fill="#F59E0B" stroke="#F59E0B" />
                            <span className="rating-value">{workshop.rating}</span>
                            <span className="rating-count">({workshop.reviewCount} avaliações)</span>
                        </div>
                    </div>

                    <div className="flex gap-sm mt-md">
                        {workshop.categories.map((cat, index) => (
                            <ServiceBadge key={index}>{cat}</ServiceBadge>
                        ))}
                    </div>
                </div>

                <div className="section-block">
                    <h2 className="section-title">Sobre a oficina</h2>
                    <p className="text-secondary">{workshop.description}</p>
                </div>

                <div className="section-block">
                    <h2 className="section-title">Serviços Disponíveis</h2>
                    <div className="services-list">
                        {workshop.services.map(service => (
                            <div key={service.id} className="service-item">
                                <div className="service-info">
                                    <h3 className="service-name">{service.name}</h3>
                                    <div className="flex items-center gap-sm text-secondary text-sm">
                                        <Clock size={14} />
                                        <span>{service.duration}</span>
                                    </div>
                                </div>
                                <div className="service-action">
                                    <span className="service-price">R$ {service.price.toFixed(2)}</span>
                                    <Button size="sm" onClick={() => navigate(`/schedule/${workshop.id}/${service.id}`)}>
                                        Agendar
                                    </Button>
                                </div>
                            </div>
                        ))}
                    </div>
                </div>

                <div className="section-block">
                    <h2 className="section-title">Avaliações</h2>
                    <div className="reviews-list">
                        {workshop.reviews.map(review => (
                            <div key={review.id} className="review-item">
                                <div className="flex justify-between items-center mb-sm">
                                    <span className="review-user">{review.user}</span>
                                    <span className="review-date">{review.date}</span>
                                </div>
                                <div className="flex items-center gap-xs mb-sm">
                                    {[...Array(5)].map((_, i) => (
                                        <Star
                                            key={i}
                                            size={14}
                                            fill={i < review.rating ? "#F59E0B" : "none"}
                                            stroke={i < review.rating ? "#F59E0B" : "#CBD5E1"}
                                        />
                                    ))}
                                </div>
                                <p className="review-comment">{review.comment}</p>
                            </div>
                        ))}
                    </div>
                </div>
            </div>
        </div>
    );
};

export default WorkshopDetails;
