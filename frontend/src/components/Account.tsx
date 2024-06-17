import { createContext, useState, useContext, ReactNode } from 'react';
import AppUserPool from './AppUserPool';
import { AuthenticationDetails, CognitoUser, CognitoUserAttribute } from 'amazon-cognito-identity-js';

// Define the shape of the authentication context
interface AuthContextType {
  user: string | null;
  authenticate: (email: string, password: string) => Promise<any>;
  getSession: () => Promise<any>;
  logout: () => void;
}

// Create the context with a default value
export const AuthContext = createContext<AuthContextType>({
  user: null,
  authenticate: () => new Promise(() => {}),
  getSession: () => new Promise(() => {}),
  logout: () => {},
});

// Create a provider component
export const AuthProvider = ({ children }: { children: ReactNode }) => {
  const [user, setUser] = useState<string | null>(null);

  const logout = () => {
    AppUserPool.getCurrentUser()?.signOut();
    setUser(null);
  }

  const getSession = async () => {
    return await new Promise((resolve, reject) => {
      const user = AppUserPool.getCurrentUser();
      if (user) {
        user.getSession(async (err, session) => {

          if (err) {
            reject(err);
          } else {
            const attributes = await new Promise((resolve, reject) => {
              user.getUserAttributes((err, attributes) => {
                if (err) {
                  reject(err);
                } else {
                    const results = {}
                    if (attributes) 
                      for (let i = 0; i < attributes.length; i++) 
                        results[attributes[i].getName()] = attributes[i].getValue();
                    resolve(results);
                }
              })
            })

           resolve({user, session, attributes}); 
          }
        });
      } else {
        reject("No user");
      }
    });
  }

  const authenticate = async (email: string, password:string) => {

    return await new Promise((resolve, reject) => {

      const user = new CognitoUser({
        Username: email,
        Pool: AppUserPool,
      });
  
      const authenticationDetails = new AuthenticationDetails({
        Username: email,
        Password: password,
      });
  
      user.authenticateUser(authenticationDetails, {
        onSuccess: (data) => {
          resolve(data);
        },
        onFailure: (err) => {
          reject(err);
        },
        newPasswordRequired: (data) => {
          reject(data);
        }
      });

    });

  };



  return (
    <AuthContext.Provider value = {{user, authenticate, logout, getSession }}>
      {children}
    </AuthContext.Provider>
  );
};


export default AuthProvider;


