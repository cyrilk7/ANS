class Event {
    constructor({ event_id, building_id, room_id, name, registrar, space, organizer, event_date, event_time, duration}) {
        this.event_id = event_id;
        this.name = name;
        this.registrar = registrar;
        this.building_id = building_id;
        this.room_id = room_id;
        this.space = space;
        this.organizer = organizer;
        this.event_date = event_date;
        this.event_time = event_time;
        this.duration = duration;
    }

    
}

export default Event;
