import "bootstrap/dist/css/bootstrap.min.css"
import { useState, useEffect } from 'react';
import "../styles/buildings.css";
import NavBar from "../components/navbar";
import BuildingModal from "../components/buildingModal";
import { ToastContainer, toast } from 'react-toastify';
import 'react-toastify/dist/ReactToastify.css';
import BuildingOffCanvas from "../components/buildingOffCanvas";
import buildingController from "../controllers/buildingController";
import moreIcon from '../images/moreIcon.png'
import BuildingCard from "../components/buildingCard";
import CircularProgress from '@mui/material/CircularProgress';




const Buildings = () => {
    const [showModal, setShowModal] = useState(false);
    const [showCanvas, setShowCanvas] = useState(false);
    const [buildings, setBuildings] = useState([]);
    const [loading, setLoading] = useState(true);
    const [isError, setError] = useState(null);
    const [selectedBuildingId, setSelectedBuildingId] = useState(null);

    const loadBuildings = async () => {
        try {
            const buildingsData = await buildingController.fetchBuildings();
            // console.log(buildingsData);
            setBuildings(buildingsData);
            setLoading(false);
        } catch (error) {
            console.error('Error loading buildings:', error);
            setError(error);
            setLoading(false);
        }
    };

    useEffect(() => {

        loadBuildings();
    }, []);


    const handleModalOpen = () => {
        setShowModal(true);
    };

    const handleModalClose = () => {
        setShowModal(false);
    };


    const handleBuildingClick = (buildingId) => {
        setShowCanvas(true);
        setSelectedBuildingId(buildingId);
    };

    const handleCanvasClose = () => {
        setShowCanvas(false);
        setSelectedBuildingId(null);
    };


    return (
        <>
            <div className="buildings-cont">
                <div className="build-left">
                    <NavBar />
                </div>
                <div className="build-right">
                    <div className="build-title-row">
                        <div className="build-title">
                            <h1> Your <span>Buildings </span></h1>
                            <div className="build-search-box">
                                <button onClick={handleModalOpen}> New </button>
                                <input type="text" placeholder="Search for building..." />
                            </div>
                        </div>
                        <hr />
                    </div>
                    {loading && <div> <CircularProgress /> </div>}
                    {isError && <div> Error </div>}

                    {/* <div className="building-comp-container"> */}
                    {buildings && (
                        <div className="building-body">
                            
                            {buildings.map((building, index) => (
                                <div>
                                    <BuildingCard building={building} onClick={handleBuildingClick} />
                                </div>
                            ))}
                        </div>
                    )}

                    {/* </div> */}


                </div>


                {showModal && (
                    <BuildingModal
                        onClose={handleModalClose}
                        onBuildingsChanged={loadBuildings}
                    />
                )}

                {showCanvas && (
                    <BuildingOffCanvas
                        buildingId={selectedBuildingId}
                        onClose={handleCanvasClose}
                        onBuildingsChanged={loadBuildings}
                    />
                )}
                <ToastContainer />
            </div>
        </>
    );
}

export default Buildings;