/* What are the most in demand skills for my role and job type?
    -Count of skills required for Data Analyst roles*/

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