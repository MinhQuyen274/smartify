import {
  PropsWithChildren,
  createContext,
  useContext,
  useMemo,
  useState,
} from 'react';
import { apiClient } from '../api/client';
import { AuthResponse, AuthUser } from '../types';

interface AuthContextValue {
  token: string | null;
  user: AuthUser | null;
  signIn: (email: string, password: string) => Promise<void>;
  signUp: (email: string, password: string) => Promise<void>;
  signOut: () => void;
}

const authStorageKey = 'smartify-web-auth';
const AuthContext = createContext<AuthContextValue | null>(null);

function loadStoredAuth(): AuthResponse | null {
  const raw = window.localStorage.getItem(authStorageKey);
  return raw ? (JSON.parse(raw) as AuthResponse) : null;
}

export function AuthProvider({ children }: PropsWithChildren) {
  const stored = loadStoredAuth();
  const [token, setToken] = useState<string | null>(stored?.accessToken ?? null);
  const [user, setUser] = useState<AuthUser | null>(stored?.user ?? null);

  const saveAuth = (response: AuthResponse) => {
    setToken(response.accessToken);
    setUser(response.user);
    window.localStorage.setItem(authStorageKey, JSON.stringify(response));
  };

  const value = useMemo<AuthContextValue>(
    () => ({
      token,
      user,
      signIn: async (email, password) => saveAuth(await apiClient.signIn(email, password)),
      signUp: async (email, password) => saveAuth(await apiClient.signUp(email, password)),
      signOut: () => {
        setToken(null);
        setUser(null);
        window.localStorage.removeItem(authStorageKey);
      },
    }),
    [token, user],
  );

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>;
}

export function useAuth() {
  const context = useContext(AuthContext);
  if (!context) {
    throw new Error('useAuth must be used inside AuthProvider');
  }
  return context;
}
