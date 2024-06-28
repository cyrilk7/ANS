import React, { useState } from 'react';
import 'bootstrap/dist/css/bootstrap.min.css';
import Pagination from 'react-bootstrap/Pagination';
import deleteIcon from '../../images/canvasIcons/deleteIcon.png';
import editIcon from '../../images/canvasIcons/editIcon.png';
import "../../styles/dashboard.css";

const UsersTable = (props) => {
    const { users, onDelete, onModalOpen } = props;
    const [currentPage, setCurrentPage] = useState(1);
    const usersPerPage = 3; // Adjust this as needed

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
            <div className="user-table">
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
