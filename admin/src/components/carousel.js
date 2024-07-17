import Carousel from 'react-bootstrap/Carousel';
import ExampleCarouselImage from '../images/building_template.jpeg'
import "../styles/carousel.css";
// import ExampleCarouselImage from 'components/ExampleCarouselImage';

function BuildingCarousel({ buildingImages }) {
  return (
    <Carousel>
      {buildingImages && buildingImages.map((image, index) => (
        <Carousel.Item key={index}>
          <img src={image.image_path} alt={`Building ${index + 1}`} />
          <Carousel.Caption>
            <h3>{image.name}</h3>
            <p>{image.category.name}</p>
          </Carousel.Caption>
        </Carousel.Item>
      ))}
    </Carousel>
  );
}

export default BuildingCarousel;