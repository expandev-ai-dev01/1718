/**
 * @schema functional
 * Contains all business logic, entities, and operational objects for the application.
 */
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'functional')
BEGIN
    EXEC('CREATE SCHEMA functional');
END
GO

-- Add business entity tables (e.g., products, orders) here as needed.
