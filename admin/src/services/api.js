import axios from 'axios';

const api = axios.create({
    baseURL: 'http://127.0.0.1:5000', // Replace with your API base URL
    headers: {
        // 'Content-Type': 'application/json',
        "Content-type": "multipart/form-data",
    },
});

export default api;
