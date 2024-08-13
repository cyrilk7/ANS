class Room {
    constructor({ room_id, building, capacity, room_number, type }) {
        this.room_id = room_id;
        this.building = building;
        this.capacity = capacity;
        this.room_number = room_number;
        this.type = type;
    }
}

export default Room;
