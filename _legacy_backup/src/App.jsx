import React from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import Header from './components/Header';
import Home from './pages/Home';
import WorkshopDetails from './pages/WorkshopDetails';
import Schedule from './pages/Schedule';
import Login from './pages/Login';
import './App.css';

function App() {
  return (
    <Router>
      <div className="app">
        <Header />
        <main>
          <Routes>
            <Route path="/" element={<Home />} />
            <Route path="/workshop/:id" element={<WorkshopDetails />} />
            <Route path="/schedule/:workshopId/:serviceId" element={<Schedule />} />
            <Route path="/login" element={<Login />} />
          </Routes>
        </main>
      </div>
    </Router>
  );
}

export default App;
