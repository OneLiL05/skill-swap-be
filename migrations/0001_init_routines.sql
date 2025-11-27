CREATE OR REPLACE PROCEDURE add_job_with_skills(
    p_name VARCHAR,
    p_description TEXT,
    p_salary NUMERIC(10, 2),
    p_cv_requirement VARCHAR,
    p_employment_type VARCHAR,
    p_work_location VARCHAR,
    p_status VARCHAR,
    p_eligibility VARCHAR,
    p_city_id UUID,
    p_position_id UUID,
    p_category_id UUID,
    p_skill_ids UUID[]
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_job_id UUID;
    v_skill_id UUID;
BEGIN
    IF p_salary < 0 THEN
        RAISE EXCEPTION 'NEGATIVE_SALARY: Salary cannot be negative. Provided value: %', p_salary
            USING ERRCODE = '22023';
    END IF;

    IF p_salary < 100 THEN
        RAISE EXCEPTION 'LOW_SALARY: Salary is too low. Minimum salary is 100. Provided value: %', p_salary
            USING ERRCODE = '22023';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM city WHERE id = p_city_id) THEN
        RAISE EXCEPTION 'CITY_NOT_FOUND: City with id % does not exist', p_city_id
            USING ERRCODE = '22023';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM position WHERE id = p_position_id) THEN
        RAISE EXCEPTION 'POSITION_NOT_FOUND: Position with id % does not exist', p_position_id
            USING ERRCODE = '22023';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM category WHERE id = p_category_id) THEN
        RAISE EXCEPTION 'CATEGORY_NOT_FOUND: Category with id % does not exist', p_category_id
            USING ERRCODE = '22023';
    END IF;

    INSERT INTO job (
        name, description, salary, cv_requirement, employment_type,
        work_location, status, eligibility, city_id, position_id, category_id
    ) VALUES (
        p_name, p_description, p_salary, p_cv_requirement, p_employment_type,
        p_work_location, p_status, p_eligibility, p_city_id, p_position_id, p_category_id
    ) RETURNING id INTO v_job_id;

    IF p_skill_ids IS NOT NULL AND array_length(p_skill_ids, 1) > 0 THEN
        FOREACH v_skill_id IN ARRAY p_skill_ids
        LOOP
            IF NOT EXISTS (SELECT 1 FROM skill WHERE id = v_skill_id) THEN
                RAISE EXCEPTION 'SKILL_NOT_FOUND: Skill with id % does not exist', v_skill_id
                    USING ERRCODE = '22023';
            END IF;

            INSERT INTO job_skill (job_id, skill_id)
            VALUES (v_job_id, v_skill_id);
        END LOOP;
    END IF;

    RAISE NOTICE 'Job created successfully with ID: %', v_job_id;
END;
$$;

CREATE OR REPLACE FUNCTION count_jobs_in_category(p_category_id UUID)
RETURNS INTEGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_count INTEGER;
BEGIN
    SELECT COUNT(*)
    INTO v_count
    FROM job
    WHERE category_id = p_category_id;

    RETURN v_count;
END;
$$;

CREATE OR REPLACE FUNCTION get_jobs_detailed(
    p_min_salary NUMERIC DEFAULT NULL,
    p_max_salary NUMERIC DEFAULT NULL,
    p_city_id UUID DEFAULT NULL,
    p_category_id UUID DEFAULT NULL,
    p_position_id UUID DEFAULT NULL
)
RETURNS TABLE (
    job_id UUID,
    job_name VARCHAR,
    job_description TEXT,
    salary NUMERIC,
    employment_type VARCHAR,
    work_location VARCHAR,
    status VARCHAR,
    city_id UUID,
    position_id UUID,
    position_name VARCHAR,
    category_id UUID,
    skills_count BIGINT,
    skill_names TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY
  SELECT
    j.id AS job_id,
    j.name AS job_name,
    j.description AS job_description,
    j.salary,
    j.employment_type,
    j.work_location,
    j.status,
    j.city_id,
    j.position_id,
    p.name AS position_name,
    j.category_id,
    COUNT(DISTINCT js.skill_id) AS skills_count,
    STRING_AGG(DISTINCT s.name, ', ' ORDER BY s.name) AS skill_names
  FROM job j
  LEFT JOIN position p ON j.position_id = p.id
  LEFT JOIN job_skill js ON j.id = js.job_id
  LEFT JOIN skill s ON js.skill_id = s.id
  WHERE
    (p_min_salary IS NULL OR j.salary >= p_min_salary)
    AND (p_max_salary IS NULL OR j.salary <= p_max_salary)
    AND (p_city_id IS NULL OR j.city_id = p_city_id)
    AND (p_category_id IS NULL OR j.category_id = p_category_id)
    AND (p_position_id IS NULL OR j.position_id = p_position_id)
  GROUP BY
    j.id, j.name, j.description, j.salary, j.employment_type,
    j.work_location, j.status, j.city_id, j.position_id,
    p.name, j.category_id
  ORDER BY j.created_at DESC;
END;
$$;

CREATE OR REPLACE FUNCTION get_job_full_info(p_job_id UUID)
RETURNS TABLE (
  job_id UUID,
  job_name VARCHAR,
  job_description TEXT,
  salary NUMERIC,
  cv_requirement VARCHAR,
  employment_type VARCHAR,
  work_location VARCHAR,
  status VARCHAR,
  eligibility VARCHAR,
  created_at TIMESTAMP WITH TIME ZONE,
  position_name VARCHAR,
  category_id UUID,
  city_id UUID,
  skill_id UUID,
  skill_name VARCHAR,
  skill_level VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY
  SELECT
    j.id AS job_id,
    j.name AS job_name,
    j.description AS job_description,
    j.salary,
    j.cv_requirement,
    j.employment_type,
    j.work_location,
    j.status,
    j.eligibility,
    j.created_at,
    p.name AS position_name,
    j.category_id,
    j.city_id,
    s.id AS skill_id,
    s.name AS skill_name,
    s.level AS skill_level
  FROM job j
  LEFT JOIN position p ON j.position_id = p.id
  LEFT JOIN job_skill js ON j.id = js.job_id
  LEFT JOIN skill s ON js.skill_id = s.id
  WHERE j.id = p_job_id;
END;
$$;

CREATE OR REPLACE FUNCTION get_category_statistics()
RETURNS TABLE (
  category_id UUID,
  jobs_count BIGINT,
  avg_salary NUMERIC,
  min_salary NUMERIC,
  max_salary NUMERIC
)
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY
  SELECT
    c.id AS category_id,
    COUNT(j.id) AS jobs_count,
    ROUND(AVG(j.salary), 2) AS avg_salary,
    MIN(j.salary) AS min_salary,
    MAX(j.salary) AS max_salary
  FROM category c
  LEFT JOIN job j ON c.id = j.category_id
  GROUP BY c.id
  ORDER BY jobs_count DESC;
END;
$$;
