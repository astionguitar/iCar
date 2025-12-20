import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { Search, Filter } from 'lucide-react';
import WorkshopCard from '../components/WorkshopCard';
import ServiceBadge from '../components/ServiceBadge';
import Input from '../components/Input';
import { workshops, categories } from '../data/mockData';
import './Home.css';

const Home = () => {
    const navigate = useNavigate();
    const [selectedCategory, setSelectedCategory] = useState('all');
    const [searchTerm, setSearchTerm] = useState('');

    const filteredWorkshops = workshops.filter(workshop => {
        const matchesCategory = selectedCategory === 'all' ||
            workshop.categories.some(cat => cat.toLowerCase().includes(categories.find(c => c.id === selectedCategory).name.toLowerCase()));

        const matchesSearch = workshop.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
            workshop.address.toLowerCase().includes(searchTerm.toLowerCase());

        return matchesCategory && matchesSearch;
    });

    return (
        <div className="home-page">
            <section className="hero-section">
                <div className="container">
                    <h1 className="hero-title">Encontre a oficina ideal para o seu carro</h1>
                    <p className="hero-subtitle">Manutenção simples, transparente e perto de você.</p>

                    <div className="search-container">
                        <Input
                            placeholder="Buscar por nome ou endereço..."
                            icon={Search}
                            value={searchTerm}
                            onChange={(e) => setSearchTerm(e.target.value)}
                        />
                    </div>

                    <div className="categories-scroll">
                        {categories.map(category => (
                            <ServiceBadge
                                key={category.id}
                                active={selectedCategory === category.id}
                                onClick={() => setSelectedCategory(category.id)}
                            >
                                {category.name}
                            </ServiceBadge>
                        ))}
                    </div>
                </div>
            </section>

            <section className="workshops-list container">
                <div className="section-header">
                    <h2 className="section-title">Oficinas Recomendadas</h2>
                    <span className="result-count">{filteredWorkshops.length} resultados</span>
                </div>

                <div className="workshops-grid">
                    {filteredWorkshops.map(workshop => (
                        <WorkshopCard
                            key={workshop.id}
                            workshop={workshop}
                            onClick={() => navigate(`/workshop/${workshop.id}`)}
                        />
                    ))}
                </div>

                {filteredWorkshops.length === 0 && (
                    <div className="empty-state">
                        <p>Nenhuma oficina encontrada com os filtros atuais.</p>
                    </div>
                )}
            </section>
        </div>
    );
};

export default Home;
