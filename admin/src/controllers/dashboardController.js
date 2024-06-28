import api from "../services/api";

const getDashboardStatistics = async () => {
    try {
        const response = await api.get('/statistics');
        return response.data;

    }
    catch (error) {
        console.log(error);
        throw error;
    }
}

const createUser = async (userData) => {
    try{
        console.log(userData);
        const response = await api.post('/users', userData);
        return response.data;
    }
    catch(error){
        throw error;
    }
}

const editUser = async (user_id, userData) => {
    try {
        const response = await api.put(`/users/${user_id}`, userData);
        return response.data;
    }
    catch (error) {
        throw error;
    }
}


const deleteUser = async (user_id) => {
    try {
        const response = await api.delete(`/users/${user_id}`);
        return response.data;
    }
    catch (error) {
        throw error;
    }
}

export default{
    getDashboardStatistics, createUser, editUser, deleteUser
}