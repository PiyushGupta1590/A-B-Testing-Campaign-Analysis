"""
A/B Test: Control vs Test campaign
Two-proportion z-tests on:
  1. Overall CVR     = Purchases / Impressions
  2. Post-click CVR  = Purchases / Website Clicks

Input : clean_table.csv  (exported from data_cleaning.sql; row 0 = Control, row 1 = Test)
Run   : python ab_test.py
"""
import numpy as np
import pandas as pd
from scipy.stats import norm
from statsmodels.stats.proportion import proportions_ztest

ALPHA = 0.05

df = pd.read_csv("clean_table.csv")
control, test = df.iloc[0], df.iloc[1]


def compare(name, successes, trials):
    """Run a two-sided two-proportion z-test and return a summary dict.

    Order is [Control, Test], so z > 0 means Control > Test and z < 0 means Test > Control.
    """
    successes, trials = np.array(successes, dtype=float), np.array(trials, dtype=float)
    z, p = proportions_ztest(successes, trials, alternative="two-sided")
    p_c, p_t = successes / trials
    # 95% CI for the difference (Test - Control), unpooled standard error
    se = np.sqrt(p_c * (1 - p_c) / trials[0] + p_t * (1 - p_t) / trials[1])
    diff = p_t - p_c
    ci = (diff - norm.ppf(1 - ALPHA / 2) * se, diff + norm.ppf(1 - ALPHA / 2) * se)
    return {
        "metric": name,
        "control_rate_%": p_c * 100,
        "test_rate_%": p_t * 100,
        "diff_pp (Test-Control)": diff * 100,
        "ci95_pp": (ci[0] * 100, ci[1] * 100),
        "relative_lift_%": diff / p_c * 100,
        "z": z,
        "p_value": p,
        "significant": p < ALPHA,
        "winner": "Test" if (p < ALPHA and diff > 0) else "Control" if (p < ALPHA and diff < 0) else "No difference",
    }


results = [
    compare("Overall CVR (Purchases / Impressions)",
            [control["Purchases"], test["Purchases"]],
            [control["Impressions"], test["Impressions"]]),
    compare("Post-click CVR (Purchases / Clicks)",
            [control["Purchases"], test["Purchases"]],
            [control["Website_Clicks"], test["Website_Clicks"]]),
]

for r in results:
    print(f"\n{r['metric']}")
    print(f"  Control rate : {r['control_rate_%']:.3f}%")
    print(f"  Test rate    : {r['test_rate_%']:.3f}%")
    print(f"  Difference   : {r['diff_pp (Test-Control)']:+.3f} pp "
          f"(95% CI {r['ci95_pp'][0]:+.3f} to {r['ci95_pp'][1]:+.3f}), "
          f"relative lift {r['relative_lift_%']:+.1f}%")
    print(f"  Z-statistic  : {r['z']:.2f}   (sign: z<0 -> Test higher, z>0 -> Control higher)")
    print(f"  P-value      : {r['p_value']:.3e}")
    print(f"  Significant at {ALPHA}: {r['significant']}  -> winner: {r['winner']}")

# ---- Supporting funnel / cost metrics (descriptive, not tested) ----
print("\nSupporting metrics")
for label, row in (("Control", control), ("Test", test)):
    ctr = row["Website_Clicks"] / row["Impressions"] * 100
    cpc = row["Spend"] / row["Website_Clicks"]
    cpm = row["Spend"] / row["Impressions"] * 1000
    print(f"  {label:8s} CTR {ctr:.2f}% | CPC ${cpc:.3f} | CPM ${cpm:.2f} | CPA ${row['Spend']/row['Purchases']:.2f}")
