# A/B Testing: Control vs Test Ad Campaign

Statistical comparison of two ad campaigns using SQL for cleaning and two-proportion z-tests in Python, ending in a budget decision.

**Dataset:** [A/B Testing Dataset (Kaggle)](https://www.kaggle.com/datasets/amirmotefaker/ab-testing-dataset): daily funnel data for a Control and a Test campaign (Impressions → Clicks → Searches → View Content → Add to Cart → Purchase), plus spend.

## Repository structure
| File | Purpose |
|---|---|
| `data_cleaning.sql` | Cleans both tables and builds the aggregated funnel table |
| `clean_table.csv` | Output of the SQL aggregation (Control row, then Test row) |
| `ab_test.py` | Two-proportion z-tests, confidence intervals, supporting metrics |
| `ab_testing.ipynb` | Notebook version of the tests with step-by-step explanations |
| `decision.md` | Business interpretation and recommendation |

## Workflow

### 1. Data cleaning (SQL)
1. **Remove the incomplete day.** One row (`5.08.2019`) had missing values in `control_group`. The same date was deleted from `test_group` so both groups cover the same 29 days.
2. **Rename columns** to remove spaces, `#` and brackets (e.g. `# of Purchase` → `Purchases`, `Spend [USD]` → `Spend`).
3. **Aggregate per group** with a `UNION ALL` query that computes:

| Metric | Formula |
|---|---|
| Total impressions, clicks, purchases, spend | `SUM(...)` |
| Avg daily impressions / purchases | `SUM(...) / COUNT(DISTINCT Date)` |
| CR (overall conversion rate) | Purchases / Impressions |
| Post-click CR | Purchases / Website Clicks |
| CPA (cost per acquisition) | Spend / Purchases |

The result is exported as `clean_table.csv`.

### 2. Define the question
1. **Effectiveness:** does Test generate better overall conversion?
2. **Traffic quality:** do clicks translate into purchases?
3. **Decision:** shift budget, retain Control, or test further.

### 3. Hypotheses
**A. Overall CVR** (Purchases / Impressions)
- H₀: Control CVR = Test CVR
- H₁: Control CVR ≠ Test CVR

**B. Post-click CVR** (Purchases / Website Clicks)
- H₀: Control post-click CVR = Test post-click CVR
- H₁: Control post-click CVR ≠ Test post-click CVR

Both are **two-tailed** (we care whether either campaign differs, in either direction), tested at α = 0.05.

**Why two metrics?** Overall CVR covers the whole impression-to-purchase journey. Post-click CVR isolates the click-to-purchase step. A campaign can generate fewer or more clicks yet convert them differently, and only looking at both reveals that.

### 4. Statistical test
Both metrics are proportions, so a **two-proportion z-test** (`statsmodels.stats.proportion.proportions_ztest`) is used. Successes are purchases and trials are impressions (or clicks). Order is `[Control, Test]`, so **z < 0 means Test is higher, z > 0 means Control is higher.**

### 5. Results

| Metric | Control | Test | z | p-value | Winner |
|---|---|---|---|---|---|
| Overall CVR | 0.477% | 0.700% | −33.54 | 1.4 × 10⁻²⁴⁶ | Test |
| Post-click CVR | 9.83% | 8.49% | +13.27 | 3.3 × 10⁻⁴⁰ | Control |

Both are significant at 5%. The two metrics tell different stories: Test attracts more engagement, Control converts the visitors better, and Control has the lower CPA.

### 6. Decision
Retain Control, investigate Test's post-click experience, and re-test. Full reasoning and limitations are in [`decision.md`](decision.md).

## How to run
```bash
pip install pandas numpy scipy statsmodels
python ab_test.py
```
To regenerate `clean_table.csv`, import the Kaggle CSVs into MySQL as `control_group` and `test_group`, run `data_cleaning.sql`, and export the final query result.

## Tech stack
MySQL · Python (pandas, NumPy, SciPy, statsmodels) · Jupyter

#Refrences 
Contentful blog by salesforce: https://www.contentful.com/blog/increase-conversion-rates-with-ab-testing/


Kaggle notebook refrence: https://www.kaggle.com/code/macypalmerston/a-b-testing-campaign-analysis-and-dashboard/notebook?select=control_group.csv


Youtube : https://www.youtube.com/watch?v=qke0VHoz8a8&t=2924s
