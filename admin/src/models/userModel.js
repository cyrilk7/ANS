import api from '../services/api';

const login = async (email, password) => {
    try {
        const response = await api.post('/login', { email, password });
        return response.data;
    } catch (error) {
        if (error.response) {
            throw new Error(error.response.data.message);
        }
        throw new Error('An error occurred while logging in');
    }
};

export default {
    login,
};
