import { Router } from 'express';
import productRoutes from '@/api/v1/external/public/product/product.routes';

const router = Router();

// --- INTEGRATION POINT FOR EXTERNAL (PUBLIC) FEATURES ---
router.use('/public/product', productRoutes);

export default router;
