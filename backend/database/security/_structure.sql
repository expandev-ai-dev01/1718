/**
 * @schema security
 * Manages authentication, authorization, users, roles, and permissions.
 */
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'security')
BEGIN
    EXEC('CREATE SCHEMA security');
END
GO

-- Add security-related tables (e.g., users, roles) here as needed.
