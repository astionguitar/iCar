import React from 'react';
import { Car, User } from 'lucide-react';
import { useNavigate } from 'react-router-dom';
import Button from './Button';
import './Header.css';

const Header = () => {
    const navigate = useNavigate();
    return (
        <header className="header">
            <div className="container header-content">
                <div className="logo-container" onClick={() => navigate('/')}>
                    <div className="logo-icon">
                        <Car size={24} color="white" />
                    </div>
                    <span className="logo-text">iCar</span>
                </div>

                <nav className="nav-menu">
                    <Button variant="ghost" icon={User} onClick={() => navigate('/login')}>Entrar</Button>
                </nav>
            </div>
        </header>
    );
};

export default Header;
