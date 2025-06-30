# Introduction
This project focuses on diving into the world of data science 📊 to explore the highest-paying 💰 and most in-demand 🔥 skills for data analyst roles in the United States.

Checkout the SQL queries here:[Project_sql folder](/Project_sql/)
# Background
As the demand for data-driven decision-making continues to accelerate across industries, understanding the dynamics of the data analyst labor market has never been more important. This project investigates the intersection of wages, skills, and employer demand for data analyst roles in the United States, providing an evidence-based perspective grounded in rigorous analysis.

Drawing on principles of labor economics and human capital theory, this project utilizes SQL to systematically analyze the dataset with the aim of answering five key questions:

1️⃣ What are the top-paying data analyst jobs in the United States?

2️⃣ What skills are required for these high-paying positions?

3️⃣ Which skills are most in demand across the entire dataset?

4️⃣ Which skills are associated with the highest average salaries?

5️⃣ What are the most optimal skills to develop, balancing both market demand and salary potential?

By addressing these questions, the project contributes actionable insights into which competencies best position data analysts to maximize both employability and earning potential. This analysis not only helps individuals make informed investments in their human capital but also provides a snapshot of the evolving skill demands in the U.S. labor market for data professionals.

Datasource [job_postings](https://www.kaggle.com/datasets/lukebarousse/data-analyst-job-postings-google-search)

# Tools I used
- **PostgreSQL**: served as the main database to store and organize the job postings data, allowing efficient execution of complex SQL queries.

- **VS Code**: used as the development environment to write, test, and refine SQL queries, with helpful extensions for database integration and query management.

- **GitHub**: provided a platform to document and share the project, ensuring transparency, reproducibility, and easy collaboration.

# Analysis
The questions in this project were answered systematically from the first question to the last. Below is an overview of how I approached answering each question:

After loading the dataset into VS Code, I first created a copy of the dataset so as not to run queries on the original dataset. I then checked for duplicate entries and I cleaned them all using the queries below;

```sql
--company_copy
CREATE TABLE company2
(
    company_id INT,
    name TEXT,
    link TEXT,
    link_google TEXT,
    thumbnail TEXT
);

WITH ct AS (
  SELECT *,
         ROW_NUMBER() OVER (
           PARTITION BY name, link, link_google, thumbnail
           ORDER BY company_id
         ) AS rn
  FROM company_copy
)
INSERT INTO company2
SELECT company_id, name, link, link_google, thumbnail
FROM ct
WHERE rn = 1;

--job_posting_copy
CREATE TABLE job_postings2
(
    job_id INT,
    company_id INT,
    job_title_short VARCHAR(100),
    job_title TEXT,
    job_location TEXT,
    job_via TEXT,
    job_schedule_type TEXT,
    job_work_from_home BOOLEAN,
    search_location TEXT,
    job_posted_date TIMESTAMP,
    job_no_degree_mention BOOLEAN,
    job_health_insurance BOOLEAN,
    job_country TEXT,
    salary_rate TEXT,
    salary_year_avg NUMERIC,
    salary_hour_avg NUMERIC
);

WITH ct AS (
  SELECT *,
         ROW_NUMBER() OVER (
           PARTITION BY company_id, job_title_short, job_title, job_location,
                        job_via, job_schedule_type, job_work_from_home,
                        search_location, job_posted_date, job_no_degree_mention,
                        job_health_insurance, job_country, salary_rate,
                        salary_year_avg, salary_hour_avg
           ORDER BY job_id
         ) AS rn
  FROM job_postings_copy
)
INSERT INTO job_postings2
SELECT job_id, company_id, job_title_short, job_title, job_location, job_via,
       job_schedule_type, job_work_from_home, search_location, job_posted_date,
       job_no_degree_mention, job_health_insurance, job_country,
       salary_rate, salary_year_avg, salary_hour_avg
FROM ct
WHERE rn = 1;


--skills_job_copy
CREATE TABLE skills_job2
(
    job_id INT,
    skill_id INT
);

WITH ct AS (
  SELECT *,
         ROW_NUMBER() OVER (
           PARTITION BY job_id, skill_id
           ORDER BY job_id
         ) AS rn
  FROM skills_job_copy
)
INSERT INTO skills_job2
SELECT job_id, skill_id
FROM ct
WHERE rn = 1;


--skills_copy
CREATE TABLE skills2
(
    skill_id INT,
    skills TEXT,
    type TEXT
);

WITH ct AS (
  SELECT *,
         ROW_NUMBER() OVER (
           PARTITION BY skills, type
           ORDER BY skill_id
         ) AS rn
  FROM skills_copy
)
INSERT INTO skills2
SELECT skill_id, skills, type
FROM ct
WHERE rn = 1;
```

### 1️⃣ What are the top-paying data analyst jobs in the United States?
To find an answer to this question, I filtered the dataset for full-time data analyst jobs that were located in the United States based on the average yearly salary.
```sql
SELECT
    job.job_id,
    job.job_title_short AS title_of_job,
    company2.name AS hiring_company,
    job.job_country AS country,
    ROUND(job.salary_year_avg,0) AS yearly_salary

FROM job_postings2 AS job

LEFT JOIN company2 ON job.company_id = company2.company_id

WHERE
    job_title_short = 'Data Analyst'
    AND job_country = 'United States'
    AND job_schedule_type = 'Full-time'
    AND salary_year_avg IS NOT NULL

ORDER BY salary_year_avg DESC
LIMIT 15;
```
Below is the result for the top_paying data analyst jobs:

![Top Paying Data Analyst Jobs in the United States](images\1.png)
*Table above shows the top 15 full-time data analyst jobs in the United States*

### 2️⃣ What skills are required for these high-paying positions?
I used some the queries from the first question and I joined the table that has the skills to the job postings table (via the company_id column) to answer this question.
```sql
WITH top_paying_US_jobs AS (
SELECT
    job.job_id,
    job.job_title_short AS title_of_job,
    company2.name AS hiring_company,
    job.job_country AS country,
    ROUND(job.salary_year_avg,0) AS yearly_salary

FROM job_postings2 AS job

LEFT JOIN company2 ON job.company_id = company2.company_id

WHERE
    job_title_short = 'Data Analyst'
    AND job_country = 'United States'
    AND job_schedule_type = 'Full-time'
    AND salary_year_avg IS NOT NULL

ORDER BY yearly_salary DESC

LIMIT 15)

SELECT 
    top_paying_US_jobs.*,
    skills2.skills AS skills_required

FROM top_paying_US_jobs

JOIN skills_job2 ON top_paying_US_jobs.job_id = skills_job2.job_id
JOIN skills2 ON skills_job2.skill_id = skills2.skill_id

ORDER BY yearly_salary DESC
LIMIT 15;
```
Below is the result for the skills required for the jobs from question 1:
![Skills Required for Top Data Analyst jobs](images\2.png)
*Table above shows the skills required for full-time top paying data analyst roles in the United States.*

### 3️⃣ Which skills are most in demand across the entire dataset?
I used an aggregate function to count the amount of times skills related to data analyst jobs were included in job descriptions for the United States.
```sql
SELECT
    skills2.skills AS skills_required,
    COUNT(skills_job2.job_id) AS skills_demanded_count

FROM job_postings2 AS job
    
JOIN skills_job2 ON job.job_id = skills_job2.job_id
JOIN skills2 ON skills_job2.skill_id = skills2.skill_id

WHERE
    job_title_short = 'Data Analyst'
    AND job_country = 'United States'
    AND job_schedule_type = 'Full-time'

GROUP BY
    skills

ORDER BY
    skills_demanded_count DESC
LIMIT 15;
```
Below is the result to question 3 above:
![Most Demanded Skills for Data Analyst Jobs](images\3.png)
*Table above shows the most demanded skills for full_time data analyst jobs in the United States.*

### 4️⃣ Which skills are associated with the highest average salaries?
I used some portion of the previous query to rank the skills associated with the highest salaries for data analyst jobs in the United States.
```sql
SELECT
    skills2.skills AS skills_required,
    ROUND(AVG(job.salary_year_avg),0) AS average_salary

FROM job_postings2 AS job
    
JOIN skills_job2 ON job.job_id = skills_job2.job_id
JOIN skills2 ON skills_job2.skill_id = skills2.skill_id

WHERE
    job_title_short = 'Data Analyst'
    AND job_country = 'United States'
    AND job_schedule_type = 'Full-time'
    AND salary_year_avg IS NOT NULL

GROUP BY
    skills

ORDER BY
    average_salary DESC
LIMIT 15;
```
Below is the result for the skills that pay the most for data analyst roles:
![Top Paying Skills](images\4.png)
*Table above shows the skills that pay the most for full_time data analyst jobs in the United States.*
### 5️⃣ What are the most optimal skills to develop, balancing both market demand and salary potential?
I fine tuned previous queries to rank the most optimal skills to learn for data analyst jobs in the United States based on demand and average yearly salary.
```sql
SELECT
    skills2.skill_id,
    skills2.skills AS skills_required,
    COUNT(skills_job2.job_id) AS skills_demanded_count,
    ROUND(AVG(job.salary_year_avg),0) AS average_salary
    
FROM job_postings2 AS job
    
JOIN skills_job2 ON job.job_id = skills_job2.job_id
JOIN skills2 ON skills_job2.skill_id = skills2.skill_id

WHERE
    job_title_short = 'Data Analyst'
    AND job_country = 'United States'
    AND job_schedule_type = 'Full-time'
    AND salary_year_avg IS NOT NULL
GROUP BY
    skills2.skill_id,
    skills2.skills
ORDER BY
    skills_demanded_count DESC
LIMIT 15;
```
Below is the result for the most optimal skills:
![Most Optimal Skills to Learn](images\5.png)
*Table above shows the most optimal skills to learn for full-time data analyst jobs in the United States.
# Conclusion

### 🔎Insights
Through systematic analysis of United States data analyst job postings, several key patterns emerged:

**Top-Paying Roles**: The highest salaries for full_time data analysts jobs are with major companies, reflecting the premium placed on experienced professionals with specialized skills. The highest salary based on my queries was 375000.

**Skills in Demand**: Tools like SQL, Python, Tableau and Excel consistently ranked among the most requested skills, underscoring their importance as foundational tools for data analysts.

**Highest-Paying Skills**: Skills associated with data engineering, cloud platforms, and advanced analytics—such as Solidity, Dplyr, and machine learning libraries—were linked with higher average salaries, highlighting the value of technical versatility.

**Optimal Skills to Learn**: Balancing demand and salary potential pointed to a set of core skills, including SQL, Python, and data visualization tools, that offer both strong marketability and competitive compensation for aspiring data analysts.
### Final Thoughts
This project demonstrates how leveraging publicly available job postings data can yield meaningful, data-driven guidance for career planning in the field of data analytics. By integrating economic reasoning with practical SQL analysis, it highlights the intersection of labor market trends and individual skill investments. Future research could extend these insights by incorporating time-series analysis to track changing skill demands over time or by conducting comparative studies across regions to understand geographic variations in skill preferences.