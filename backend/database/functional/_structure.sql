/**
 * @schema functional
 * Contains all business logic, entities, and operational objects for the application.
 */
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'functional')
BEGIN
    EXEC('CREATE SCHEMA functional');
END
GO

-- Drop section (in reverse order of creation)
/*
DROP TABLE IF EXISTS [functional].[productReview];
DROP TABLE IF EXISTS [functional].[productSize];
DROP TABLE IF EXISTS [functional].[productFlavor];
DROP TABLE IF EXISTS [functional].[productImage];
DROP TABLE IF EXISTS [functional].[product];
DROP TABLE IF EXISTS [functional].[size];
DROP TABLE IF EXISTS [functional].[flavor];
DROP TABLE IF EXISTS [functional].[category];
DROP TABLE IF EXISTS [functional].[confectioner];
*/

/**
 * @table confectioner Stores information about the bakers/sellers.
 * @multitenancy true
 * @softDelete true
 * @alias cnf
 */
CREATE TABLE [functional].[confectioner] (
  [idConfectioner] INTEGER IDENTITY(1, 1) NOT NULL,
  [idAccount] INTEGER NOT NULL,
  [name] NVARCHAR(100) NOT NULL,
  [profilePictureUrl] NVARCHAR(255) NULL,
  [averageRating] NUMERIC(3, 2) NOT NULL,
  [productsSold] INTEGER NOT NULL,
  [dateCreated] DATETIME2 NOT NULL,
  [dateModified] DATETIME2 NOT NULL,
  [deleted] BIT NOT NULL
);
GO

/**
 * @table category Stores product categories.
 * @multitenancy true
 * @softDelete true
 * @alias ctg
 */
CREATE TABLE [functional].[category] (
  [idCategory] INTEGER IDENTITY(1, 1) NOT NULL,
  [idAccount] INTEGER NOT NULL,
  [name] NVARCHAR(100) NOT NULL,
  [description] NVARCHAR(500) NOT NULL,
  [dateCreated] DATETIME2 NOT NULL,
  [dateModified] DATETIME2 NOT NULL,
  [deleted] BIT NOT NULL
);
GO

/**
 * @table flavor Stores available product flavors.
 * @multitenancy true
 * @softDelete true
 * @alias flv
 */
CREATE TABLE [functional].[flavor] (
  [idFlavor] INTEGER IDENTITY(1, 1) NOT NULL,
  [idAccount] INTEGER NOT NULL,
  [name] NVARCHAR(100) NOT NULL,
  [dateCreated] DATETIME2 NOT NULL,
  [dateModified] DATETIME2 NOT NULL,
  [deleted] BIT NOT NULL
);
GO

/**
 * @table size Stores available product sizes.
 * @multitenancy true
 * @softDelete true
 * @alias sz
 */
CREATE TABLE [functional].[size] (
  [idSize] INTEGER IDENTITY(1, 1) NOT NULL,
  [idAccount] INTEGER NOT NULL,
  [name] NVARCHAR(100) NOT NULL,
  [description] NVARCHAR(255) NOT NULL, -- e.g., '15cm - serves 10 people'
  [dateCreated] DATETIME2 NOT NULL,
  [dateModified] DATETIME2 NOT NULL,
  [deleted] BIT NOT NULL
);
GO

/**
 * @table product The main table for products (cakes).
 * @multitenancy true
 * @softDelete true
 * @alias prd
 */
CREATE TABLE [functional].[product] (
  [idProduct] INTEGER IDENTITY(1, 1) NOT NULL,
  [idAccount] INTEGER NOT NULL,
  [idConfectioner] INTEGER NOT NULL,
  [idCategory] INTEGER NOT NULL,
  [name] NVARCHAR(100) NOT NULL,
  [description] NVARCHAR(1000) NOT NULL,
  [ingredients] NVARCHAR(MAX) NOT NULL, -- Storing as a comma-separated list or JSON array string
  [basePrice] NUMERIC(18, 6) NOT NULL,
  [promotionalPrice] NUMERIC(18, 6) NULL,
  [mainImageUrl] NVARCHAR(255) NOT NULL,
  [averageRating] NUMERIC(3, 2) NOT NULL,
  [reviewCount] INTEGER NOT NULL,
  [stockQuantity] INTEGER NOT NULL,
  [preparationTime] NVARCHAR(50) NOT NULL, -- e.g., '2 hours', '1 day'
  [active] BIT NOT NULL,
  [dateCreated] DATETIME2 NOT NULL,
  [dateModified] DATETIME2 NOT NULL,
  [deleted] BIT NOT NULL
);
GO

/**
 * @table productImage Stores gallery images for products.
 * @multitenancy true
 * @softDelete false
 * @alias pimg
 */
CREATE TABLE [functional].[productImage] (
  [idProductImage] INTEGER IDENTITY(1, 1) NOT NULL,
  [idAccount] INTEGER NOT NULL,
  [idProduct] INTEGER NOT NULL,
  [imageUrl] NVARCHAR(255) NOT NULL,
  [displayOrder] INT NOT NULL
);
GO

/**
 * @table productFlavor Relationship table for products and flavors (many-to-many).
 * @multitenancy true
 * @softDelete false
 * @alias pflv
 */
CREATE TABLE [functional].[productFlavor] (
  [idAccount] INTEGER NOT NULL,
  [idProduct] INTEGER NOT NULL,
  [idFlavor] INTEGER NOT NULL
);
GO

/**
 * @table productSize Relationship table for products and sizes (many-to-many).
 * @multitenancy true
 * @softDelete false
 * @alias psz
 */
CREATE TABLE [functional].[productSize] (
  [idAccount] INTEGER NOT NULL,
  [idProduct] INTEGER NOT NULL,
  [idSize] INTEGER NOT NULL,
  [priceModifier] NUMERIC(18, 6) NOT NULL -- Can be positive or negative
);
GO

/**
 * @table productReview Stores customer reviews for products.
 * @multitenancy true
 * @softDelete true
 * @alias prw
 */
CREATE TABLE [functional].[productReview] (
  [idProductReview] INTEGER IDENTITY(1, 1) NOT NULL,
  [idAccount] INTEGER NOT NULL,
  [idProduct] INTEGER NOT NULL,
  [customerName] NVARCHAR(100) NOT NULL, -- Simplified for now, could link to a customer table
  [rating] INT NOT NULL,
  [comment] NVARCHAR(1000) NULL,
  [dateCreated] DATETIME2 NOT NULL,
  [deleted] BIT NOT NULL
);
GO

-- CONSTRAINTS --

-- Confectioner
ALTER TABLE [functional].[confectioner] ADD CONSTRAINT [pkConfectioner] PRIMARY KEY CLUSTERED ([idConfectioner]);
ALTER TABLE [functional].[confectioner] ADD CONSTRAINT [dfConfectioner_averageRating] DEFAULT (0) FOR [averageRating];
ALTER TABLE [functional].[confectioner] ADD CONSTRAINT [dfConfectioner_productsSold] DEFAULT (0) FOR [productsSold];
ALTER TABLE [functional].[confectioner] ADD CONSTRAINT [dfConfectioner_dateCreated] DEFAULT (GETUTCDATE()) FOR [dateCreated];
ALTER TABLE [functional].[confectioner] ADD CONSTRAINT [dfConfectioner_dateModified] DEFAULT (GETUTCDATE()) FOR [dateModified];
ALTER TABLE [functional].[confectioner] ADD CONSTRAINT [dfConfectioner_deleted] DEFAULT (0) FOR [deleted];

-- Category
ALTER TABLE [functional].[category] ADD CONSTRAINT [pkCategory] PRIMARY KEY CLUSTERED ([idCategory]);
ALTER TABLE [functional].[category] ADD CONSTRAINT [dfCategory_description] DEFAULT ('') FOR [description];
ALTER TABLE [functional].[category] ADD CONSTRAINT [dfCategory_dateCreated] DEFAULT (GETUTCDATE()) FOR [dateCreated];
ALTER TABLE [functional].[category] ADD CONSTRAINT [dfCategory_dateModified] DEFAULT (GETUTCDATE()) FOR [dateModified];
ALTER TABLE [functional].[category] ADD CONSTRAINT [dfCategory_deleted] DEFAULT (0) FOR [deleted];

-- Flavor
ALTER TABLE [functional].[flavor] ADD CONSTRAINT [pkFlavor] PRIMARY KEY CLUSTERED ([idFlavor]);
ALTER TABLE [functional].[flavor] ADD CONSTRAINT [dfFlavor_dateCreated] DEFAULT (GETUTCDATE()) FOR [dateCreated];
ALTER TABLE [functional].[flavor] ADD CONSTRAINT [dfFlavor_dateModified] DEFAULT (GETUTCDATE()) FOR [dateModified];
ALTER TABLE [functional].[flavor] ADD CONSTRAINT [dfFlavor_deleted] DEFAULT (0) FOR [deleted];

-- Size
ALTER TABLE [functional].[size] ADD CONSTRAINT [pkSize] PRIMARY KEY CLUSTERED ([idSize]);
ALTER TABLE [functional].[size] ADD CONSTRAINT [dfSize_description] DEFAULT ('') FOR [description];
ALTER TABLE [functional].[size] ADD CONSTRAINT [dfSize_dateCreated] DEFAULT (GETUTCDATE()) FOR [dateCreated];
ALTER TABLE [functional].[size] ADD CONSTRAINT [dfSize_dateModified] DEFAULT (GETUTCDATE()) FOR [dateModified];
ALTER TABLE [functional].[size] ADD CONSTRAINT [dfSize_deleted] DEFAULT (0) FOR [deleted];

-- Product
ALTER TABLE [functional].[product] ADD CONSTRAINT [pkProduct] PRIMARY KEY CLUSTERED ([idProduct]);
ALTER TABLE [functional].[product] ADD CONSTRAINT [fkProduct_Confectioner] FOREIGN KEY ([idConfectioner]) REFERENCES [functional].[confectioner]([idConfectioner]);
ALTER TABLE [functional].[product] ADD CONSTRAINT [fkProduct_Category] FOREIGN KEY ([idCategory]) REFERENCES [functional].[category]([idCategory]);
ALTER TABLE [functional].[product] ADD CONSTRAINT [dfProduct_averageRating] DEFAULT (0) FOR [averageRating];
ALTER TABLE [functional].[product] ADD CONSTRAINT [dfProduct_reviewCount] DEFAULT (0) FOR [reviewCount];
ALTER TABLE [functional].[product] ADD CONSTRAINT [dfProduct_stockQuantity] DEFAULT (0) FOR [stockQuantity];
ALTER TABLE [functional].[product] ADD CONSTRAINT [dfProduct_active] DEFAULT (1) FOR [active];
ALTER TABLE [functional].[product] ADD CONSTRAINT [dfProduct_dateCreated] DEFAULT (GETUTCDATE()) FOR [dateCreated];
ALTER TABLE [functional].[product] ADD CONSTRAINT [dfProduct_dateModified] DEFAULT (GETUTCDATE()) FOR [dateModified];
ALTER TABLE [functional].[product] ADD CONSTRAINT [dfProduct_deleted] DEFAULT (0) FOR [deleted];
ALTER TABLE [functional].[product] ADD CONSTRAINT [chkProduct_basePrice] CHECK ([basePrice] > 0);

-- ProductImage
ALTER TABLE [functional].[productImage] ADD CONSTRAINT [pkProductImage] PRIMARY KEY CLUSTERED ([idProductImage]);
ALTER TABLE [functional].[productImage] ADD CONSTRAINT [fkProductImage_Product] FOREIGN KEY ([idProduct]) REFERENCES [functional].[product]([idProduct]);
ALTER TABLE [functional].[productImage] ADD CONSTRAINT [dfProductImage_displayOrder] DEFAULT (0) FOR [displayOrder];

-- ProductFlavor
ALTER TABLE [functional].[productFlavor] ADD CONSTRAINT [pkProductFlavor] PRIMARY KEY CLUSTERED ([idProduct], [idFlavor]);
ALTER TABLE [functional].[productFlavor] ADD CONSTRAINT [fkProductFlavor_Product] FOREIGN KEY ([idProduct]) REFERENCES [functional].[product]([idProduct]);
ALTER TABLE [functional].[productFlavor] ADD CONSTRAINT [fkProductFlavor_Flavor] FOREIGN KEY ([idFlavor]) REFERENCES [functional].[flavor]([idFlavor]);

-- ProductSize
ALTER TABLE [functional].[productSize] ADD CONSTRAINT [pkProductSize] PRIMARY KEY CLUSTERED ([idProduct], [idSize]);
ALTER TABLE [functional].[productSize] ADD CONSTRAINT [fkProductSize_Product] FOREIGN KEY ([idProduct]) REFERENCES [functional].[product]([idProduct]);
ALTER TABLE [functional].[productSize] ADD CONSTRAINT [fkProductSize_Size] FOREIGN KEY ([idSize]) REFERENCES [functional].[size]([idSize]);
ALTER TABLE [functional].[productSize] ADD CONSTRAINT [dfProductSize_priceModifier] DEFAULT (0) FOR [priceModifier];

-- ProductReview
ALTER TABLE [functional].[productReview] ADD CONSTRAINT [pkProductReview] PRIMARY KEY CLUSTERED ([idProductReview]);
ALTER TABLE [functional].[productReview] ADD CONSTRAINT [fkProductReview_Product] FOREIGN KEY ([idProduct]) REFERENCES [functional].[product]([idProduct]);
ALTER TABLE [functional].[productReview] ADD CONSTRAINT [dfProductReview_dateCreated] DEFAULT (GETUTCDATE()) FOR [dateCreated];
ALTER TABLE [functional].[productReview] ADD CONSTRAINT [dfProductReview_deleted] DEFAULT (0) FOR [deleted];
ALTER TABLE [functional].[productReview] ADD CONSTRAINT [chkProductReview_rating] CHECK ([rating] BETWEEN 1 AND 5);
GO

-- INDEXES --

-- Confectioner
CREATE NONCLUSTERED INDEX [ixConfectioner_Account] ON [functional].[confectioner]([idAccount]) WHERE [deleted] = 0;
CREATE UNIQUE NONCLUSTERED INDEX [uqConfectioner_Account_Name] ON [functional].[confectioner]([idAccount], [name]) WHERE [deleted] = 0;

-- Category
CREATE NONCLUSTERED INDEX [ixCategory_Account] ON [functional].[category]([idAccount]) WHERE [deleted] = 0;
CREATE UNIQUE NONCLUSTERED INDEX [uqCategory_Account_Name] ON [functional].[category]([idAccount], [name]) WHERE [deleted] = 0;

-- Flavor
CREATE NONCLUSTERED INDEX [ixFlavor_Account] ON [functional].[flavor]([idAccount]) WHERE [deleted] = 0;
CREATE UNIQUE NONCLUSTERED INDEX [uqFlavor_Account_Name] ON [functional].[flavor]([idAccount], [name]) WHERE [deleted] = 0;

-- Size
CREATE NONCLUSTERED INDEX [ixSize_Account] ON [functional].[size]([idAccount]) WHERE [deleted] = 0;
CREATE UNIQUE NONCLUSTERED INDEX [uqSize_Account_Name] ON [functional].[size]([idAccount], [name]) WHERE [deleted] = 0;

-- Product
CREATE NONCLUSTERED INDEX [ixProduct_Account] ON [functional].[product]([idAccount]) WHERE [deleted] = 0;
CREATE NONCLUSTERED INDEX [ixProduct_Account_Confectioner] ON [functional].[product]([idAccount], [idConfectioner]) WHERE [deleted] = 0;
CREATE NONCLUSTERED INDEX [ixProduct_Account_Category] ON [functional].[product]([idAccount], [idCategory]) WHERE [deleted] = 0;
CREATE NONCLUSTERED INDEX [ixProduct_Account_Name] ON [functional].[product]([idAccount], [name]) INCLUDE ([description]) WHERE [deleted] = 0;

-- ProductImage
CREATE NONCLUSTERED INDEX [ixProductImage_Account_Product] ON [functional].[productImage]([idAccount], [idProduct]);

-- ProductFlavor
CREATE NONCLUSTERED INDEX [ixProductFlavor_Account_Product] ON [functional].[productFlavor]([idAccount], [idProduct]);
CREATE NONCLUSTERED INDEX [ixProductFlavor_Account_Flavor] ON [functional].[productFlavor]([idAccount], [idFlavor]);

-- ProductSize
CREATE NONCLUSTERED INDEX [ixProductSize_Account_Product] ON [functional].[productSize]([idAccount], [idProduct]);
CREATE NONCLUSTERED INDEX [ixProductSize_Account_Size] ON [functional].[productSize]([idAccount], [idSize]);

-- ProductReview
CREATE NONCLUSTERED INDEX [ixProductReview_Account_Product] ON [functional].[productReview]([idAccount], [idProduct]) WHERE [deleted] = 0;
GO
