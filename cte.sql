WITH EmployeeHierarchy AS (
    -- Anchor Member: Select the top-level employees (those without a manager)
    SELECT 
        EmployeeKey,
        ParentEmployeeKey,
        FirstName,
        LastName,
        0 AS HierarchyLevel  -- Starting level
    FROM 
        dbo.DimEmployee
    WHERE 
        ParentEmployeeKey IS NULL  -- Top-level employees

    UNION ALL

    -- Recursive Member: Select employees and their managers
    SELECT 
        e.EmployeeKey,
        e.ParentEmployeeKey,
        e.FirstName,
        e.LastName,
        eh.HierarchyLevel + 1 AS HierarchyLevel
    FROM 
        dbo.DimEmployee e
    INNER JOIN 
        EmployeeHierarchy eh ON e.ParentEmployeeKey = eh.EmployeeKey
)
-- Final SELECT: Display the full hierarchy
SELECT 
    EmployeeKey,
    ParentEmployeeKey,
    FirstName,
    LastName,
    HierarchyLevel
FROM 
    EmployeeHierarchy
ORDER BY 
    HierarchyLevel, LastName;
