/**
 * @schema subscription
 * Handles account management, subscription plans, and multi-tenancy.
 */
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'subscription')
BEGIN
    EXEC('CREATE SCHEMA subscription');
END
GO

-- Add subscription and account tables here as needed.
