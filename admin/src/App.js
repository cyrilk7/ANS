
import './App.css';
import LoginPage from './pages/loginPage';
import Dashboard from './pages/dashboard';
import { BrowserRouter as Router, Route, Routes } from 'react-router-dom';
import ProtectedRoute from './pages/components/ProtectedRoute';
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

            <Route path="/login" element={<LoginPage />} />

          </Routes>
        </Router>

      </AuthProvider>
      

    </div>

  );
}

export default App;
