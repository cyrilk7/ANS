import "../styles/loginPage.css";
import authController from '../controllers/authController';
import loginSvg from '../images/loginSvg.png';
import logo from '../images/logo.png';
import { useState } from "react";
import { useNavigate } from 'react-router-dom';
import { ToastContainer, toast } from 'react-toastify';
import 'react-toastify/dist/ReactToastify.css';
import useAuth from "../hooks/useAuth";

const LoginPage = () => {
    const [email, setEmail] = useState('');
    const [password, setPassword] = useState('');
    const [loading, setLoading] = useState(false);
    const [error, setError] = useState(null);
    const [success, setSuccess] = useState(null);
    const navigate = useNavigate();
    const { login, setIsAuthenticated } = useAuth();

    const handleLogin = async (event) => {
        event.preventDefault();
        setError(null);
        setSuccess(null);

        // Validate input fields
        if (!email || !password) {
            setError('Both email and password are required.');
            return;
        }

        setLoading(true);

        try {
            const response = await authController.login(email, password);
            toast.success(response.message);
            setSuccess(response.message);
            // setIsAuthenticated(true);
            // localStorage.setItem('token', response.token);
            login();
            // TO DO: TOAST IS NOT SHOWING BECAUSE WE ARE NAVIGATING TO THE DASHBOARD PAGE TOO QUICK
            navigate('/dashboard'); 

        } catch (error) {
            setError(error.message);
            setLoading(false);

        }
    }


    return (
        <div className="login-container">
            <div className="left">
                <h1> Revolutionizing Campus Navigation, One Step at a Time</h1>
                <h5> Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore </h5>
                <div className="loginSvg-container">
                    <img src={loginSvg} alt="" />
                </div>
            </div>

            <div className="right">
                <div className="img-cont">
                    <img src={logo} alt="" />
                </div>
                <h1> Ash<span>Pilot</span></h1>
                <h5> Welcome back! </h5>

                {error && <p style={{ color: 'red', fontWeight: 'bold', marginBottom: '0' }}>{error}</p>}
                {success && <p style={{ color: 'green', fontWeight: 'bold', marginBottom: '0' }}>{success}</p>}

                <form onSubmit={handleLogin}>
                    <input
                        type="text"
                        placeholder="Email"
                        value={email}
                        onChange={(e) => { setEmail(e.target.value) }}
                    />
                    <br />
                    <input
                        type="password"
                        placeholder="Password"
                        value={password}
                        onChange={(e) => { setPassword(e.target.value) }}
                    />

                    <div className="remember-row">
                        <div className="remember-cont">
                            <input type="checkbox" />
                            <h5> Show password </h5>
                        </div>

                        <h5> <a href=""> Forgot Password? </a></h5>
                    </div>

                    <button type="submit" disabled={loading} className="login-btn">
                        {loading ? 'Logging in...' : 'Log in'}
                    </button>

                </form>

            </div>
            <ToastContainer position="top-right"/>

        </div>);
}

export default LoginPage;