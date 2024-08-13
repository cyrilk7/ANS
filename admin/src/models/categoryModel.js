class Category {
    constructor(id, name) {
        this.category_id = id;
        this.name = name;
    }

    static fromApiResponse(responseData) {
        return new Category(responseData.category_id, responseData.name);
    }
}

export default Category;
