import { Router } from 'express';
import { authMiddleware } from '@/middleware/authMiddleware';

const router = Router();

// Apply authentication middleware to all internal routes
router.use(authMiddleware);

// --- INTEGRATION POINT FOR INTERNAL (AUTHENTICATED) FEATURES ---
// Example: router.use('/products', productRoutes);

export default router;
