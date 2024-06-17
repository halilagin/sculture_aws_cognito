import {useState} from 'react';
import AppUserPool from './AppUserPool';
import { CognitoUserAttribute } from 'amazon-cognito-identity-js';
// import AppUserPool from "./components/AppUserPool";
const SignUp = () => {
const [email, setEmail] = useState('');
const [password, setPassword] = useState('');


  const onSubmit = (e:any) => {
    e.preventDefault();
    console.log('Sign Up');
    console.log(email, password);
    const signupAtributes: CognitoUserAttribute[] = [
      new CognitoUserAttribute({
        Name: "email",
        Value: email,
    }),
    ]
    AppUserPool.signUp(email, password, signupAtributes, [], (err, data) => {
      if (err) console.error(err);
      console.log(data);
    });
  }


  return (
    <div>
      <h1>Sign Up</h1>
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
        <button type="submit">Sign Up</button>

      </form>
    </div>
  );
};

export default SignUp;
