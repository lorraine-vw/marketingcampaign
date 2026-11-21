Marketing Campaign Analysis: Who Should We Target Next?

- Tools: PostgreSQL (DBeaver), Tableau Public
- Data: [Marketing Campaign dataset on Kaggle](https://www.kaggle.com/datasets/rodsaldanha/arketing-campaign), 2,240 customers
- Dashboard: [add Tableau Public link here]

Business question

A company ran six marketing campaigns. Which customers are most likely to respond, and who should the next campaign target?

I focused on the **last campaign** (the `response` column). It is the best guide to how customers respond now. The first five campaigns were used for context only.

Summary of findings

- 14.9% of customers accepted the last offer. That is about double the best earlier campaign (7.5%), so I used 14.9% as the baseline.
- **Income** is the strongest driver. Customers earning $70k or more respond far more than everyone else.
- **Education and kids at home** looked important at first, but a lot of that was income. When I compared customers within the same income group, the education pattern mostly disappeared.
- **Not being partnered** and **having no teens at home** still mattered after accounting for income.
- Combining the three traits (income of $70k or more, not partnered, no teens at home) works as a simple targeting score:

| Favorable traits | Response rate |
|---|---|
| 0 | 6.5% |
| 2 | 20.8% |
| 3 | 49.7% (145 customers) |

Customers with all three traits responded at more than three times the 14.9% average.

Recommendation

1. **Prioritize** customers with income of $70k or more, who are not partnered, and have no teens at home.
2. **Next tier:** customers with two of the three traits (20.8%).
3. **De-emphasize** customers with none of the traits (6.5%).
4. **Messaging:** responders spend the most on wine and meat, so lead with those, and consider the catalog channel. This part is suggestive only, because I did not test whether spend and catalog use simply reflect higher income.

How the analysis went

1. **Checked the data first.** Null counts for every column, duplicate IDs, value ranges, and the values in categorical columns.
2. **Made cleaning decisions.** Rows are never deleted. Each query that needs a filter has it in the `where` clause (see below).
3. **Looked at one factor at a time:** campaigns, kids, teens, education, marital status, income, age, spending, and purchase channels.
4. **Checked for confounding.** Education and kids at home might just reflect income, so I split each one within income groups (under $70k vs. $70k and over) and compared again. Groups smaller than 30 customers were dropped.
5. **Built the favorable-traits score** from the factors that held up, and checked how response changed with each added trait.

Data cleaning decisions

| Issue | Customers | Decision |
|---|---|---|
| Missing income | 24 (1.1%) | Assumed not reported, since nobody has an income of 0. Excluded from income analysis only. |
| Income outlier (666,666; next highest is 162,397) | 1 | Excluded from income analysis only. |
| Impossible birth years (1893, 1899, 1900) | 3 | Excluded from age analysis only. |
| Marital status `Absurd` and `YOLO` | a few | Excluded from marital analysis. `Alone` merged with `Single`. |

- Queries that do not use income or age use all 2,240 customers.
- The 14.9% baseline is calculated on all customers. Income-based queries use the filtered group, which is slightly smaller.
- Age is calculated as 2014 minus birth year. The dataset does not state a collection date, so I used the year of the latest enrollment date in the data.


Limitations

- **This shows association, not causation.** These patterns describe who responded. They do not prove that a trait made someone respond.
- **Small groups.** Some groups (for example two kids at home, about 48 customers) are too small to read.
- **One campaign.** The recommendation is based on the last campaign only. I did not test whether the same traits predict response in campaigns 1 to 5.
- **No significance testing.** I compared rates and group sizes but did not run statistical tests.
- **Public dataset.** The data is from Kaggle and may be synthetic or simplified, so results would need to be checked against real customer data.


