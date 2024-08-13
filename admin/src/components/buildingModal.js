import React, { useState, useEffect } from 'react';
import Button from 'react-bootstrap/Button';
import Modal from 'react-bootstrap/Modal';
import buildingController from '../controllers/buildingController';
import '../styles/building_modal.css'
import { toast } from 'react-toastify';
import 'react-toastify/dist/ReactToastify.css';

const BuildingModal = (props) => {
    const [show, setShow] = useState(true);
    const [categories, setCategories] = useState([]);
    const [selectedCategory, setSelectedCategory] = useState(null);
    const [isEditMode, setIsEditMode] = useState(false);
    const [buildingId, setBuildingId] = useState(null);
    const [file, setFile] = useState(null);

    const [formData, setFormData] = useState({
        category_id: '',
        name: '',
        description: '',
        history: '',
        latitude: '',
        longitude: '',
        // imagePath: '',
    });

    const handleChange = (e) => {
        const { name, value } = e.target;
        setFormData({
            ...formData,
            [name]: value,
        });
    };

    const handleCategorySelect = (category) => {
        setSelectedCategory(category.category_id);
        setFormData({
            ...formData,
            category_id: category.category_id,
        });
    };

    const validateForm = () => {
        const { category_id, name, description, latitude, longitude } = formData;
        if (!category_id || !name || !description || !latitude || !longitude) {
            toast.warning('Please fill out all required fields.');
            return false;
        }

        if (!file) {
            toast.warning('Please attach a file.');
            return false;
        }
        return true;
    };


    useEffect(() => {
        const fetchCategories = async () => {
            try {
                const data = await buildingController.fetchCategories();
                setCategories(data);
            } catch (error) {
                // TO DO: Handle the error appropriately in the UI
                console.error('Error fetching categories:', error);
            }
        };

        fetchCategories();
    }, []);


    const handleClose = () => {
        setShow(false);
        props.onClose();
    };

    const handleFileChange = (e) => {
        setFile(e.target.files[0]);
    };


    const handleSubmit = async (e) => {
        e.preventDefault();
        if (validateForm()) {
            try {
                const data = new FormData();
                for (const key in formData) {
                    data.append(key, formData[key]);
                }
                if (file) {
                    data.append('file', file);
                }

                if (isEditMode) {
                    const response = await buildingController.editBuilding(buildingId, data);
                    toast.success(response.message);
                    props.onClose();
                    props.onBuildingChanged();
                }

                else {
                    // console.log(formDataWithFile);
                    console.log(data);
                    const response = await buildingController.createBuilding(data);
                    toast.success(response.message);
                    props.onClose();
                    props.onBuildingsChanged();
                                    // Define URLs you want to open
                    
                    const url1 = `https://www.openstreetmap.org/edit#map=18/5.75877/-0.22053`
                    const url2 = `https://app.mappedin.com/editor/`;

                    window.open(url1, '_blank');
                    window.open(url2, '_blank');


                }
            }
            catch (error) {
                toast.error(error.message);

            }
        }
    };

    useEffect(() => {
        if (props.buildingData) {
            const { building_id, category, name, description, history, latitude, longitude, imagePath } = props.buildingData;
            setFormData({
                category: category.category_id,
                name,
                description,
                history,
                latitude,
                longitude,
                imagePath,
            });
            setSelectedCategory(category.category_id);
            setBuildingId(building_id);
            setIsEditMode(true);
        }
        else {
            setIsEditMode(false);
        }
    }, [props.buildingData]);


    return (
        <div>
            <Modal size='lg' show={show} onHide={handleClose}>
                <Modal.Header closeButton>
                    <Modal.Title style={{ fontWeight: 'bold' }}> {isEditMode ? 'Edit Building' : "Add A New Building"} </Modal.Title>
                </Modal.Header>
                <Modal.Body>
                    <form onSubmit={handleSubmit}>
                        <h3 className='input-label'> Select a category <span> * </span> </h3>
                        <div className="categories">
                            {categories.map(category => (
                                <div
                                    key={category.category_id}
                                    className={`category-card ${selectedCategory === category.category_id ? 'selected' : ''}`}
                                    onClick={() => handleCategorySelect(category)}
                                >
                                    {category.name}
                                </div>
                            ))}
                        </div>

                        <h3 className='input-label'> Building name <span> * </span> </h3>
                        <input type="text" name='name' value={formData.name} onChange={handleChange} className='text-input' placeholder='Patric Nutor Research Building' />

                        <h3 className='input-label'> Description <span> * </span> </h3>
                        <textarea name="description" value={formData.description} onChange={handleChange} id="description" placeholder='Loren ipusm dolor color di to...' cols="30" rows="6"></textarea>

                        <h3 className='input-label'> Historical information </h3>
                        <textarea name="history" value={formData.history} onChange={handleChange} id="description" placeholder='Loren ipusm dolor color di to...' cols="30" rows="6"></textarea>

                        <div className="latlng">
                            <div className="lat">
                                <h3 className='input-label'>Latitude <span> * </span></h3>
                                <input type="number" name='latitude' value={formData.latitude} onChange={handleChange} className="doubleInput" step="0.01" placeholder="e.g., 6.27144" />
                            </div>

                            <div className="lat">
                                <h3 className='input-label'>Longitude <span> * </span></h3>
                                <input type="number" name='longitude' value={formData.longitude} onChange={handleChange} className="doubleInput" step="0.01" placeholder="e.g., 6.27144" />
                            </div>
                        </div>

                        <h3 className='input-label'> Building image </h3>
                        <input type="file" onChange={handleFileChange} />
                    </form>
                </Modal.Body>
                <Modal.Footer>
                    <Button variant="secondary" onClick={handleClose} style={{ fontWeight: "bold" }}>
                        Close
                    </Button>
                    <Button variant="primary" style={{ backgroundColor: "#AA3C3F", border: "none", fontWeight: "bold" }} onClick={handleSubmit}>
                        Save Changes
                    </Button>
                </Modal.Footer>
            </Modal>
        </div>
    );
}

export default BuildingModal;