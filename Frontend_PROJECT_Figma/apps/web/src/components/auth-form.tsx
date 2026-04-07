import { FormEvent, useState } from 'react';

interface AuthFormProps {
  mode: 'sign-in' | 'sign-up';
  onSubmit: (email: string, password: string) => Promise<void>;
}

export function AuthForm({ mode, onSubmit }: AuthFormProps) {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  async function handleSubmit(event: FormEvent) {
    event.preventDefault();
    setLoading(true);
    setError(null);
    try {
      await onSubmit(email, password);
    } catch (submitError) {
      setError(submitError instanceof Error ? submitError.message : 'Auth failed');
    } finally {
      setLoading(false);
    }
  }

  return (
    <form className="card auth-card" onSubmit={handleSubmit}>
      <h1>{mode === 'sign-in' ? 'Sign In' : 'Sign Up'}</h1>
      <label>
        Email
        <input value={email} onChange={(event) => setEmail(event.target.value)} type="email" />
      </label>
      <label>
        Password
        <input
          value={password}
          onChange={(event) => setPassword(event.target.value)}
          type="password"
        />
      </label>
      {error ? <p className="error">{error}</p> : null}
      <button disabled={loading} type="submit">
        {loading ? 'Please wait...' : mode === 'sign-in' ? 'Continue' : 'Create account'}
      </button>
    </form>
  );
}
