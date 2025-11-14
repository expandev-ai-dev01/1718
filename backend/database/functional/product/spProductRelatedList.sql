/**
 * @summary
 * Retrieves a list of related products based on the same category or confectioner.
 * 
 * @procedure spProductRelatedList
 * @schema functional
 * @type stored-procedure
 * 
 * @endpoints
 * - GET /api/v1/external/public/product/{id}/related
 * 
 * @parameters
 * @param {INT} idAccount 
 *   - Required: Yes
 *   - Description: The account identifier.
 * @param {INT} idProduct
 *   - Required: Yes
 *   - Description: The ID of the product to find related items for.
 * @param {INT} count
 *   - Required: No
 *   - Description: The maximum number of related products to return. Defaults to 4.
 * 
 * @output {RelatedProducts, n, n}
 */
CREATE OR ALTER PROCEDURE [functional].[spProductRelatedList]
  @idAccount INT,
  @idProduct INT,
  @count INT = 4
AS
BEGIN
  SET NOCOUNT ON;

  DECLARE @idCategory INT;
  DECLARE @idConfectioner INT;

  SELECT
    @idCategory = [prd].[idCategory],
    @idConfectioner = [prd].[idConfectioner]
  FROM [functional].[product] [prd]
  WHERE [prd].[idAccount] = @idAccount
    AND [prd].[idProduct] = @idProduct;

  IF @idCategory IS NULL
  BEGIN
    -- Product not found, return empty set
    SELECT
      [prd].[idProduct],
      [prd].[name],
      [prd].[mainImageUrl],
      COALESCE([prd].[promotionalPrice], [prd].[basePrice]) AS [price],
      [prd].[averageRating]
    FROM [functional].[product] [prd]
    WHERE 1 = 0; -- Return no rows
    RETURN;
  END

  SELECT TOP (@count)
    [prd].[idProduct],
    [prd].[name],
    [prd].[mainImageUrl],
    COALESCE([prd].[promotionalPrice], [prd].[basePrice]) AS [price],
    [prd].[averageRating]
  FROM [functional].[product] [prd]
  WHERE [prd].[idAccount] = @idAccount
    AND [prd].[idProduct] <> @idProduct -- Exclude the product itself
    AND [prd].[deleted] = 0
    AND [prd].[active] = 1
    AND [prd].[stockQuantity] > 0
    AND (
      [prd].[idCategory] = @idCategory
      OR [prd].[idConfectioner] = @idConfectioner
    )
  ORDER BY
    -- Prioritize products from the same confectioner and category
    CASE WHEN [prd].[idConfectioner] = @idConfectioner AND [prd].[idCategory] = @idCategory THEN 1 ELSE 3 END,
    -- Then same confectioner
    CASE WHEN [prd].[idConfectioner] = @idConfectioner THEN 2 ELSE 3 END,
    -- Then by rating
    [prd].[averageRating] DESC;

END;
GO
