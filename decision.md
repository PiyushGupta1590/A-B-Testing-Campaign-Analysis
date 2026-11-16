# Decision: Control vs Test Campaign

## Recommendation
**Retain Control as the primary campaign. Do not shift budget to Test yet; run a focused follow-up test on Test's post-click experience.**

## What the data says

| Metric | Control | Test | Difference (Test − Control) | z | p-value | Winner |
|---|---|---|---|---|---|---|
| Overall CVR (Purchases / Impressions) | 0.477% | 0.700% | +0.223 pp (+46.8%) | −33.54 | 1.4 × 10⁻²⁴⁶ | **Test** |
| Post-click CVR (Purchases / Clicks) | 9.83% | 8.49% | −1.33 pp (−13.6%) | +13.27 | 3.3 × 10⁻⁴⁰ | **Control** |

Supporting (descriptive) metrics:

| Metric | Control | Test |
|---|---|---|
| Impressions | 3,177,233 | 2,123,249 |
| Website clicks | 154,303 | 175,107 |
| CTR (Clicks / Impressions) | 4.86% | 8.25% |
| Purchases | 15,161 | 14,869 |
| Spend (USD) | 66,818 | 74,595 |
| CPM (cost per 1,000 impressions) | $21.03 | $35.13 |
| CPA (Spend / Purchases) | **$4.41** | $5.02 |

> **Note on reading the z-sign:** the test compares `[Control, Test]`, so a *negative* z means Test is *higher*. The negative z on overall CVR therefore means **Test converts impressions better**, and the positive z on post-click CVR means **Control converts clicks better**.

## Interpretation

1. **Test is better at getting attention.** Its CTR is about 70% higher (8.25% vs 4.86%) and it turns more impressions into purchases. The creative or targeting appears to be more engaging.
2. **Control is better at closing the sale.** Once a visitor has clicked, Control converts 9.83% of them versus 8.49% for Test, a 13.6% relative drop for Test. Test attracts more clicks, but a larger share of them are lower-intent, or the landing experience for Test visitors is weaker.
3. **Test is more expensive.** It was served to fewer people at a much higher CPM ($35 vs $21) and spent about 11.6% more, yet produced about 2% *fewer* purchases (14,869 vs 15,161).
4. **Net result: Control is cheaper per acquisition** ($4.41 vs $5.02; Test costs about 14% more per purchase).

Both differences are statistically significant at the 5% level. With samples this large, almost any difference will be, so the decision rests on **practical significance** (cost and purchases), not on the p-values alone.

## Why not simply pick Test because overall CVR is higher?
Overall CVR ignores cost. Test's higher CVR comes with a much higher cost per impression, so it does not translate into cheaper purchases. If the goal is efficient purchases, CPA is the deciding metric, and Control wins it.

## Next steps
1. **Keep budget on Control** for now.
2. **Diagnose Test's post-click drop:** compare landing pages, audience quality, and the later funnel stages (Searches → View Content → Add to Cart → Purchase) for both groups.
3. **Run a follow-up test** that keeps Test's engaging creative but fixes the post-click experience, or tests a lower bid or budget to bring CPM down.
4. **Revisit the decision** if Test can match Control's post-click CVR or reach a CPA of about $4.41 or lower.

## Limitations
- Two-proportion z-tests assume independent observations. The same people can see many impressions and click several times, which makes the p-values over-confident. Treat them as an upper bound on certainty.
- The groups had very different impression volumes and spend, so exposure was not balanced; this is not a clean randomised split.
- Only 29 days of data, with one day removed during cleaning.
- No revenue or order-value data, so CPA is a proxy for profitability, not ROI.
