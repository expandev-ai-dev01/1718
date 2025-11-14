import { Link } from 'react-router-dom';

const NotFoundPage = () => {
  return (
    <div className="text-center py-10">
      <h1 className="text-4xl font-bold">404 - Not Found</h1>
      <p className="mt-4">The page you are looking for does not exist.</p>
      <Link
        to="/"
        className="mt-6 inline-block bg-pink-500 text-white px-4 py-2 rounded hover:bg-pink-600"
      >
        Go to Homepage
      </Link>
    </div>
  );
};

export default NotFoundPage;
