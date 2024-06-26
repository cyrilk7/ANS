import React, { useState, useEffect } from 'react';
import Button from 'react-bootstrap/Button';
import Modal from 'react-bootstrap/Modal';
import buildingController from '../../controllers/buildingController';
import '../../styles/building_modal.css'
import { ToastContainer, toast } from 'react-toastify';
import 'react-toastify/dist/ReactToastify.css';

const BuildingModal = (props) => {
    const [show, setShow] = useState(true);
    const [categories, setCategories] = useState([]);
    const [selectedCategory, setSelectedCategory] = useState(null);
    const [isEditMode, setIsEditMode] = useState(false);
    const [buildingId, setBuildingId] = useState(null);

    const [formData, setFormData] = useState({
        category_id: '',
        name: '',
        description: '',
        history: '',
        latitude: '',
        longitude: '',
        imagePath: '',
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
        const { category, name, description, latitude, longitude } = formData;
        if (!category || !name || !description || !latitude || !longitude) {
            toast.warning('Please fill out all required fields.');
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


    const handleSubmit = async (e) => {
        e.preventDefault();
        if (validateForm()) {
            try {
                if (isEditMode){
                    const response = await buildingController.editBuilding(buildingId, formData);
                    toast.success(response.message)
                }
                else{
                    const response = await buildingController.createBuilding(formData);
                    toast.success(response.message)
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
                    <Modal.Title style={{ fontWeight: 'bold' }}> Add a New Building </Modal.Title>
                </Modal.Header>
                <Modal.Body>
                    <form onSubmit={handleSubmit}>
                        <h3> Select a category <span> * </span> </h3>
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

                        <h3> Building name <span> * </span> </h3>
                        <input type="text" name='name' value={formData.name} onChange={handleChange} className='text-input' placeholder='Patric Nutor Research Building' />

                        <h3> Description <span> * </span> </h3>
                        <textarea name="description" value={formData.description} onChange={handleChange} id="description" placeholder='Loren ipusm dolor color di to...' cols="30" rows="6"></textarea>

                        <h3> Historical information </h3>
                        <textarea name="history" value={formData.history} onChange={handleChange} id="description" placeholder='Loren ipusm dolor color di to...' cols="30" rows="6"></textarea>

                        <div className="latlng">
                            <div className="lat">
                                <h3>Latitude <span> * </span></h3>
                                <input type="number" name='latitude' value={formData.latitude} onChange={handleChange} className="doubleInput" step="0.01" placeholder="e.g., 6.27144" />
                            </div>

                            <div className="lat">
                                <h3>Longitude <span> * </span></h3>
                                <input type="number" name='longitude' value={formData.longitude} onChange={handleChange} className="doubleInput" step="0.01" placeholder="e.g., 6.27144" />
                            </div>
                        </div>

                        <h3> Building image </h3>
                        <input type="file" />
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
            <ToastContainer />
        </div>
    );
}

export default BuildingModal;