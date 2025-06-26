--CREATE COPIES OF ORIGINAL TABLES SO AS NOT TO ALTER RAW DATA (incase we have to use the raw data later on)
CREATE COPY OF ORIGINAL TABLES SO AS NOT TO ALTER RAW DATA
CREATE TABLE company_copy AS
SELECT * FROM company;

CREATE TABLE job_postings_copy AS
SELECT * FROM job_postings;

CREATE TABLE skills_job_copy AS
SELECT * FROM skills_job;

CREATE TABLE skills_copy AS
SELECT * FROM skills;

--CHECK FOR DUPLICATES AND REMOVE IF THERE ARE ANY

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
