import NavBar from "./components/navbar";
import "../styles/dashboard.css";
import BuildingCarousel from "./components/carousel";
import editIcon from '../images/canvasIcons/editIcon.png';
import deleteIcon from '../images/canvasIcons/deleteIcon.png';
import buildingCardIcon from '../images/dashCardIcons/buildings.png';
import userCardIcon from '../images/dashCardIcons/users.png';
import eventCardIcon from '../images/dashCardIcons/events.png';
import { useEffect, useState } from "react";
import dashboardController from "../controllers/dashboardController";
import UserModal from "./components/userModal";
import { ToastContainer, toast } from 'react-toastify';

const Dashboard = () => {
    const [data, setData] = useState(null);
    const [isLoading, setIsLoading] = useState(true);
    const [showModal, setShowModal] = useState(false);
    const [selectedUser, setSelectedUser] = useState(null);


    useEffect(() => {
        const fetchData = async () => {
            try {
                const response = await dashboardController.getDashboardStatistics();
                // console.log(response);
                setData(response);
                setIsLoading(false);
            } catch (error) {
                console.log(error);
                setIsLoading(false); // Ensure loading state is updated even if there's an error
            }
        }
        fetchData();
    }, [])

    if (isLoading) {
        return <div>Loading...</div>; // You can replace this with a spinner or any other loading indicator
    }

    const getStatusClass = (status) => {
        return status === 'Active' ? 'status-active' : 'status-inactive';
    };

    const handleModalOpen = (user = null) => {
        setSelectedUser(user);
        setShowModal(true);
    };

    const handleModalClose = () => {
        setShowModal(false);
    };

    const handleDelete = async (user_id) => {
        try{
            const response = await dashboardController.deleteUser(user_id);
            toast.success(response.message);
            
        }
        catch(error){
            console.log(error);
        }
    }

    return (
        <div className="dashboard-cont">
            <div className="dash-left">
                <NavBar />
            </div>

            <div className="dash-right">
                <div className="dash-title-row">
                    <h1> Welcome back, <span> Cyril </span> </h1>
                    <hr style={{ marginBottom: "0" }} />
                </div>
                {!isLoading && (
                    <>
                        <div className="dash-right-top">
                            <div className="dash-top-left">
                                <div className="dash-card-row">
                                    <div className="dash-card">
                                        <div className="dash-card-left">
                                            <h6> Buildings </h6>
                                            <h3> {data.total_buildings} </h3>
                                            <p> Present Buildings </p>
                                        </div>
                                        <div className="dash-card-icon">
                                            <img src={buildingCardIcon} alt="" />
                                        </div>
                                    </div>

                                    <div className="dash-card">
                                        <div className="dash-card-left">
                                            <h6> Events </h6>
                                            <h3> {data.total_events}  </h3>
                                            <p> Upcoming Events </p>
                                        </div>
                                        <div className="dash-card-icon">
                                            <img src={eventCardIcon} alt="" />
                                        </div>
                                    </div>
                                    <div className="dash-card">
                                        <div className="dash-card-left">
                                            <h6> Users </h6>
                                            <h3> {data.total_users} </h3>
                                            <p> Active Users </p>
                                        </div>
                                        <div className="dash-card-icon">
                                            <img src={userCardIcon} alt="" />
                                        </div>
                                    </div>
                                </div>
                                <div className="carousel-container">
                                    <BuildingCarousel />
                                </div>
                            </div>
                            <div className="dash-top-right">
                                <div className="upcoming-event-card">
                                    <h5> Upcoming Events </h5>
                                    <hr />
                                </div>
                            </div>
                        </div>
                        <div className="dash-right-bottom">
                            <div className="user-table-row">
                                <h5> User Overview </h5>
                                <button onClick={handleModalOpen}> Add new </button>
                            </div>
                            <div className="user-table">
                                <table>
                                    <thead>
                                        <tr>
                                            <th> ID </th>
                                            <th> Name </th>
                                            <th> Email </th>
                                            <th> Status </th>
                                            <th> Role </th>
                                            <th> Operation </th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        {data.users.map(user => (
                                            <tr key={user.user_id}>
                                                <td> {user.user_id} </td>
                                                <td> {user.name} </td>
                                                <td> {user.email} </td>
                                                <td>
                                                    <div className={getStatusClass(user.status)}>
                                                        {user.status}
                                                    </div>
                                                </td>
                                                <td> {user.role} </td>
                                                <td>
                                                    <div className="operation-icons">
                                                        <img src={editIcon} alt="" onClick={() => handleModalOpen(user)} />
                                                        <img src={deleteIcon} alt="" onClick={() => handleDelete(user.user_id)}/>
                                                    </div>
                                                </td>
                                            </tr>
                                        ))}
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </>
                )}
            </div>
            <ToastContainer />

            {showModal && (
                <UserModal
                    onClose={handleModalClose}
                    user={selectedUser}
                />

            )}
        </div>
    );
}

export default Dashboard;
