import userModel from '../models/userModel';

const login = async (email, password) => {
    try {
        const response = await userModel.login(email, password);
        return response;
    } catch (error) {
        throw new Error(error.message);
    }
};

export default {
    login,
};
