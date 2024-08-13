import axios from 'axios';

const api = axios.create({
    baseURL: 'https://europe-west2-capstone-431814.cloudfunctions.net/function-1', // Replace with your API base URL
    headers: {
        'Content-Type': 'application/json',
        // "Content-type": "multipart/form-data",
    },
});


export default api;
