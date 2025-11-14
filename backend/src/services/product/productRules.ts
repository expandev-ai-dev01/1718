import { dbRequest, ExpectedReturn } from '@/utils/database';
import { IRecordSet } from 'mssql';
import {
  ProductListParams,
  ProductListResponse,
  ProductDetail,
  FilterOptions,
  RelatedProduct,
} from './productTypes';

/**
 * @summary
 * Fetches a list of products based on specified filters, sorting, and pagination.
 */
export async function listProducts(params: ProductListParams): Promise<ProductListResponse> {
  const result = (await dbRequest(
    '[functional].[spProductList]',
    params,
    ExpectedReturn.Multi
  )) as IRecordSet<any>[];

  const products = result[0];
  const totalRecords = result[1][0]?.totalRecords || 0;

  return {
    products,
    pagination: {
      page: params.pageNumber,
      pageSize: params.pageSize,
      totalRecords,
      totalPages: Math.ceil(totalRecords / params.pageSize),
    },
  };
}

/**
 * @summary
 * Fetches the detailed information for a single product.
 */
export async function getProductById(idProduct: number, idAccount: number): Promise<ProductDetail> {
  const resultSets = (await dbRequest(
    '[functional].[spProductGet]',
    { idProduct, idAccount },
    ExpectedReturn.Multi
  )) as IRecordSet<any>[];

  if (!resultSets || !resultSets[0] || resultSets[0].length === 0) {
    // In a real app, you might throw a custom NotFoundError
    throw new Error('Product not found');
  }

  const productDetail = resultSets[0][0];
  const images = resultSets[1];
  const flavors = resultSets[2];
  const sizes = resultSets[3];
  const reviews = resultSets[4];
  const confectioner = resultSets[5][0];

  return {
    ...productDetail,
    images,
    availableFlavors: flavors,
    availableSizes: sizes,
    reviews,
    confectioner,
  };
}

/**
 * @summary
 * Fetches a list of products related to a given product.
 */
export async function getRelatedProducts(
  idProduct: number,
  idAccount: number
): Promise<RelatedProduct[]> {
  const result = await dbRequest(
    '[functional].[spProductRelatedList]',
    { idProduct, idAccount, count: 4 },
    ExpectedReturn.Multi // Even if one result set, using Multi for consistency
  );
  return result[0] || [];
}

/**
 * @summary
 * Fetches all available filter options for the product catalog.
 */
export async function getFilterOptions(idAccount: number): Promise<FilterOptions> {
  const resultSets = (await dbRequest(
    '[functional].[spProductFilterOptionsList]',
    { idAccount },
    ExpectedReturn.Multi
  )) as IRecordSet<any>[];

  return {
    categories: resultSets[0] || [],
    flavors: resultSets[1] || [],
    sizes: resultSets[2] || [],
    confectioners: resultSets[3] || [],
  };
}
