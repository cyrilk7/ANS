import Room from "./roomModel";

class Building {
    constructor({ building_id, category, categoryImage, description, history, image_path, latitude, longitude, name, rooms }) {
        this.building_id = building_id;
        this.category = category;
        this.categoryImage = categoryImage;
        this.description = description;
        this.history = history;
        this.image_path = image_path;
        this.latitude = latitude;
        this.longitude = longitude;
        this.name = name;
        this.rooms = rooms.map(room => new Room(room));
    }

    
}

export default Building;
