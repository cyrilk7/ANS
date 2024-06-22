
import './App.css';
import LoginPage from './components/loginPage';
import { BrowserRouter as Router, Route, Routes } from 'react-router-dom';

function App() {
  return (
    <Router>
    <div className="App">
      <Routes>
        <Route path="/" element={<LoginPage />} />

      </Routes>


    </div>
  </Router>

  );
}

export default App;
