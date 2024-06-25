import api from "../services/api";


const fetchCategories = async () => {
    try {
        const response = await api.get('/categories');
        return response.data;
    } catch (error) {
        console.error('Error fetching categories:', error);
        throw new Error(error.message);
    }
};

const createBuilding = async (buildingData) => {
    try {
        const response = await api.post('/buildings', buildingData);
        return response.data;
    }
    catch (error) {
        // console.log(error.response.data.error);
        throw new Error(error.response.data.error);
    }
}

export default {
    fetchCategories, createBuilding
};
