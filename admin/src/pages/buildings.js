import "bootstrap/dist/css/bootstrap.min.css"
import { useState } from 'react';
import "../styles/buildings.css";
import NavBar from "./components/navbar";
import BuildingModal from "./components/buildingModal";
import { ToastContainer, toast } from 'react-toastify';
import 'react-toastify/dist/ReactToastify.css';




const Buildings = () => {
    const [showModal, setShowModal] = useState(false);

    const handleModalOpen = () => {
        setShowModal(true);
    };

    const handleModalClose = () => {
        setShowModal(false);
    };

    // const handleSubmit

    return (
        <>
            <div className="buildings-cont">
                <div className="build-left">
                    <NavBar />
                </div>
                <div className="build-right">
                    <div className="build-title-row">
                        <h1> Your <span>Buildings </span></h1>
                        <div className="build-search-box">
                            <button onClick={handleModalOpen}> New </button>
                            <input type="text" placeholder="Search for building..." />
                        </div>

                    </div>
                </div>

                {showModal && (
                    <BuildingModal
                        onClose={handleModalClose}
                    />
                )}
                <ToastContainer />
            </div>
        </>
    );
}

export default Buildings;