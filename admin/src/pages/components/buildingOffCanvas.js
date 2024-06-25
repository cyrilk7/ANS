import { useState, useEffect } from 'react';
import Button from 'react-bootstrap/Button';
import Offcanvas from 'react-bootstrap/Offcanvas';
import buildingTemplate from '../../images/building_template.jpeg'
import '../../styles/offCanvas.css'
import academicIcon from '../../images/categoryIcons/academic-icon.png'
import buildingController from '../../controllers/buildingController';

const BuildingOffCanvas = (props) => {
  const [show, setShow] = useState(true);
  const [building, setBuilding] = useState(null);
  

//   console.log(props.buildingId);

  const handleClose = () => {
    setShow(false);
    props.onClose();
  }

  useEffect(() => {
    const loadBuilding = async () => {
        try {
            const building = await buildingController.getBuildingById(props.buildingId);
            console.log(building);
            setBuilding(building);
            // setLoading(false);
        } catch (error) {
            console.error('Error loading building:', error);
            // setError(error);
            // setLoading(false);
        }
    };

    loadBuilding();
}, [props.buildingId]);


  return (
    <>
      <Offcanvas show={show} onHide={handleClose}>
        <Offcanvas.Header closeButton>
          <Offcanvas.Title> Building Information </Offcanvas.Title>
        </Offcanvas.Header>
        <Offcanvas.Body style={{padding: "0"}}>
        {building ? (
          <>
            <div className="img-container">
              <img src={buildingTemplate} alt="" />
            </div>
            <div className="building-descr-body">
              <div className="category-canvas-row">
                <img src={academicIcon} alt="" />
                <p className='p-head'> {building.category.toUpperCase()} </p>
              </div>
              <h1> {building.name} </h1>
              <p className='p-head'> Description </p>
              <p> {building.description} </p>
              <p className='p-head'> History </p>
              <p> {building.history} </p>
            </div>
          </>
        ) : (
          <div>Loading building information...</div>
        )}
        </Offcanvas.Body>
      </Offcanvas>
    </>
  );
}

export default BuildingOffCanvas;