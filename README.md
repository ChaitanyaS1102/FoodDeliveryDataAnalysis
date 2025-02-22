# FetchFood A/B Testing Project

## 1. Background
FetchFood is a start-up based in Seattle, WA, connecting restaurants and grocery stores with customers. Unlike other food delivery platforms, FetchFood allows drivers to cancel delivery jobs without conditions. However, driver cancellations negatively impact both FetchFood and the partnered businesses financially.

To mitigate this issue, FetchFood launched an experiment to test three different cancellation penalties:
- **$0 (Control Group)**
- **$10 (Treatment 1)**
- **$20 (Treatment 2)**

Our goal is to determine the optimal cancellation penalty to balance long-term growth and short-term profit maximization using A/B testing methodologies.

## 2. Data
The experiment data is stored in two CSV files: **Order File** and **Penalty File**.

### Order File
Contains order-related information with the following columns:
1. `order.id` - Unique identifier for the order.
2. `driver.id` - Unique identifier for the driver.
3. `business.type` - Type of business (restaurant or grocery).
4. `expected.profit` - Expected profit if the order is not canceled.
5. `order.placed.time` - Timestamp when the order was placed.
6. `delivery.completed.time` - Timestamp when the order was completed.
7. `cancel.dummy` - Indicator variable (1 if the order was canceled, 0 otherwise).

### Penalty File
Contains details on penalty assignments for drivers:
1. `driver.id` - Unique identifier for the driver.
2. `penalty.variant` - Assigned cancellation penalty fee ($0, $10, or $20). **50% of the fee goes to FetchFood, and 50% to the restaurant/grocery.**

## 3. Task
As data scientists, our task is to analyze the experiment data to determine the optimal cancellation penalty. Our approach will involve:
- Performing **A/B testing** to compare the impact of different penalty levels.
- Identifying **key metrics** to evaluate the business impact.
- Ensuring the analysis is robust, insightful, and actionable.

## 4. Project Teams
- Teams should consist of **three students**.
- If the class size is not divisible by three, teams of **two students** will be allowed.
- Submit your team list by **October 31st, 11:59 PM**.

## 5. Submission
Each team must submit:
- **Presentation slides** (PDF format)
- **R code (.Rmd) or Python code (.ipynb)**

Submit files via email to **ezhang2@seattleu.edu** by **December 4th, 11:59 PM**. Ensure all code outputs are clearly visible.

## 6. Presentation Details
- **Date:** December 5th
- **Session 1:** 9:20 AM - 12:00 PM
- **Session 2:** 2:05 PM - 4:45 PM
- **Duration:** 18-minute presentation + 2-minute Q&A
- The presentation order will be announced later.

## 7. Grading Criteria
| Component                 | Weight |
|---------------------------|--------|
| Analysis (A/B testing, ML methods) | 70%    |
| Presentation (clarity, insights)   | 30%    |

Key assessment points:
- **Technical Soundness:** Proper A/B testing and/or machine learning techniques.
- **Structure & Clarity:** Clear explanation of methodology and findings.
- **Business Insights:** Addressing real-world risks and challenges.
- **Professionalism:** Well-structured, professional slides and reports.

## 8. Key Considerations
While working on this project, consider the following:
1. **What is the business impact of imposing a cancellation fee?**
2. **Which metrics best quantify this impact?**
3. **Are there differences between short-term and long-term effects?**
4. **What is the final recommendation for the CEO?**

---

### 🚀 Let's find the optimal cancellation penalty and drive FetchFood's growth! 🚀
