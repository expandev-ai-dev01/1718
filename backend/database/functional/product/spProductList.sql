/**
 * @summary
 * Retrieves a paginated and filtered list of products for the catalog.
 * 
 * @procedure spProductList
 * @schema functional
 * @type stored-procedure
 * 
 * @endpoints
 * - GET /api/v1/external/public/product
 * 
 * @parameters
 * @param {INT} idAccount - Required. Account identifier.
 * @param {INT} pageNumber - Required. The page number to retrieve.
 * @param {INT} pageSize - Required. The number of items per page.
 * @param {NVARCHAR(50)} sortBy - Optional. Sort criteria ('relevance', 'price_asc', 'price_desc', 'rating', 'newest').
 * @param {NVARCHAR(100)} searchTerm - Optional. Text to search in name and description.
 * @param {NVARCHAR(MAX)} categoryIds - Optional. JSON array of category IDs to filter by (e.g., '[1, 2, 3]').
 * @param {NVARCHAR(MAX)} flavorIds - Optional. JSON array of flavor IDs to filter by.
 * @param {NVARCHAR(MAX)} sizeIds - Optional. JSON array of size IDs to filter by.
 * @param {NVARCHAR(MAX)} confectionerIds - Optional. JSON array of confectioner IDs to filter by.
 * @param {NUMERIC(18, 6)} minPrice - Optional. Minimum price filter.
 * @param {NUMERIC(18, 6)} maxPrice - Optional. Maximum price filter.
 * 
 * @output {ProductList, n, n}
 * @output {TotalCount, 1, 1}
 */
CREATE OR ALTER PROCEDURE [functional].[spProductList]
  @idAccount INT,
  @pageNumber INT = 1,
  @pageSize INT = 12,
  @sortBy NVARCHAR(50) = 'relevance',
  @searchTerm NVARCHAR(100) = NULL,
  @categoryIds NVARCHAR(MAX) = NULL,
  @flavorIds NVARCHAR(MAX) = NULL,
  @sizeIds NVARCHAR(MAX) = NULL,
  @confectionerIds NVARCHAR(MAX) = NULL,
  @minPrice NUMERIC(18, 6) = NULL,
  @maxPrice NUMERIC(18, 6) = NULL
AS
BEGIN
  SET NOCOUNT ON;

  DECLARE @offset INT = (@pageNumber - 1) * @pageSize;

  WITH [FilteredProducts] AS (
    SELECT DISTINCT
      [prd].[idProduct]
    FROM [functional].[product] [prd]
    LEFT JOIN [functional].[productFlavor] [pflv] ON ([pflv].[idAccount] = [prd].[idAccount] AND [pflv].[idProduct] = [prd].[idProduct])
    LEFT JOIN [functional].[productSize] [psz] ON ([psz].[idAccount] = [prd].[idAccount] AND [psz].[idProduct] = [prd].[idProduct])
    WHERE [prd].[idAccount] = @idAccount
      AND [prd].[deleted] = 0
      AND [prd].[active] = 1
      -- Search Term Filter
      AND (@searchTerm IS NULL OR [prd].[name] LIKE '%' + @searchTerm + '%' OR [prd].[description] LIKE '%' + @searchTerm + '%')
      -- Price Filter
      AND ([prd].[basePrice] >= ISNULL(@minPrice, [prd].[basePrice]))
      AND ([prd].[basePrice] <= ISNULL(@maxPrice, [prd].[basePrice]))
      -- Category Filter
      AND (@categoryIds IS NULL OR [prd].[idCategory] IN (SELECT CAST([value] AS INT) FROM OPENJSON(@categoryIds)))
      -- Confectioner Filter
      AND (@confectionerIds IS NULL OR [prd].[idConfectioner] IN (SELECT CAST([value] AS INT) FROM OPENJSON(@confectionerIds)))
      -- Flavor Filter
      AND (@flavorIds IS NULL OR [pflv].[idFlavor] IN (SELECT CAST([value] AS INT) FROM OPENJSON(@flavorIds)))
      -- Size Filter
      AND (@sizeIds IS NULL OR [psz].[idSize] IN (SELECT CAST([value] AS INT) FROM OPENJSON(@sizeIds)))
  )
  -- First result set: Paginated product list
  SELECT
    [prd].[idProduct],
    [prd].[name],
    [prd].[mainImageUrl],
    COALESCE([prd].[promotionalPrice], [prd].[basePrice]) AS [price],
    IIF([prd].[promotionalPrice] IS NOT NULL, [prd].[basePrice], NULL) AS [originalPrice],
    [prd].[averageRating],
    [prd].[reviewCount],
    [cnf].[name] AS [confectionerName],
    ([prd].[stockQuantity] > 0) AS [isAvailable],
    [prd].[preparationTime]
  FROM [functional].[product] [prd]
  JOIN [functional].[confectioner] [cnf] ON ([cnf].[idAccount] = [prd].[idAccount] AND [cnf].[idConfectioner] = [prd].[idConfectioner])
  WHERE [prd].[idProduct] IN (SELECT [idProduct] FROM [FilteredProducts])
  ORDER BY
    CASE WHEN @sortBy = 'price_asc' THEN COALESCE([prd].[promotionalPrice], [prd].[basePrice]) END ASC,
    CASE WHEN @sortBy = 'price_desc' THEN COALESCE([prd].[promotionalPrice], [prd].[basePrice]) END DESC,
    CASE WHEN @sortBy = 'rating' THEN [prd].[averageRating] END DESC,
    CASE WHEN @sortBy = 'newest' THEN [prd].[dateCreated] END DESC,
    -- Default to relevance (idProduct as a proxy)
    [prd].[idProduct] DESC
  OFFSET @offset ROWS
  FETCH NEXT @pageSize ROWS ONLY;

  -- Second result set: Total count
  SELECT COUNT(*) AS [totalRecords]
  FROM [FilteredProducts];

END;
GO
