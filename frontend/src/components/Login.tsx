import {useState, useContext} from 'react';
import { AuthContext } from './Account';

const Login = () => {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');

  const { authenticate } = useContext(AuthContext);

  const onSubmit = (e:any) => {
    e.preventDefault();

    authenticate(email, password).then((data) => {
      console.log("Logged in", data);
    }).catch((err) => {
      console.error(err);
    })

  }


  return (
    <div>
      <h1>Login</h1>
      <form onSubmit={onSubmit}>
        <input
          type="email"
          placeholder="Email"
          value={email}
          onChange={(e) => setEmail(e.target.value)}
        />
        <input
          type="password"
          placeholder="Password"
          value={password}
          onChange={(e) => setPassword(e.target.value)}
        />
        <button type="submit">Login</button>

      </form>
    </div>
  );
};

export default Login;
