import { z } from 'zod';

const jsonArrayOfNumbers = z
  .string()
  .optional()
  .transform((val, ctx) => {
    if (!val) return undefined;
    try {
      const parsed = JSON.parse(val);
      if (Array.isArray(parsed) && parsed.every((item) => typeof item === 'number')) {
        return val; // Keep as string for SQL
      }
    } catch (e) {
      /* fall through */
    }
    ctx.addIssue({ code: z.ZodIssueCode.custom, message: 'Must be a JSON array of numbers' });
    return z.NEVER;
  });

export const productListQuerySchema = z
  .object({
    pageNumber: z.coerce.number().int().positive().default(1),
    pageSize: z.coerce.number().int().positive().max(36).default(12),
    sortBy: z
      .enum(['relevance', 'price_asc', 'price_desc', 'rating', 'newest'])
      .default('relevance'),
    searchTerm: z.string().max(100).optional(),
    minPrice: z.coerce.number().min(0).optional(),
    maxPrice: z.coerce.number().min(0).optional(),
    categoryIds: jsonArrayOfNumbers,
    flavorIds: jsonArrayOfNumbers,
    sizeIds: jsonArrayOfNumbers,
    confectionerIds: jsonArrayOfNumbers,
  })
  .refine((data) => !data.maxPrice || !data.minPrice || data.maxPrice >= data.minPrice, {
    message: 'maxPrice must be greater than or equal to minPrice',
    path: ['maxPrice'],
  });

export const productParamsSchema = z.object({
  id: z.coerce.number().int().positive(),
});
