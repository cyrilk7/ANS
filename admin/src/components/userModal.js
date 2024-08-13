import { useState, useEffect } from 'react';
import Button from 'react-bootstrap/Button';
import Modal from 'react-bootstrap/Modal';
import '../styles/userModal.css';
import { ToastContainer, toast } from 'react-toastify';
import dashboardController from '../controllers/dashboardController';

const UserModal = (props) => {
    const { user } = props;
    const [show, setShow] = useState(true);
    const [roles, setRoles] = useState(['User', 'Superuser']);
    const [selectedRole, setSelectedRole] = useState(user?.role || '');
    const [formData, setFormData] = useState({
        email: user?.email || '',
        name: user?.name || '',
        role: user?.role || '',
    });

    useEffect(() => {
        if (user) {
            setFormData({
                email: user.email || '',
                name: user.name || '',
                role: user.role || '',
            });
            setSelectedRole(user.role || '');
        }
    }, [user]);

    const handleChange = (e) => {
        const { name, value } = e.target;
        setFormData({
            ...formData,
            [name]: value,
        });
    };

    const handleRoleSelect = (role) => {
        setSelectedRole(role);
        setFormData({
            ...formData,
            role: role,
        });
    };

    const handleClose = () => {
        setShow(false);
        props.onClose();
    };

    const validateForm = () => {
        const { name, email, role } = formData;
        if (!email || !name || !role) {
            toast.warning('Please fill out all required fields.');
            return false;
        }
        return true;
    };

    const handleSubmit = async (e) => {
        e.preventDefault();
        if (validateForm()) {
            try {
                if (user) {
                    const response = await dashboardController.editUser(user.user_id, formData);
                    toast.success(response.message);
                } else {
                    const response = await dashboardController.createUser(formData);
                    toast.success(response.message);
                    props.onClose();
                    props.onUsersChanged();
                }

            } catch (error) {
                console.log('Error:', error);
                toast.error(error.message);
            }
        } else {
            console.log('Form validation failed.');
        }
    };

    return (
        <>
            <Modal show={show} onHide={handleClose}>
                <Modal.Header closeButton>
                    <Modal.Title style={{ fontWeight: "bold" }}>
                        {user ? 'Edit User' : 'Create a User'}
                    </Modal.Title>
                </Modal.Header>
                <Modal.Body>
                    <form onSubmit={handleSubmit}>
                        <h3 className='text-label'>
                            Select a role <span>*</span>
                        </h3>
                        <div className="roles">
                            {roles.map((role, index) => (
                                <div
                                    key={index}
                                    className={`role-card ${selectedRole === role ? 'selected' : ''}`}
                                    onClick={() => handleRoleSelect(role)}
                                >
                                    {role}
                                </div>
                            ))}
                        </div>
                        <h3 className='text-label'>
                            Name <span>*</span>
                        </h3>
                        <input
                            className='text-input'
                            type="text"
                            name='name'
                            value={formData.name}
                            onChange={handleChange}
                            placeholder='Jane Doe'
                        />
                        <h3 className='text-label'>
                            Email <span>*</span>
                        </h3>
                        <input
                            type="text"
                            className='text-input'
                            name='email'
                            value={formData.email}
                            onChange={handleChange}
                            placeholder='jane.doe@yahoo.com'
                        />
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

export default UserModal;
