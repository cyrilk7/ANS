import "../../styles/navbar.css";
import logo from '../../images/logo.png';
import dashboard from '../../images/navIcons/dashboard.png';
import buildings from '../../images/navIcons/buildings.png'
import events from '../../images/navIcons/events.png'
import logout from '../../images/navIcons/logout.png'

const NavBar = () => {
    return ( 
    <div className="nav-cont">
        <div className="nav-logo">
            <div className="nav-img">
                <img src={logo} alt="" />
            </div>
            <h2>Ash<span>Pilot</span></h2>
        </div>

        <div className="nav-items">
            <div className="nav-item-row">
                <img src={dashboard} alt="" />
                <h3>Dashboard</h3>
            </div>
            <div className="nav-item-row">
                <img src={buildings} alt="" />
                <h3>Buildings</h3>
            </div>
            <div className="nav-item-row">
                <img src={events} alt="" />
                <h3>Events</h3>
            </div>
        </div>

        <div className="nav-item-row">
                <img src={logout} alt="" />
                <h3>Logout</h3>
            </div>

    </div> );
}
 
export default NavBar;