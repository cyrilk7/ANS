import { useState, useEffect } from 'react';
import Button from 'react-bootstrap/Button';
import Modal from 'react-bootstrap/Modal';
import { ToastContainer, toast } from 'react-toastify';
import buildingController from '../controllers/buildingController';
import eventController from '../controllers/eventController';
import DatePicker from 'react-datepicker';
import { format } from 'date-fns';
import 'react-datepicker/dist/react-datepicker.css';
import '../styles/event_modal.css'

const EventModal = (props) => {
    const { event } = props;
    const [show, setShow] = useState(true);
    const [buildings, setBuildings] = useState([]);
    const [rooms, setRooms] = useState([]);
    const [selectedBuilding, setSelectedBuilding] = useState(null);
    const [formData, setFormData] = useState({
        name: '',
        room_id: '',
        building_id: '',
        organizer: '',
        event_date: '',
        event_time: '',
        duration: '',
        registrar: 55,
    });

    useEffect(() => {
        console.log(props.event)
        if (props.event) {
            const { name, room_id, building_id, organizer, event_date, event_time, duration } = props.event;
            setFormData({
                name,
                room_id,
                building_id,
                organizer,
                event_date, 
                event_time,
                duration
            });

        } 
        else {
            // setIsEditMode(false);
        }
    }, [props.event]);



    useEffect(() => {
        const loadBuildings = async () => {
            try {
                const buildingsData = await buildingController.fetchBuildings();
                setBuildings(buildingsData);
            } catch (error) {
                console.error('Error fetching buildings:', error);
            }
        };
        loadBuildings();
    }, []);

    const handleChange = (e) => {
        const { name, value } = e.target;
        setFormData({
            ...formData,
            [name]: value,
        });
    };

    const handleRoomChange = (e) => {
        const selectedRoomId = e.target.value;
        setFormData({
            ...formData,
            room_id: selectedRoomId,
        });
    };

    const handleBuildingChange = (e) => {
        const selectedBuildingId = e.target.value;
        const selectedBuilding = buildings.find(building => building.building_id.toString() === selectedBuildingId);
        setSelectedBuilding(selectedBuilding);
        setRooms(selectedBuilding?.rooms || []);
        setFormData({
            ...formData,
            building_id: selectedBuildingId,
            room_id: '', // Reset room_id when building changes
        });
    };


    const handleClose = () => {
        setShow(false);
        props.onClose();
    };

    const validateForm = () => {
        const { name, room_id, building_id, organizer, event_date, event_time, duration } = formData;
    
        if (!name) {
            toast.warning('Please enter the event name.');
            return false;
        }
    
        if (!building_id) {
            toast.warning('Please select a building.');
            return false;
        }
    
        if (!room_id) {
            toast.warning('Please select a room.');
            return false;
        }
    
        if (!organizer) {
            toast.warning('Please enter the organizer name.');
            return false;
        }
    
        if (!event_date) {
            toast.warning('Please select the event date.');
            return false;
        }
    
        if (!event_time) {
            toast.warning('Please select the event time.');
            return false;
        }
    
        if (!duration) {
            toast.warning('Please enter the event duration.');
            return false;
        }
    
        return true;
    };
    

    const handleSubmit = async (e) => {
        e.preventDefault();
        if (validateForm()) {
            try {
                const formattedData = {
                    ...formData,
                    event_date: format(formData.event_date, 'yyyy-MM-dd'),
                };
                console.log(formattedData);
                const response = await eventController.createEvent(formattedData);
                toast.success('Event created successfully');
                props.onClose();
                props.onEventsChanged();
            } catch (error) {
                console.log('Error:', error);
                toast.error(error.message);
            }
        }
    };

    const handleDateChange = (date) => {
        setFormData({
            ...formData,
            event_date: date,
        });
    };



    return (
        <>
            <Modal size='lg' show={show} onHide={handleClose}>
                <Modal.Header closeButton>
                    <Modal.Title style={{ fontWeight: "bold" }}>
                        {event ? 'Edit Event' : 'Create an Event'}
                    </Modal.Title>
                </Modal.Header>
                <Modal.Body>
                    <form onSubmit={handleSubmit}>
                        <h3 className='text-label'>
                            Event Name <span>*</span>
                        </h3>
                        <input
                            className='text-input'
                            type="text"
                            name='name'
                            value={formData.name}
                            onChange={handleChange}
                            placeholder='Example event'
                        />
                        <h3 className='text-label'>
                            Building <span>*</span>
                        </h3>
                        <select className='text-input' name='building' value={formData.building_id} onChange={handleBuildingChange}>
                            <option value="">Select a building</option>
                            {buildings.map(building => (
                                <option key={building.building_id} value={building.building_id}>
                                    {building.name}
                                </option>
                            ))}
                        </select>
                        {selectedBuilding && (
                            <>
                                <h3 className='text-label'>
                                    Room <span>(optional)</span>
                                </h3>
                                <select className='text-input' name='room_id' value={formData.room_id} onChange={handleRoomChange}>
                                    <option value="">Select a room</option>
                                    {rooms.map(room => (
                                        <option key={room.room_id} value={room.room_id}>
                                            {console.log(room)}
                                            {room.room_number}
                                        </option>
                                    ))}
                                </select>
                            </>
                        )}
                        <h3 className='text-label'>
                            Organizer <span>*</span>
                        </h3>
                        <input
                            className='text-input'
                            type="text"
                            name='organizer'
                            value={formData.organizer}
                            onChange={handleChange}
                            placeholder='Example event'
                        />

                        <div 
                        style={
                            {
                                display: "flex",
                                alignItems: "center",
                                gap: "1rem"
                        }}
                        >
                            <div>
                                <h3 className='text-label'>
                                    Event Date <span>*</span>
                                </h3>
                                <DatePicker
                                    selected={formData.event_date}
                                    onChange={handleDateChange}
                                    dateFormat="yyyy-MM-dd"
                                    placeholderText="yyyy-mm-dd"
                                    className='text-input custom-datepicker'
                                />

                            </div>

                            <div>
                                <h3 className='text-label'>
                                    Event Time <span>*</span>
                                </h3>

                                <input
                                    className='text-input'
                                    type="time"
                                    name='event_time'
                                    value={formData.event_time}
                                    onChange={handleChange}
                                />
                            </div>


                            <div>
                                <h3 className='text-label'>
                                    Duration (hour) <span>*</span>
                                </h3>

                                <input
                                    className='text-input'
                                    type="number"
                                    name='duration'
                                    value={formData.duration}
                                    placeholder='1'
                                    onChange={handleChange}
                                />
                            </div>
                        </div>
                    </form>
                </Modal.Body>
                <Modal.Footer>
                    <Button variant="secondary" onClick={handleClose}>
                        Close
                    </Button>
                    <Button
                        variant="primary"
                        style={{ backgroundColor: "#AA3C3F", border: "none", fontWeight: "bold" }}
                        onClick={handleSubmit}
                    >
                        Save Changes
                    </Button>
                </Modal.Footer>
            </Modal>
            <ToastContainer />
        </>
    );
};

export default EventModal;
