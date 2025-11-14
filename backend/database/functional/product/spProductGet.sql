/**
 * @summary
 * Retrieves the complete details for a single product.
 * Returns multiple result sets for product details, images, flavors, sizes, reviews, and confectioner info.
 * 
 * @procedure spProductGet
 * @schema functional
 * @type stored-procedure
 * 
 * @endpoints
 * - GET /api/v1/external/public/product/{id}
 * 
 * @parameters
 * @param {INT} idAccount 
 *   - Required: Yes
 *   - Description: The account identifier.
 * @param {INT} idProduct
 *   - Required: Yes
 *   - Description: The unique identifier of the product to retrieve.
 * 
 * @output {ProductDetails, 1, n}
 * @output {ProductImages, n, n}
 * @output {ProductFlavors, n, n}
 * @output {ProductSizes, n, n}
 * @output {ProductReviews, n, n}
 * @output {ConfectionerInfo, 1, n}
 */
CREATE OR ALTER PROCEDURE [functional].[spProductGet]
  @idAccount INT,
  @idProduct INT
AS
BEGIN
  SET NOCOUNT ON;

  /**
   * @validation Check if product exists and belongs to the account.
   * @throw {ProductNotFound}
   */
  IF NOT EXISTS (
    SELECT 1
    FROM [functional].[product] [prd]
    WHERE [prd].[idAccount] = @idAccount
      AND [prd].[idProduct] = @idProduct
      AND [prd].[deleted] = 0
      AND [prd].[active] = 1
  )
  BEGIN
    ;THROW 51000, 'ProductNotFound', 1;
    RETURN;
  END

  -- 1. Product Details
  SELECT
    [prd].[idProduct],
    [prd].[name],
    [prd].[description],
    [prd].[ingredients],
    [prd].[basePrice],
    [prd].[promotionalPrice],
    [prd].[averageRating],
    [prd].[reviewCount],
    ([prd].[stockQuantity] > 0) AS [isAvailable],
    [prd].[preparationTime]
  FROM [functional].[product] [prd]
  WHERE [prd].[idAccount] = @idAccount
    AND [prd].[idProduct] = @idProduct;

  -- 2. Product Images
  SELECT
    [pimg].[imageUrl],
    [pimg].[displayOrder]
  FROM [functional].[productImage] [pimg]
  WHERE [pimg].[idAccount] = @idAccount
    AND [pimg].[idProduct] = @idProduct
  ORDER BY [pimg].[displayOrder];

  -- 3. Available Flavors
  SELECT
    [flv].[idFlavor],
    [flv].[name]
  FROM [functional].[flavor] [flv]
  JOIN [functional].[productFlavor] [pflv] ON ([pflv].[idAccount] = [flv].[idAccount] AND [pflv].[idFlavor] = [flv].[idFlavor])
  WHERE [flv].[idAccount] = @idAccount
    AND [pflv].[idProduct] = @idProduct
    AND [flv].[deleted] = 0
  ORDER BY [flv].[name];

  -- 4. Available Sizes
  SELECT
    [sz].[idSize],
    [sz].[name],
    [sz].[description],
    [psz].[priceModifier]
  FROM [functional].[size] [sz]
  JOIN [functional].[productSize] [psz] ON ([psz].[idAccount] = [sz].[idAccount] AND [psz].[idSize] = [sz].[idSize])
  WHERE [sz].[idAccount] = @idAccount
    AND [psz].[idProduct] = @idProduct
    AND [sz].[deleted] = 0
  ORDER BY [sz].[name];

  -- 5. Product Reviews (most recent first)
  SELECT
    [prw].[idProductReview],
    [prw].[customerName],
    [prw].[rating],
    [prw].[comment],
    [prw].[dateCreated]
  FROM [functional].[productReview] [prw]
  WHERE [prw].[idAccount] = @idAccount
    AND [prw].[idProduct] = @idProduct
    AND [prw].[deleted] = 0
  ORDER BY [prw].[dateCreated] DESC;

  -- 6. Confectioner Info
  SELECT
    [cnf].[idConfectioner],
    [cnf].[name],
    [cnf].[profilePictureUrl],
    [cnf].[averageRating],
    [cnf].[productsSold]
  FROM [functional].[confectioner] [cnf]
  JOIN [functional].[product] [prd] ON ([prd].[idAccount] = [cnf].[idAccount] AND [prd].[idConfectioner] = [cnf].[idConfectioner])
  WHERE [cnf].[idAccount] = @idAccount
    AND [prd].[idProduct] = @idProduct;

END;
GO
