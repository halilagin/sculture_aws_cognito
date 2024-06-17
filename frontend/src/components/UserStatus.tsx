import {useState, useContext, useEffect} from 'react';

import { AuthContext } from './Account';



const UserStatus = () => {
    const [status, setStatus] = useState(false);
    const { getSession, logout } = useContext(AuthContext);


    useEffect(() => {
        getSession().then((session) => {
            console.log(session);
            setStatus(true);
        }).catch((err) => {
            console.error(err);
            setStatus(false);
        });
    }, []);

    return (
        <div>
            {status ? <button onClick={logout}> Logout </button> : "Logged Out"}
        </div>
    );
}

export default UserStatus;