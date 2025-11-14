/**
 * @summary
 * Retrieves all available and active filter options for the product catalog.
 * This includes categories, flavors, sizes, and confectioners.
 * 
 * @procedure spProductFilterOptionsList
 * @schema functional
 * @type stored-procedure
 * 
 * @endpoints
 * - GET /api/v1/external/public/product/filter-options
 * 
 * @parameters
 * @param {INT} idAccount 
 *   - Required: Yes
 *   - Description: The account identifier to scope the results.
 * 
 * @output {Categories, n, n}
 * @column {INT} idCategory
 * @column {NVARCHAR(100)} name
 * 
 * @output {Flavors, n, n}
 * @column {INT} idFlavor
 * @column {NVARCHAR(100)} name
 * 
 * @output {Sizes, n, n}
 * @column {INT} idSize
 * @column {NVARCHAR(100)} name
 * @column {NVARCHAR(255)} description
 * 
 * @output {Confectioners, n, n}
 * @column {INT} idConfectioner
 * @column {NVARCHAR(100)} name
 */
CREATE OR ALTER PROCEDURE [functional].[spProductFilterOptionsList]
  @idAccount INT
AS
BEGIN
  SET NOCOUNT ON;

  -- Categories
  SELECT
    [ctg].[idCategory],
    [ctg].[name]
  FROM [functional].[category] [ctg]
  WHERE [ctg].[idAccount] = @idAccount
    AND [ctg].[deleted] = 0
  ORDER BY [ctg].[name];

  -- Flavors
  SELECT
    [flv].[idFlavor],
    [flv].[name]
  FROM [functional].[flavor] [flv]
  WHERE [flv].[idAccount] = @idAccount
    AND [flv].[deleted] = 0
  ORDER BY [flv].[name];

  -- Sizes
  SELECT
    [sz].[idSize],
    [sz].[name],
    [sz].[description]
  FROM [functional].[size] [sz]
  WHERE [sz].[idAccount] = @idAccount
    AND [sz].[deleted] = 0
  ORDER BY [sz].[name];

  -- Confectioners
  SELECT
    [cnf].[idConfectioner],
    [cnf].[name]
  FROM [functional].[confectioner] [cnf]
  WHERE [cnf].[idAccount] = @idAccount
    AND [cnf].[deleted] = 0
  ORDER BY [cnf].[name];

END;
GO
