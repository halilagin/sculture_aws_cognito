// import { useState } from 'react'
// import reactLogo from './assets/react.svg'
// import viteLogo from '/vite.svg'
import './App.css'
import AuthProvider from './components/Account'
import Login from './components/Login'
import SignUp from './components/SignUp'
import UserSettings from './components/UserSettings'
import UserStatus from './components/UserStatus'

function App() {
  //const [count, setCount] = useState(0)

  return (
    <>
      <div>
        <AuthProvider>
          <UserStatus />
          <SignUp /> 
          <Login /> 
          <UserSettings />
        </AuthProvider>
        
      </div>
    </>
  )
}

export default App
