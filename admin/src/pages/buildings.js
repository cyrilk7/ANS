import "bootstrap/dist/css/bootstrap.min.css"
import { useState, useEffect } from 'react';
import "../styles/buildings.css";
import NavBar from "./components/navbar";
import BuildingModal from "./components/buildingModal";
import { ToastContainer, toast } from 'react-toastify';
import 'react-toastify/dist/ReactToastify.css';
import BuildingOffCanvas from "./components/buildingOffCanvas";
import buildingController from "../controllers/buildingController";




const Buildings = () => {
    const [showModal, setShowModal] = useState(false);
    const [showCanvas, setShowCanvas] = useState(false);
    const [buildings, setBuildings] = useState([]);
    const [loading, setLoading] = useState(true);
    const [isError, setError] = useState(null);
    const [selectedBuildingId, setSelectedBuildingId] = useState(null);

    useEffect(() => {
        const loadBuildings = async () => {
            try {
                const buildingsData = await buildingController.fetchBuildings();
                console.log(buildingsData);
                setBuildings(buildingsData);
                setLoading(false);
            } catch (error) {
                console.error('Error loading buildings:', error);
                setError(error);
                setLoading(false);
            }
        };

        loadBuildings();
    }, []);

    
    const handleModalOpen = () => {
        setShowModal(true);
    };
    
    const handleModalClose = () => {
        setShowModal(false);
    };
    
    // const handleCanvasOpen = () => {
        //     setShowCanvas(true);
        // }
        
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
                        <h1> Your <span>Buildings </span></h1>
                        <div className="build-search-box">
                            <button onClick={handleModalOpen}> New </button>
                            <input type="text" placeholder="Search for building..." />
                        </div>
                    </div>
                    {loading && <div> Loading... </div>}
                    {isError && <div> Error </div>}
                    {buildings && (
                        <div>
                            {buildings.map((building, index) => (
                                <h2 key={building.building_id} onClick={() => handleBuildingClick(building.building_id)}> {building.name} </h2>
                            ))}
                        </div>
                    )}
                </div>


                {showModal && (
                    <BuildingModal
                        onClose={handleModalClose}
                    />
                )}

                {showCanvas && (
                    <BuildingOffCanvas
                        buildingId={selectedBuildingId}
                        onClose={handleCanvasClose}
                    />
                )}
                <ToastContainer />
            </div>
        </>
    );
}

export default Buildings;