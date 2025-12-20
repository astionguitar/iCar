import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { Mail, Lock, Car } from 'lucide-react';
import Button from '../components/Button';
import Input from '../components/Input';
import './Login.css';

const Login = () => {
    const navigate = useNavigate();
    const [isLogin, setIsLogin] = useState(true);
    const [email, setEmail] = useState('');
    const [password, setPassword] = useState('');

    const handleSubmit = (e) => {
        e.preventDefault();
        // Simulação de login
        localStorage.setItem('user', JSON.stringify({ email, name: 'Usuário Teste' }));
        navigate('/');
    };

    return (
        <div className="login-page">
            <div className="login-container">
                <div className="login-header">
                    <div className="login-logo">
                        <Car size={32} color="white" />
                    </div>
                    <h1>{isLogin ? 'Bem-vindo de volta' : 'Crie sua conta'}</h1>
                    <p>{isLogin ? 'Acesse sua conta para agendar serviços' : 'Cadastre-se para cuidar do seu carro'}</p>
                </div>

                <form onSubmit={handleSubmit} className="login-form">
                    <Input
                        label="E-mail"
                        type="email"
                        placeholder="seu@email.com"
                        value={email}
                        onChange={(e) => setEmail(e.target.value)}
                        icon={Mail}
                    />

                    <Input
                        label="Senha"
                        type="password"
                        placeholder="••••••••"
                        value={password}
                        onChange={(e) => setPassword(e.target.value)}
                        icon={Lock}
                    />

                    <Button fullWidth type="submit">
                        {isLogin ? 'Entrar' : 'Cadastrar'}
                    </Button>
                </form>

                <div className="login-footer">
                    <p>
                        {isLogin ? 'Não tem uma conta?' : 'Já tem uma conta?'}
                        <button
                            className="link-button"
                            onClick={() => setIsLogin(!isLogin)}
                        >
                            {isLogin ? 'Cadastre-se' : 'Entrar'}
                        </button>
                    </p>
                </div>
            </div>
        </div>
    );
};

export default Login;
