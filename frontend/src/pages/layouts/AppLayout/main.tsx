import { Outlet } from 'react-router-dom';

export const AppLayout = () => {
  return (
    <div className="min-h-screen flex flex-col">
      <header className="bg-pink-500 text-white p-4 shadow-md">
        <div className="container mx-auto">
          <h1 className="text-2xl font-bold">LoveCakes</h1>
        </div>
      </header>
      <main className="flex-grow container mx-auto p-4">
        <Outlet />
      </main>
      <footer className="bg-gray-200 p-4 text-center text-sm text-gray-600">
        <div className="container mx-auto">
          © {new Date().getFullYear()} LoveCakes. All rights reserved.
        </div>
      </footer>
    </div>
  );
};
