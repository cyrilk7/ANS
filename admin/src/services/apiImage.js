import axios from 'axios';

const apiImage = axios.create({
    baseURL: 'https://europe-west2-capstone-431814.cloudfunctions.net/function-1', // Replace with your API base URL
    headers: {
        "Content-type": "multipart/form-data",
    },
});

export default apiImage;