import {useState, useContext, useEffect} from 'react';
import { AuthContext } from './Account';



const UserChangePassword = () => {
    // const { getSession, logout } = useContext(AuthContext);
    const [currentPassword, setCurrentPassword] = useState('');
    const [newPassword, setNewPassword] = useState('');
    
    const { getSession } = useContext(AuthContext);

    const onSubmit = (e:any) => {
        e.preventDefault();
        
        getSession().then((sess) => {
            console.log(sess);
            console.log('Change Password');
            console.log(currentPassword, newPassword);
            
            getSession().then((session) => {
                session.user.changePassword(currentPassword, newPassword, (err, result) => {
                    if (err) {
                        console.error(err);
                    } else {
                        console.log(result);
                    }
                });
                
            })

           
        })
         
      }
    

    return (
        <div>
            <h2>Change Password</h2>
            <form onSubmit={onSubmit}>
                <label>Current Password</label>
        <input
          type="password"
          placeholder="current password"
          value={currentPassword}
          onChange={(e) => setCurrentPassword(e.target.value)}
        />
        <label>New Password</label>
        <input
          type="password"
          placeholder="new password"
          value={newPassword}
          onChange={(e) => setNewPassword(e.target.value)}
        />
        <button type="submit">Change Password</button>

      </form>
        </div>
    );
}

export default UserChangePassword;