import "../styles/navbar.css";
import logo from '../images/logo.png';
import dashboard from '../images/navIcons/dashboard.png';
import buildings from '../images/navIcons/buildings.png'
import events from '../images/navIcons/events.png'
import logout from '../images/navIcons/logout.png'
import { NavLink, useLocation } from 'react-router-dom';

const NavBar = () => {
    const location = useLocation();
    const getNavItemClass = (path) => {
        return location.pathname === path ? 'nav-item-row active' : 'nav-item-row';
    };
    return (
        <div className="nav-cont">
            <div className="nav-logo">
                <div className="nav-img">
                    <img src={logo} alt="" />
                </div>
                <h2>Ash<span>Pilot</span></h2>
            </div>

            <div className="nav-items">
                <NavLink to="/dashboard" className={getNavItemClass('/dashboard')}>
                    <img src={dashboard} alt="" />
                    <h3>Dashboard</h3>
                </NavLink>

                <NavLink to="/buildings" className={getNavItemClass('/buildings')}>
                    <img src={buildings} alt="" />
                    <h3>Buildings</h3>
                </NavLink>

                <NavLink to="/events" className={getNavItemClass('/events')}>
                    <img src={events} alt="" />
                    <h3>Events</h3>
                </NavLink>

                <NavLink to="/login" className="nav-item-row logout">
                    <img src={logout} alt="" />
                    <h3>Logout</h3>
                </NavLink>
            </div>



        </div>);
}

export default NavBar;