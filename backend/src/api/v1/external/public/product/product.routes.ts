import { Router } from 'express';
import * as controller from './controller';

const router = Router();

/**
 * @api {get} /api/v1/external/public/product/filter-options Get Product Filter Options
 * @apiName GetProductFilterOptions
 * @apiGroup Product
 * @apiVersion 1.0.0
 */
router.get('/filter-options', controller.getFilterOptionsHandler);

/**
 * @api {get} /api/v1/external/public/product List Products
 * @apiName ListProducts
 * @apiGroup Product
 * @apiVersion 1.0.0
 */
router.get('/', controller.listHandler);

/**
 * @api {get} /api/v1/external/public/product/:id Get Product Details
 * @apiName GetProductDetails
 * @apiGroup Product
 * @apiVersion 1.0.0
 */
router.get('/:id', controller.getHandler);

/**
 * @api {get} /api/v1/external/public/product/:id/related Get Related Products
 * @apiName GetRelatedProducts
 * @apiGroup Product
 * @apiVersion 1.0.0
 */
router.get('/:id/related', controller.getRelatedHandler);

export default router;
