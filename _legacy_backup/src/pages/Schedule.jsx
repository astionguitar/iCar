import React, { useState } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { Calendar, Clock, CheckCircle, ChevronLeft } from 'lucide-react';
import Button from '../components/Button';
import Input from '../components/Input';
import { workshops } from '../data/mockData';
import './Schedule.css';

const Schedule = () => {
    const { workshopId, serviceId } = useParams();
    const navigate = useNavigate();
    const [step, setStep] = useState(1);

    const workshop = workshops.find(w => w.id === parseInt(workshopId));
    const service = workshop?.services.find(s => s.id === parseInt(serviceId));

    const [date, setDate] = useState('');
    const [time, setTime] = useState('');

    if (!workshop || !service) {
        return <div className="container">Serviço não encontrado</div>;
    }

    const handleConfirm = () => {
        setStep(2);
        // Aqui seria a chamada para a API
    };

    if (step === 2) {
        return (
            <div className="schedule-success-page container">
                <div className="success-card">
                    <div className="success-icon">
                        <CheckCircle size={48} color="white" />
                    </div>
                    <h1>Agendamento Confirmado!</h1>
                    <p>Seu serviço foi agendado com sucesso.</p>

                    <div className="confirmation-details">
                        <div className="detail-row">
                            <span>Oficina:</span>
                            <strong>{workshop.name}</strong>
                        </div>
                        <div className="detail-row">
                            <span>Serviço:</span>
                            <strong>{service.name}</strong>
                        </div>
                        <div className="detail-row">
                            <span>Data:</span>
                            <strong>{date}</strong>
                        </div>
                        <div className="detail-row">
                            <span>Horário:</span>
                            <strong>{time}</strong>
                        </div>
                        <div className="detail-row">
                            <span>Valor:</span>
                            <strong>R$ {service.price.toFixed(2)}</strong>
                        </div>
                    </div>

                    <Button fullWidth onClick={() => navigate('/')}>Voltar para Home</Button>
                </div>
            </div>
        );
    }

    return (
        <div className="schedule-page container">
            <div className="page-header">
                <button className="back-btn" onClick={() => navigate(-1)}>
                    <ChevronLeft size={24} />
                </button>
                <h1>Agendar Serviço</h1>
            </div>

            <div className="schedule-summary">
                <div className="summary-item">
                    <span className="label">Oficina</span>
                    <span className="value">{workshop.name}</span>
                </div>
                <div className="summary-item">
                    <span className="label">Serviço</span>
                    <span className="value">{service.name}</span>
                </div>
                <div className="summary-item">
                    <span className="label">Valor</span>
                    <span className="value price">R$ {service.price.toFixed(2)}</span>
                </div>
            </div>

            <div className="schedule-form">
                <h2>Escolha o melhor horário</h2>

                <Input
                    label="Data"
                    type="date"
                    value={date}
                    onChange={(e) => setDate(e.target.value)}
                    icon={Calendar}
                />

                <Input
                    label="Horário"
                    type="time"
                    value={time}
                    onChange={(e) => setTime(e.target.value)}
                    icon={Clock}
                />

                <div className="form-actions">
                    <Button
                        fullWidth
                        onClick={handleConfirm}
                        disabled={!date || !time}
                    >
                        Confirmar Agendamento
                    </Button>
                </div>
            </div>
        </div>
    );
};

export default Schedule;
