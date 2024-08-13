import React, { createContext, useState, useEffect } from 'react';

const AuthContext = createContext({});

export const AuthProvider = ({ children }) => {
    const [isAuthenticated, setIsAuthenticated] = useState(false);

    useEffect(() => {
        const token = localStorage.getItem('token');
        if (token) {
            setIsAuthenticated(true);
        }
    }, []);

    const login = () => {
        setIsAuthenticated(true);
    };

    const logout = () => {
        setIsAuthenticated(false);
        localStorage.removeItem('token'); 
    };

    return (
        <AuthContext.Provider value={{ isAuthenticated, setIsAuthenticated, login, logout }}>
            {children}
        </AuthContext.Provider>
    );
};


export default AuthContext;

