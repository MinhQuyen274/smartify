import { useState } from 'react';
import { Navigate } from 'react-router-dom';
import { AuthForm } from '../components/auth-form';
import { useAuth } from '../context/auth-context';

export function SignInPage() {
  const { token, signIn, signUp } = useAuth();
  const [mode, setMode] = useState<'sign-in' | 'sign-up'>('sign-in');

  if (token) {
    return <Navigate replace to="/devices" />;
  }

  return (
    <main className="page auth-page">
      <div className="auth-switch">
        <button onClick={() => setMode('sign-in')} type="button">
          Sign In
        </button>
        <button onClick={() => setMode('sign-up')} type="button">
          Sign Up
        </button>
      </div>
      <AuthForm mode={mode} onSubmit={mode === 'sign-in' ? signIn : signUp} />
    </main>
  );
}
