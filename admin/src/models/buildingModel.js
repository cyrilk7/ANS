import Room from "./roomModel";
import Category from "./categoryModel";

class Building {
    constructor({ building_id, category, category_id, categoryImage, description, history, image_path, latitude, longitude, name, rooms }) {
        this.building_id = building_id;
        this.category = new Category(category_id, category);
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
