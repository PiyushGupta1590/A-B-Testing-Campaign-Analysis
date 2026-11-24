# Decision

## Result

Both results are statistically significant at the 5% significance level.

| Metric         | Z-statistic | P-value       | Conclusion  |
| -------------- | ----------- | ------------- | ----------- |
| Overall CVR    | -33.54      | 1.42 × 10⁻²⁴⁶ | Significant |
| Post-click CVR | +13.27      | 3.27 × 10⁻⁴⁰  | Significant |

The test was run in the order `[Control, Test]`, so a negative z means Test is higher and a positive z means Control is higher.

## What do these results tell us?

**1. Overall CVR — Negative Z-score**

The negative sign means:

$$CVR_{Test} > CVR_{Control}$$

The Test campaign has a significantly higher impression-to-purchase conversion rate (0.70% vs 0.48%).

**2. Post-click CVR — Positive Z-score**

The positive sign means:

$$PostClickCVR_{Control} > PostClickCVR_{Test}$$

The Control campaign has a significantly higher click-to-purchase conversion rate (9.83% vs 8.49%).

## The interesting business insight

The two metrics are telling different stories:

- Test is better at converting impressions into purchases.
- Control is better at converting website clicks into purchases.

This suggests that the Test campaign gets people to click more (175,107 clicks vs 154,303 on fewer impressions), but those clicks are less likely to end in a purchase. Control's clicks are fewer but more likely to purchase.

## Decision

The decision is based only on the two z-tests above.

**Step 1: Are the differences real?**
Both p-values are far below 0.05, so both differences are statistically significant and not due to chance.

**Step 2: Who wins each metric?**

| Question | Metric | Winner |
|---|---|---|
| Which campaign converts impressions into purchases better? | Overall CVR | Test (0.70% vs 0.48%) |
| Which campaign converts clicks into purchases better? | Post-click CVR | Control (9.83% vs 8.49%) |

**Step 3: Combine the two results**
The tests disagree, so neither campaign wins on both. Test's advantage comes from getting more people to click, not from clicks that convert better. Once someone has clicked, Control is the more effective campaign.

**Step 4: Decision**
Because the evidence is mixed, there is no clear case for moving budget to Test yet.

- **Retain Control** as the main campaign for now.
- **Need to Conduct further testing** on Test, focused on why its clicks convert less (landing page, audience quality).
- **Revisit shifting budget** if Test's post-click conversion improves to match Control's while keeping its higher overall CVR.After that one extra guardrail metric that is needed to be tested is CAC.

**Limitation:** this decision uses conversion metrics only.Cost per acquisition was calculated in the SQL step (Control $4.41, Test $5.02) but was not tested.
