import { Router } from 'express';
import * as productController from '@/api/v1/external/public/product/controller';

const router = Router();

/**
 * @route GET /api/v1/external/products
 * @description Get a list of products with filtering, sorting, and pagination.
 * @access Public
 */
router.get('/', productController.listHandler);

/**
 * @route GET /api/v1/external/products/:id
 * @description Get detailed information for a single product.
 * @access Public
 */
router.get('/:id', productController.getHandler);

export default router;
