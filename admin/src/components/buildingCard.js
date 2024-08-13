import Button from 'react-bootstrap/Button';
import Card from 'react-bootstrap/Card';
import buildingTemplate from '../images/building_template.jpeg'

const BuildingCard = (props) => {
    const { building } = props;

    const handleBuildingClick = () => {
        console.log(building.image_path)
        props.onClick(building.building_id);
    };

    

  return (
    
    <Card style={{ width: '15rem' }}>
      <Card.Img variant="top" src={building.image_path} />
      <Card.Body style={{textAlign:"left"}}>
        <Card.Title style={{fontWeight: "bold"}}> {building.name} </Card.Title>
        <Card.Text style={{fontSize: "0.8rem", fontWeight: "900", color: "gray"}}>
          {building.category.name.toUpperCase()}
        </Card.Text>
        <Button variant="primary" style={{backgroundColor: "#AA3C3F", border: "none", fontWeight: "bold", fontSize: "0.9rem"}} onClick={handleBuildingClick}> More info </Button>
      </Card.Body>
    </Card>
  );
}

export default BuildingCard;