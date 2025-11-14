import { Request, Response, NextFunction } from 'express';
import { z } from 'zod';
import { successResponse } from '@/utils/responseHandler';
import {
  listProducts,
  getProductById,
  getRelatedProducts,
  getFilterOptions,
} from '@/services/product/productRules';
import { productListQuerySchema, productParamsSchema } from '@/services/product/productValidation';

/**
 * @summary
 * Handles the request to list products with filtering, sorting, and pagination.
 */
export async function listHandler(req: Request, res: Response, next: NextFunction): Promise<void> {
  try {
    const query = await productListQuerySchema.parseAsync(req.query);
    // Assuming a default idAccount for now. In a real app, this might come from a public tenant or be optional.
    const idAccount = 1;
    const result = await listProducts({ ...query, idAccount });
    res.status(200).json(successResponse(result.products, { pagination: result.pagination }));
  } catch (error) {
    next(error);
  }
}

/**
 * @summary
 * Handles the request to get a single product by its ID.
 */
export async function getHandler(req: Request, res: Response, next: NextFunction): Promise<void> {
  try {
    const { id } = await productParamsSchema.parseAsync(req.params);
    const idAccount = 1; // Placeholder
    const product = await getProductById(id, idAccount);
    res.status(200).json(successResponse(product));
  } catch (error) {
    next(error);
  }
}

/**
 * @summary
 * Handles the request to get products related to a given product ID.
 */
export async function getRelatedHandler(
  req: Request,
  res: Response,
  next: NextFunction
): Promise<void> {
  try {
    const { id } = await productParamsSchema.parseAsync(req.params);
    const idAccount = 1; // Placeholder
    const relatedProducts = await getRelatedProducts(id, idAccount);
    res.status(200).json(successResponse(relatedProducts));
  } catch (error) {
    next(error);
  }
}

/**
 * @summary
 * Handles the request to get all available filter options for the catalog.
 */
export async function getFilterOptionsHandler(
  _req: Request,
  res: Response,
  next: NextFunction
): Promise<void> {
  try {
    const idAccount = 1; // Placeholder
    const filterOptions = await getFilterOptions(idAccount);
    res.status(200).json(successResponse(filterOptions));
  } catch (error) {
    next(error);
  }
}
