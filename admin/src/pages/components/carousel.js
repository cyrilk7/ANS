import Carousel from 'react-bootstrap/Carousel';
import ExampleCarouselImage from '../../images/building_template.jpeg'
import "../../styles/carousel.css";
// import ExampleCarouselImage from 'components/ExampleCarouselImage';

function BuildingCarousel() {
  return (
    <Carousel>
      <Carousel.Item>
        {/* <ExampleCarouselImage text="First slide" /> */}
        <img src={ExampleCarouselImage} alt="" />
        <Carousel.Caption>
          <h3>Radichel Hall</h3>
          <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. </p>
        </Carousel.Caption>
      </Carousel.Item>
      <Carousel.Item>
        {/* <ExampleCarouselImage text="Second slide" /> */}
        <img src={ExampleCarouselImage} alt="" />
        <Carousel.Caption>
          <h3>Second slide label</h3>
          <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit.</p>
        </Carousel.Caption>
      </Carousel.Item>
      <Carousel.Item>
        {/* <ExampleCarouselImage text="Third slide" /> */}
        <img src={ExampleCarouselImage} alt="" />
        <Carousel.Caption>
          <h3>Third slide label</h3>
          <p>
            Praesent commodo cursus magna, vel scelerisque nisl consectetur.
          </p>
        </Carousel.Caption>
      </Carousel.Item>
    </Carousel>
  );
}

export default BuildingCarousel;