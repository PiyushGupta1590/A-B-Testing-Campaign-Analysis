```python
import numpy as np
from scipy.stats import norm

# Data from the Colab notebook's clean_table.csv
# Control (row 0), Test (row 1)
x1, n1_imp, n1_clk = 15161, 3177233, 154303
x2, n2_imp, n2_clk = 14869, 2123249, 175107

# 1. Overall CVR (Purchases / Impressions)
p1_imp = x1 / n1_imp
p2_imp = x2 / n2_imp
p_pool_imp = (x1 + x2) / (n1_imp + n2_imp)
se_imp = np.sqrt(p_pool_imp * (1 - p_pool_imp) * (1/n1_imp + 1/n2_imp))
z_imp = (p1_imp - p2_imp) / se_imp
pval_imp = 2 * (1 - norm.cdf(abs(z_imp)))

print("--- OVERALL CVR ---")
print(f"p1 (Control): {p1_imp:.8f} ({p1_imp*100:.4f}%)")
print(f"p2 (Test):    {p2_imp:.8f} ({p2_imp*100:.4f}%)")
print(f"p_pool:       {p_pool_imp:.8f}")
print(f"SE:           {se_imp:.10f}")
print(f"Z-score:      {z_imp:.6f}")
print(f"P-value:      {pval_imp:.6e}")

# 2. Post-Click CVR (Purchases / Website Clicks)
p1_clk = x1 / n1_clk
p2_clk = x2 / n2_clk
p_pool_clk = (x1 + x2) / (n1_clk + n2_clk)
se_clk = np.sqrt(p_pool_clk * (1 - p_pool_clk) * (1/n1_clk + 1/n2_clk))
z_clk = (p1_clk - p2_clk) / se_clk
pval_clk = 2 * (1 - norm.cdf(abs(z_clk)))

print("\n--- POST-CLICK CVR ---")
print(f"p1 (Control): {p1_clk:.8f} ({p1_clk*100:.4f}%)")
print(f"p2 (Test):    {p2_clk:.8f} ({p2_clk*100:.4f}%)")
print(f"p_pool:       {p_pool_clk:.8f}")
print(f"SE:           {se_clk:.10f}")
print(f"Z-score:      {z_clk:.6f}")
print(f"P-value:      {pval_clk:.6e}")


```

```text
--- OVERALL CVR ---
p1 (Control): 0.00477176 (0.4772%)
p2 (Test):    0.00700295 (0.7003%)
p_pool:       0.00566552
SE:           0.0000665302
Z-score:      -33.536414
P-value:      0.000000e+00

--- POST-CLICK CVR ---
p1 (Control): 0.09825473 (9.8255%)
p2 (Test):    0.08491380 (8.4914%)
p_pool:       0.09116299
SE:           0.0010050363
Z-score:      13.274085
P-value:      0.000000e+00


```

To find the **Z-score** and **P-value** mathematically for comparing two groups in your `clean_table.csv` dataset, you use a **Two-Proportion Z-Test**. This test checks whether the difference between the conversion rates of your **Control** group (row `0`) and **Test** group (row `1`) is statistically significant or just due to random chance.

### The Core Formulas

Let:

* $x_1, x_2$ = Number of successes (**Purchases**) in Control and Test
* $n_1, n_2$ = Total number of trials (**Impressions** or **Website Clicks**) in Control and Test

1. **Sample Proportions ($\hat{p}_1, \hat{p}_2$):**

$$\hat{p}_1 = \frac{x_1}{n_1}, \quad \hat{p}_2 = \frac{x_2}{n_2}$$


2. **Pooled Sample Proportion ($\hat{p}_{\text{pool}}$):**
Under the null hypothesis ($H_0: p_1 = p_2$), both groups share the same underlying conversion rate, so we combine them:

$$\hat{p}_{\text{pool}} = \frac{x_1 + x_2}{n_1 + n_2}$$


3. **Standard Error ($SE$):**
Measures the expected random variation between the two proportions:

$$SE = \sqrt{\hat{p}_{\text{pool}} (1 - \hat{p}_{\text{pool}}) \left(\frac{1}{n_1} + \frac{1}{n_2}\right)}$$


4. **Z-Score ($Z$):**
Measures how many standard errors apart the two sample proportions are (note that `statsmodels` computes $\text{Control} - \text{Test}$):

$$Z = \frac{\hat{p}_1 - \hat{p}_2}{SE}$$


5. **Two-Tailed P-Value:**
The probability of observing a Z-score at least as extreme as $\vert{}Z\vert{}$ under a standard normal distribution ($\Phi$ is the cumulative distribution function):

$$\text{P-value} = 2 \times \left(1 - \Phi(\vert{}Z\vert{})\right)$$

Where $\text{CDF}(z)$ is the Cumulative Distribution Function (CDF) of the Standard Normal Distribution—a bell curve with a mean ($\mu$) of $0$ and a standard deviation ($\sigma$) of $1$. 

The CDF, denoted as $\Phi(z)$, is the total area under that bell curve from $-\infty$ up to your $z$-score:

$$
\Phi(z) = P(Z \le z) = \int_{-\infty}^{z} \frac{1}{\sqrt{2\pi}} e^{-\frac{x^2}{2}} \, dx
$$


### Calculation 1: Overall CVR (`Purchases / Impressions`)

From your table:

* **Control (Group 1):** $x_1 = 15,161$, $n_1 = 3,177,233$
* **Test (Group 2):** $x_2 = 14,869$, $n_2 = 2,123,249$

**Step 1: Individual Proportions**


$$\hat{p}_1 = \frac{15,161}{3,177,233} \approx 0.00477176 \quad (0.48\%)$$

$$\hat{p}_2 = \frac{14,869}{2,123,249} \approx 0.00700295 \quad (0.70\%)$$

**Step 2: Pooled Proportion**


$$\hat{p}_{\text{pool}} = \frac{15,161 + 14,869}{3,177,233 + 2,123,249} = \frac{30,030}{5,300,482} \approx 0.00566552$$

**Step 3: Standard Error**


$$SE = \sqrt{0.00566552 \times (1 - 0.00566552) \times \left(\frac{1}{3,177,233} + \frac{1}{2,123,249}\right)}$$

$$SE = \sqrt{0.00563342 \times (3.1474 \times 10^{-7} + 4.7098 \times 10^{-7})} \approx 0.00006653$$

**Step 4: Z-Score**


$$Z = \frac{0.00477176 - 0.00700295}{0.00006653} = \frac{-0.00223119}{0.00006653} \approx \mathbf{-33.54}$$


*(Matches your notebook output: `-33.5364`)*

**Step 5: P-Value**
Looking up $\vert{}Z\vert{} = 33.54$ on a standard normal curve puts it 33.5 standard deviations away from the mean—far beyond the standard threshold of $\vert{}Z\vert{} = 1.96$ (for $\alpha = 0.05$):


$$\text{P-value} = 2 \times \left(1 - \Phi(33.5364)\right) \approx \mathbf{1.42 \times 10^{-246}}$$

---

### Calculation 2: Post-Click CVR (`Purchases / Website_Clicks`)

From your table:

* **Control (Group 1):** $x_1 = 15,161$, $n_1 = 154,303$
* **Test (Group 2):** $x_2 = 14,869$, $n_2 = 175,107$

**Step 1: Individual Proportions**


$$\hat{p}_1 = \frac{15,161}{154,303} \approx 0.09825473 \quad (9.83\%)$$

$$\hat{p}_2 = \frac{14,869}{175,107} \approx 0.08491380 \quad (8.49\%)$$

**Step 2: Pooled Proportion**


$$\hat{p}_{\text{pool}} = \frac{15,161 + 14,869}{154,303 + 175,107} = \frac{30,030}{329,410} \approx 0.09116299$$

**Step 3: Standard Error**


$$SE = \sqrt{0.09116299 \times (1 - 0.09116299) \times \left(\frac{1}{154,303} + \frac{1}{175,107}\right)}$$

$$SE = \sqrt{0.08285230 \times (6.4808 \times 10^{-6} + 5.7108 \times 10^{-6})} \approx 0.00100504$$

**Step 4: Z-Score**


$$Z = \frac{0.09825473 - 0.08491380}{0.00100504} = \frac{0.01334093}{0.00100504} \approx \mathbf{13.27}$$


*(Matches your notebook output: `13.2741`)*

**Step 5: P-Value**
With $\vert{}Z\vert{} = 13.27$ (again well past $1.96$):


$$\text{P-value} = 2 \times \left(1 - \Phi(13.2741)\right) \approx \mathbf{3.27 \times 10^{-40}}$$
---

### What These Numbers Mean Together

| Metric | Control | Test | Z-Score | P-Value | Interpretation |
| --- | --- | --- | --- | --- | --- |
| **Overall CVR** | 0.48% | 0.70% | **-33.54** | $1.42 \times 10^{-246}$ | **Test wins significantly** (negative Z because Control is lower than Test) |
| **Post-Click CVR** | 9.83% | 8.49% | **+13.27** | $3.27 \times 10^{-40}$ | **Control wins significantly** (positive Z because Control is higher than Test) |

Because both p-values are practically zero (much smaller than $0.05$), neither difference is random noise. The Test campaign drove a much higher **click-through rate** from impressions (lifting Overall CVR), but the traffic it brought converted at a slightly lower rate once on the website (lowering Post-Click CVR).
