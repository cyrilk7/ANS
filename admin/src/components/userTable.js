import React, { useState, useEffect, useRef } from 'react';
import 'bootstrap/dist/css/bootstrap.min.css';
import Pagination from 'react-bootstrap/Pagination';
import deleteIcon from '../images/canvasIcons/deleteIcon.png';
import editIcon from '../images/canvasIcons/editIcon.png';
import "../styles/dashboard.css";

const UsersTable = (props) => {
    const { users, onDelete, onModalOpen } = props;
    const [currentPage, setCurrentPage] = useState(1);
    const [usersPerPage, setUsersPerPage] = useState(3); // Initial users per page

    const tableContainerRef = useRef(null);

    useEffect(() => {
        // Function to calculate users per page based on container height
        const calculateUsersPerPage = () => {
            if (tableContainerRef.current) {
                const containerHeight = tableContainerRef.current.offsetHeight;
                const rowHeight = 60; // Assuming each row has a height of 40px (adjust as needed)
                const calculatedUsersPerPage = Math.floor(containerHeight / rowHeight);
                setUsersPerPage(calculatedUsersPerPage);
            }
        };

        calculateUsersPerPage();

        // Recalculate on window resize (optional)
        const handleResize = () => {
            calculateUsersPerPage();
        };

        window.addEventListener('resize', handleResize);

        return () => {
            window.removeEventListener('resize', handleResize);
        };
    }, []);

    // Calculate the index of the first and last user to display on the current page
    const indexOfLastUser = currentPage * usersPerPage;
    const indexOfFirstUser = indexOfLastUser - usersPerPage;
    const currentUsers = users.slice(indexOfFirstUser, indexOfLastUser);

    // Function to change the page
    const handlePageChange = (pageNumber) => {
        setCurrentPage(pageNumber);
    };

    const handleDelete = (userId) => {
        onDelete(userId);
        console.log('Deleting user with ID:', userId);
    };

    // Example function to determine the status class
    const getStatusClass = (status) => {
        return status === 'Active' ? 'status-active' : 'status-inactive';
    };

    // Example functions for modal and delete operations
    const handleModalOpen = (user) => {
        onModalOpen(user);
        console.log('Opening modal for user:', user);
    };

    // Create page numbers
    const pageNumbers = [];
    for (let i = 1; i <= Math.ceil(users.length / usersPerPage); i++) {
        pageNumbers.push(i);
    }

    return (
        <>
            <div className="user-table-row">
                <div style={{ display: "flex", gap: "1rem", alignItems: "center" }}>
                    <h5 style={{ margin: 0 }}> User Overview </h5>
                    <button onClick={() => handleModalOpen()}> Add new </button>
                </div>
                <Pagination style={{ margin: 0 }}>
                    {pageNumbers.map(number => (
                        <Pagination.Item key={number} active={number === currentPage} onClick={() => handlePageChange(number)}>
                            {number}
                        </Pagination.Item>
                    ))}
                </Pagination>
            </div>
            <div className="user-table" ref={tableContainerRef}>
                <table className="table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Name</th>
                            <th>Email</th>
                            <th>Status</th>
                            <th>Role</th>
                            <th>Operation</th>
                        </tr>
                    </thead>
                    <tbody>
                        {currentUsers.map(user => (
                            <tr key={user.user_id}>
                                <td>{user.user_id}</td>
                                <td>{user.name}</td>
                                <td>{user.email}</td>
                                <td>
                                    <div className={getStatusClass(user.status)}>
                                        {user.status}
                                    </div>
                                </td>
                                <td>{user.role}</td>
                                <td>
                                    <div className="operation-icons">
                                        <img src={editIcon} alt="" onClick={() => handleModalOpen(user)} />
                                        <img src={deleteIcon} alt="" onClick={() => handleDelete(user.user_id)} />
                                    </div>
                                </td>
                            </tr>
                        ))}
                    </tbody>
                </table>
            </div>
        </>
    );
};

export default UsersTable;
