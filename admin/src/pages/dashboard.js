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
import UsersTable from "./components/userTable";

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


    const handleModalOpen = (user = null) => {
        setSelectedUser(user);
        setShowModal(true);
    };

    const handleModalClose = () => {
        setShowModal(false);
        setSelectedUser(null);
    };

    const handleDelete = async (user_id) => {
        try {
            const response = await dashboardController.deleteUser(user_id);
            toast.success(response.message);

        }
        catch (error) {
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
                            <UsersTable
                                users={data.users}
                                onDelete={handleDelete}
                                onModalOpen={handleModalOpen}
                            />
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
