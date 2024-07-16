
import './App.css';
import LoginPage from './pages/loginPage';
import Dashboard from './pages/dashboard';
import Events from './pages/events';
import Buildings from './pages/buildings';
import { BrowserRouter as Router, Route, Routes } from 'react-router-dom';
import ProtectedRoute from './components/ProtectedRoute';
import { AuthProvider } from './context/AuthContext';

function App() {
  return (
    <div className="App">
      <AuthProvider>
        <Router>
          <Routes>

            <Route element={<ProtectedRoute />}>
            </Route>
            <Route path="/dashboard" element={<Dashboard />} />
            <Route path="/events" element={<Events />} />
            <Route path="/buildings" element={<Buildings />} />

            <Route path="/" element={<LoginPage />} />

          </Routes>
        </Router>

      </AuthProvider>
      

    </div>

  );
}

export default App;
