import NavBar from "../components/navbar";
import "../styles/events.css";
import { useState, useEffect } from "react";
import eventController from "../controllers/eventController";
import EventModal from "../components/eventModal";
import CircularProgress from '@mui/material/CircularProgress';

const Events = () => {
    const [events, setEvents] = useState([]);
    const [loading, setLoading] = useState(true);
    const [isError, setError] = useState(null);
    const [showModal, setShowModal] = useState(false);
    const [selectedEvent, setSelectedEvent] = useState(null);


    const loadEvents = async () => {
        try {
            setLoading(true);
            const eventsData = await eventController.fetchEvents();
            setEvents(eventsData);
            setLoading(false);
        } catch (error) {
            console.error('Error loading buildings:', error);
            setError(error);
            setLoading(false);
        }
    };

    useEffect(() => {

        loadEvents();
    }, []);

    const handleModalOpen = (user = null) => {
        setSelectedEvent(user);
        setShowModal(true);
    };

    const handleModalClose = () => {
        setShowModal(false);
        setSelectedEvent(null);
    };

    const handleEventClick = (event) => {
        setSelectedEvent(event);
        setShowModal(true);
    };

    return (
        <div className="events-cont">
            <div className="events-left">
                <NavBar />
            </div>
            <div className="events-right">
                <div className="event-title-row">
                    <h1> Your <span> Events </span> </h1>
                    <hr style={{ marginBottom: "0" }} />
                </div>


                {loading && <div> <CircularProgress /> </div>}
                {isError && <div> Error </div>}

                <div className="events-right-body">
                    <div style={{display:"flex", justifyContent: "space-between", marginBottom: "1rem"}}>
                        <h1> Upcoming Events </h1>
                        <button onClick={handleModalOpen} style={{backgroundColor: "#AA3C3F", borderRadius: "7px", fontWeight:"bold", color: "white", border: "none", }}> New Event </button>

                    </div>

                    {events && (
                        <div className="event-table-box">
                            <table>
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Registrar</th>
                                        <th>Name/Title</th>
                                        <th>Room/Space</th>
                                        <th>Organizer</th>
                                        <th>Event Date</th>
                                        <th>Event Time</th>
                                        <th>Duration</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    {events.map((event, index) => (
                                        <tr key={index}>
                                            <td>{event.event_id}</td> {/* Assuming event_id is the unique identifier */}
                                            <td>
                                                <div className="registrar-row">
                                                    {/* <div className="profile-circle">J</div>  */}
                                                    {event.registrar}
                                                </div>
                                            </td>
                                            <td>{event.name}</td>
                                            <td>{event.space}</td> 
                                            <td>{event.organizer}</td>
                                            <td>{event.event_date}</td>
                                            <td>{event.event_time}</td>
                                            <td>{event.duration} hour(s)</td>
                                            <td>
                                                <div onClick={() => handleEventClick(event)} style={{ color: 'gray', fontWeight: 'bold' }}>...</div> {/* Example action */}
                                            </td>
                                        </tr>
                                    ))}
                                </tbody>
                            </table>
                        </div>
                    )}

                </div>

            </div>

            {showModal && (
                <EventModal
                    onClose={handleModalClose}
                    event={selectedEvent}
                    onEventsChanged={loadEvents}
                />
            )}

        </div>
    );
}

export default Events;