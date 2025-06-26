/* What are the most in demand skills for my role?
    -Count of skills required for Data Analyst roles*/

SELECT
    skills AS skills_required,
    COUNT(*) AS skill_demanded_count
FROM job_postings2
GROUP BY
    skills_required
JOIN skills_job2 ON job_postings2.job_id = skills_job2.job_id
JOIN skills2 ON skills_job2.skill_id = skills2.skill_id
ORDER BY
    skill_demanded_count DESC
LIMIT 10