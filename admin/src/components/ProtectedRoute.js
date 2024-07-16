import { Navigate, Outlet } from "react-router";
import useAuth from "../hooks/useAuth";

const ProtectedRoute = () => {
    let { isAuthenticated } = useAuth();
    console.log(isAuthenticated);

    return (
        isAuthenticated
            ? <Outlet />
            : <Navigate to="/login" />
    );

}

export default ProtectedRoute;
