/*Questions: 1. What are the skills required for these top-paying roles?
    -Use the results from the previous one
    -Just add the skills needed*/
   
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