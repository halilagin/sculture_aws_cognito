import {useState, useContext, useEffect} from 'react';

import { AuthContext } from './Account';
import UserChangePassword from './UserChangePassword';



const UserSettings = () => {
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
            {status && 
            <div>
                <h1>Settings</h1>
                <p>Change your settings here</p>
                <UserChangePassword />
            </div>
            }
            
        </div>
    );
}

export default UserSettings;