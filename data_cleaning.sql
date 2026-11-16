-- =====================================================================
-- A/B Testing: Control vs Test Campaign  |  Data cleaning + funnel metrics
-- Dataset: https://www.kaggle.com/datasets/amirmotefaker/ab-testing-dataset
-- Tables : control_group, test_group  (30 daily rows each, imported from CSV)
-- Engine : MySQL 8
-- =====================================================================

SET SQL_SAFE_UPDATES = 0;

-- ---------------------------------------------------------------------
-- 1. Remove the incomplete day
--    One row in control_group has missing values for 5.08.2019.
--    The same date is deleted from test_group so both groups cover
--    exactly the same 29 days (a fair, like-for-like comparison).
-- ---------------------------------------------------------------------
DELETE FROM control_group WHERE Date = '5.08.2019';
DELETE FROM test_group    WHERE Date = '5.08.2019';

-- Sanity check: both should return 29
SELECT COUNT(*) AS control_days FROM control_group;
SELECT COUNT(*) AS test_days    FROM test_group;

-- ---------------------------------------------------------------------
-- 2. Standardise column names (remove spaces, '#', brackets)
-- ---------------------------------------------------------------------
-- Control group
ALTER TABLE control_group
  RENAME COLUMN `Campaign Name`        TO Campaign,
  RENAME COLUMN `Spend [USD]`          TO Spend,
  RENAME COLUMN `# of Impressions`     TO Impressions,
  RENAME COLUMN `# of Website Clicks`  TO `Website Clicks`,
  RENAME COLUMN `# of Searches`        TO Searches,
  RENAME COLUMN `# of View Content`    TO `View Content`,
  RENAME COLUMN `# of Add to Cart`     TO `Add to Cart`,
  RENAME COLUMN `# of Purchase`        TO Purchases;

-- Test group
ALTER TABLE test_group
  RENAME COLUMN `Campaign Name`        TO Campaign,
  RENAME COLUMN `Spend [USD]`          TO Spend,
  RENAME COLUMN `# of Impressions`     TO Impressions,
  RENAME COLUMN `# of Website Clicks`  TO `Website Clicks`,
  RENAME COLUMN `# of Searches`        TO Searches,
  RENAME COLUMN `# of View Content`    TO `View Content`,
  RENAME COLUMN `# of Add to Cart`     TO `Add to Cart`,
  RENAME COLUMN `# of Purchase`        TO Purchases;

-- ---------------------------------------------------------------------
-- 3. Aggregate funnel metrics per group
--    Export the result as clean_table.csv -> input for ab_test.py
--    Row order matters for the CSV: Control first, Test second.
-- ---------------------------------------------------------------------
WITH clean_table AS (
    SELECT
        'Control'                                                    AS `Group`,
        SUM(Impressions)                                             AS Impressions,
        SUM(Purchases)                                               AS Purchases,
        SUM(Spend)                                                   AS Spend,
        ROUND(SUM(Impressions) / COUNT(DISTINCT Date))               AS Avg_Daily_Impressions,
        SUM(`Website Clicks`)                                        AS Website_Clicks,
        ROUND(SUM(Purchases)   / COUNT(DISTINCT Date))               AS Avg_Daily_Purchases,
        ROUND(SUM(Purchases) * 100.0 / SUM(Impressions), 2)          AS CR,            -- Purchases / Impressions (%)
        ROUND(SUM(Purchases) * 100.0 / SUM(`Website Clicks`), 2)     AS Post_Click_CR, -- Purchases / Clicks (%)
        ROUND(SUM(Spend) / SUM(Purchases), 2)                        AS CPA            -- Cost Per Acquisition
    FROM control_group

    UNION ALL

    SELECT
        'Test',
        SUM(Impressions),
        SUM(Purchases),
        SUM(Spend),
        ROUND(SUM(Impressions) / COUNT(DISTINCT Date)),
        SUM(`Website Clicks`),
        ROUND(SUM(Purchases)   / COUNT(DISTINCT Date)),
        ROUND(SUM(Purchases) * 100.0 / SUM(Impressions), 2),
        ROUND(SUM(Purchases) * 100.0 / SUM(`Website Clicks`), 2),
        ROUND(SUM(Spend) / SUM(Purchases), 2)
    FROM test_group
)
SELECT * FROM clean_table;
