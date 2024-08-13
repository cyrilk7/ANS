import Event from "../models/eventModel";
import api from "../services/api";

const fetchEvents = async () => {
    try {
        const response = await api.get('/events');
        const data = response.data;
        return data.map(eventData => new Event(eventData));

    }
    catch (error) {
        console.log(error);
        throw error;
    }
}

const createEvent = async (eventData) => {
    try {
        const response = await api.post('/events', eventData);
        return response.data;
    }
    catch (error) {
        throw new Error(error.response.data.error);
    }
}

export default {
    fetchEvents, createEvent
}