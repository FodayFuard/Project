/*Questions: 1.	What are the top-paying jobs for my role in the US?
    -What are the highest paying Data Analyst jobs in the US?
    -Which companies are these jobs from?
    -Which ones are available Full-time?
    -Only include jobs that have a salary value
    -Only include relevant columns*/

SELECT
    job.job_id,
    job.job_title_short AS title_of_job,
    company2.name AS hiring_company,
    job.job_country AS country,
    job.job_location AS city_state,
    job.job_schedule_type AS schedule,
    ROUND(job.salary_year_avg,0) AS yearly_salary

FROM job_postings2 AS job

LEFT JOIN company2 ON job.company_id = company2.company_id

WHERE
    job_title_short = 'Data Analyst'
    AND job_country = 'United States'
    AND job_schedule_type = 'Full-time'
    AND salary_year_avg IS NOT NULL

ORDER BY salary_year_avg DESC
;