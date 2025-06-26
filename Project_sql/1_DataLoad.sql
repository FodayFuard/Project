-- Creating company table
CREATE TABLE company
(
    company_id INT,
    name TEXT,
    link TEXT,
    link_google TEXT,
    thumbnail TEXT
);

-- Creating job_postings table
CREATE TABLE job_postings
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

-- Creating skills_job table
CREATE TABLE skills_job
(
    job_id INT,
    skill_id INT
);


-- Creating skills table
CREATE TABLE skills
(
    skill_id INT,
    skills TEXT,
    type TEXT
);


/* I now copy data from the csv files
in my computer to the tables created above*/

COPY company
FROM 'C:\Project\company.csv'
DELIMITER ',' CSV HEADER;

COPY skills
FROM 'C:\Project\skills.csv'
DELIMITER ',' CSV HEADER;

COPY job_postings
FROM 'C:\Project\job_postings.csv'
DELIMITER ',' CSV HEADER;

COPY skills_job
FROM 'C:\Project\skills_job.csv'
DELIMITER ',' CSV HEADER;



