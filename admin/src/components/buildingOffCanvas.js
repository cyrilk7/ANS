import { useState, useEffect } from 'react';
import Button from 'react-bootstrap/Button';
import Offcanvas from 'react-bootstrap/Offcanvas';
import buildingTemplate from '../images/building_template.jpeg'
import '../styles/offCanvas.css'
import academicIcon from '../images/categoryIcons/academic-icon.png'
import buildingController from '../controllers/buildingController';
import BuildingModal from './buildingModal';
import editIcon from '../images/canvasIcons/editIcon.png';
import deleteIcon from '../images/canvasIcons/deleteIcon.png'
import { toast } from 'react-toastify';
import 'react-toastify/dist/ReactToastify.css';


const BuildingOffCanvas = (props) => {
    const [show, setShow] = useState(true);
    const [showModal, setShowModal] = useState(false);
    const [building, setBuilding] = useState(null);

    const handleClose = () => {
        setShow(false);
        props.onClose();
    }

    const handleModalOpen = () => {
        setShowModal(true);
    };

    const handleModalClose = () => {
        setShowModal(false);
    };
    
    const handleBuildingChange = () => {
        loadBuilding();
        props.onBuildingsChanged();
    };

    const handleDeleteBuilding = async () => {
        try {
            const response = await buildingController.deleteBuilding(props.buildingId);
            toast.success(response.message);
            props.onClose();
            props.onBuildingsChanged();
        }
        catch (error) {
            console.log(error);
        }
    }

    const loadBuilding = async () => {
        try {
            const building = await buildingController.getBuildingById(props.buildingId);
            console.log(building);
            // console.log(building);
            setBuilding(building);
            
            // setLoading(false);
        } catch (error) {
            console.error('Error loading building:', error);
            // setError(error);
            // setLoading(false);
        }
    };

    useEffect(() => {
        loadBuilding();
    }, [props.buildingId]);

    


    return (
        <>
            <Offcanvas show={show} onHide={handleClose}>
                <Offcanvas.Header closeButton>
                    <Offcanvas.Title> Building Information </Offcanvas.Title>
                </Offcanvas.Header>
                <Offcanvas.Body style={{ padding: "0" }}>
                    {building ? (
                        <>
                            <div className="img-container">
                                <img src={building.image_path} alt="" />
                            </div>
                            <div className="building-descr-body">
                                <div className="category-canvas-row">
                                    <img src={academicIcon} alt="" />
                                    <p className='p-head'> {building.category.name.toUpperCase()} </p>
                                </div>
                                <h1> {building.name} </h1>
                                <p className='p-head'> Description </p>
                                <p> {building.description} </p>
                                <p className='p-head'> History </p>
                                <p> {building.history} </p>

                                <button onClick={handleModalOpen}> <img src={editIcon} alt="" /> </button>
                                <button onClick={handleDeleteBuilding}> <img src={deleteIcon} alt="" /> </button>
                            </div>
                        </>
                    ) : (
                        <div>Loading building information...</div>
                    )}
                </Offcanvas.Body>
            </Offcanvas>

            {showModal && (
                <BuildingModal
                    onClose={handleModalClose}
                    buildingData={building}
                    onBuildingChanged={handleBuildingChange}
                />
            )}

            {/* <ToastContainer /> */}
        </>
    );
}

export default BuildingOffCanvas;