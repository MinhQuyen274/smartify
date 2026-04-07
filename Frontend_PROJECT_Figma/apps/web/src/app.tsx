import { Navigate, Outlet, Route, Routes, Link } from 'react-router-dom';
import { SignInPage } from './pages/sign-in-page';
import { DashboardPage } from './pages/dashboard-page';
import { DeviceDetailPage } from './pages/device-detail-page';
import { ReportsPage } from './pages/reports-page';
import { useAuth } from './context/auth-context';

function ProtectedLayout() {
  const { token } = useAuth();
  if (!token) {
    return <Navigate replace to="/sign-in" />;
  }

  return (
    <>
      <nav className="top-nav">
        <Link to="/devices">Devices</Link>
        <Link to="/reports">Reports</Link>
      </nav>
      <Outlet />
    </>
  );
}

export function App() {
  return (
    <Routes>
      <Route element={<SignInPage />} path="/sign-in" />
      <Route element={<ProtectedLayout />}>
        <Route element={<DashboardPage />} path="/devices" />
        <Route element={<DeviceDetailPage />} path="/devices/:deviceId" />
        <Route element={<ReportsPage />} path="/reports" />
      </Route>
      <Route element={<Navigate replace to="/devices" />} path="*" />
    </Routes>
  );
}
