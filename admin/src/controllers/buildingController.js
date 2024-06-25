import Building from "../models/buildingModel";
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
        throw new Error(error.response.data.error);
    }
}

const fetchBuildings = async () => {
    try{
        const response = await api.get('/buildings');
        const data = response.data;
        return data.map(buildingData => new Building(buildingData));

    }
    catch(error){
        console.log(error);
        throw error;
    }
}

const getBuildingById =  async (building_id) => {
    try{
        const response = await api.get(`/buildings/${building_id}`);
        const data = response.data;
        const building = new Building(data);
        return building;
    }
    catch(error){
        throw error;
    }
}

export default {
    fetchCategories, createBuilding, fetchBuildings, getBuildingById
};
