import Building from "../models/buildingModel";
import api from "../services/api";
import apiImage from "../services/apiImage";


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
        const response = await apiImage.post('/buildings', buildingData);
        return response.data;
    }
    catch (error) {
        throw new Error(error.response.data.error);
    }
}

const fetchBuildings = async () => {
    try {
        const response = await api.get('/buildings');
        const data = response.data;
        return data.map(buildingData => new Building(buildingData));

    }
    catch (error) {
        console.log(error);
        throw error;
    }
}

const fetchRandomBuildings = async () => {
    try {
        const response = await api.get('/random-buildings');
        const data = response.data;
        return data.map(buildingData => new Building(buildingData));

    }
    catch (error) {
        console.log(error);
        throw error;
    }
}

const getBuildingById = async (building_id) => {
    try {
        const response = await api.get(`/buildings/${building_id}`);
        const data = response.data;
        console.log(data);
        const building = new Building(data);
        return building;
    }
    catch (error) {
        throw error;
    }
}

const editBuilding = async (building_id, buildingData) => {
    try {
        const response = await api.put(`/buildings/${building_id}`, buildingData);
        return response.data;
    }
    catch (error) {
        throw error;
    }
}

const deleteBuilding = async (building_id) => {
    try {
        const response = await api.delete(`/buildings/${building_id}`);
        return response.data;
    }
    catch (error) {
        throw error;
    }
}

export default {
    fetchCategories, createBuilding, fetchBuildings, getBuildingById, editBuilding, deleteBuilding, fetchRandomBuildings
};
