INSERT INTO position (name) VALUES
  ('Junior Developer'),
  ('Middle Developer'),
  ('Senior Developer'),
  ('Lead Developer'),
  ('Tech Lead'),
  ('Principal Engineer'),
  ('Junior QA Engineer'),
  ('Middle QA Engineer'),
  ('Senior QA Engineer'),
  ('QA Lead'),
  ('Junior DevOps Engineer'),
  ('Middle DevOps Engineer'),
  ('Senior DevOps Engineer'),
  ('DevOps Lead'),
  ('Junior Data Scientist'),
  ('Middle Data Scientist'),
  ('Senior Data Scientist'),
  ('Data Science Lead'),
  ('Junior Product Manager'),
  ('Senior Product Manager'),
  ('Project Manager'),
  ('Scrum Master'),
  ('Business Analyst'),
  ('UI/UX Designer'),
  ('Graphic Designer')
ON CONFLICT (name) DO NOTHING;

DO $$
DECLARE
  i INTEGER;
BEGIN
  FOR i IN 1..10 LOOP
    INSERT INTO category DEFAULT VALUES;
  END LOOP;
END $$;

DO $$
DECLARE
  i INTEGER;
BEGIN
  FOR i IN 1..15 LOOP
    INSERT INTO city DEFAULT VALUES;
  END LOOP;
END $$;

INSERT INTO skill (name, level) VALUES
  ('JavaScript', 'Advanced'),
  ('TypeScript', 'Advanced'),
  ('React', 'Advanced'),
  ('Angular', 'Advanced'),
  ('Vue.js', 'Advanced'),
  ('HTML5', 'Advanced'),
  ('CSS3', 'Advanced'),
  ('Sass/SCSS', 'Intermediate'),
  ('Tailwind CSS', 'Intermediate'),
  ('Bootstrap', 'Intermediate'),
  ('Next.js', 'Advanced'),
  ('Redux', 'Intermediate'),
  ('Webpack', 'Intermediate'),
  ('Node.js', 'Advanced'),
  ('Express.js', 'Advanced'),
  ('Python', 'Advanced'),
  ('Django', 'Advanced'),
  ('Flask', 'Intermediate'),
  ('FastAPI', 'Advanced'),
  ('Java', 'Advanced'),
  ('Spring Boot', 'Advanced'),
  ('C#', 'Advanced'),
  ('.NET Core', 'Advanced'),
  ('Go', 'Advanced'),
  ('Ruby', 'Intermediate'),
  ('Rails', 'Intermediate'),
  ('PHP', 'Intermediate'),
  ('Laravel', 'Intermediate'),
  ('PostgreSQL', 'Advanced'),
  ('MySQL', 'Advanced'),
  ('MongoDB', 'Advanced'),
  ('Redis', 'Advanced'),
  ('Elasticsearch', 'Intermediate'),
  ('Cassandra', 'Intermediate'),
  ('Oracle', 'Intermediate'),
  ('Docker', 'Advanced'),
  ('Kubernetes', 'Advanced'),
  ('AWS', 'Advanced'),
  ('Azure', 'Advanced'),
  ('Google Cloud', 'Advanced'),
  ('Jenkins', 'Intermediate'),
  ('GitLab CI/CD', 'Advanced'),
  ('Terraform', 'Advanced'),
  ('Ansible', 'Intermediate'),
  ('Machine Learning', 'Advanced'),
  ('Deep Learning', 'Advanced'),
  ('TensorFlow', 'Advanced'),
  ('PyTorch', 'Advanced'),
  ('Pandas', 'Advanced'),
  ('NumPy', 'Advanced'),
  ('Scikit-learn', 'Intermediate'),
  ('Data Analysis', 'Advanced'),
  ('Data Visualization', 'Intermediate'),
  ('Git', 'Advanced'),
  ('GitHub', 'Advanced'),
  ('Jira', 'Intermediate'),
  ('Agile', 'Advanced'),
  ('Scrum', 'Advanced'),
  ('REST API', 'Advanced'),
  ('GraphQL', 'Advanced'),
  ('Microservices', 'Advanced'),
  ('Testing', 'Advanced'),
  ('Jest', 'Intermediate'),
  ('Pytest', 'Intermediate')
ON CONFLICT (name) DO NOTHING;

DO $$
DECLARE
  job_titles TEXT[] := ARRAY[
    'Full Stack Developer',
    'Frontend Developer',
    'Backend Developer',
    'React Developer',
    'Node.js Developer',
    'Python Developer',
    'Java Developer',
    '.NET Developer',
    'DevOps Engineer',
    'QA Automation Engineer',
    'Data Scientist',
    'Machine Learning Engineer',
    'Product Manager',
    'Project Manager',
    'UI/UX Designer',
    'Mobile Developer',
    'Cloud Architect',
    'Security Engineer',
    'Database Administrator',
    'System Administrator'
  ];

  job_descriptions TEXT[] := ARRAY[
    'We are looking for a talented professional to join our growing team. You will work on exciting projects using cutting-edge technologies.',
    'Join our innovative team and help build next-generation applications. Great opportunity for career growth and learning.',
    'Seeking an experienced developer to work on challenging projects. Competitive salary and excellent benefits package.',
    'Looking for a passionate developer who loves clean code and modern technologies. Remote-friendly environment.',
    'Join our startup and make real impact. Work with latest technologies and contribute to product vision.',
    'We need a skilled professional to enhance our development team. Flexible working hours and great work-life balance.',
    'Exciting opportunity to work on enterprise-level applications. Collaborative environment with talented colleagues.',
    'Be part of our mission to revolutionize the industry. Innovative projects and modern tech stack.',
    'Join a fast-growing company with ambitious goals. Opportunity to learn from industry experts.',
    'We are building the future of technology. Join us on this exciting journey!'
  ];

  work_locations TEXT[] := ARRAY['Office', 'Remote', 'Hybrid'];
  employment_types TEXT[] := ARRAY['Full-time', 'Part-time', 'Contract', 'Freelance'];
  statuses TEXT[] := ARRAY['Active', 'Active', 'Active', 'Active', 'Closed']; -- 80% активних
  position_ids UUID[];
  category_ids UUID[];
  city_ids UUID[];
  skill_ids UUID[];

  i INTEGER;
  random_title TEXT;
  random_description TEXT;
  random_salary NUMERIC;
  random_position_id UUID;
  random_category_id UUID;
  random_city_id UUID;
  random_employment TEXT;
  random_location TEXT;
  random_status TEXT;
  selected_skills UUID[];
  skill_count INTEGER;
  j INTEGER;
BEGIN
  SELECT ARRAY_AGG(id) INTO position_ids FROM position;
  SELECT ARRAY_AGG(id) INTO category_ids FROM category;
  SELECT ARRAY_AGG(id) INTO city_ids FROM city;
  SELECT ARRAY_AGG(id) INTO skill_ids FROM skill;

  FOR i IN 1..120 LOOP
    random_title := job_titles[(random() * (array_length(job_titles, 1) - 1) + 1)::INTEGER];
    random_description := job_descriptions[(random() * (array_length(job_descriptions, 1) - 1) + 1)::INTEGER];
    random_salary := (random() * 8000 + 1500)::NUMERIC(10, 2); -- Від 1500 до 9500
    random_position_id := position_ids[(random() * (array_length(position_ids, 1) - 1) + 1)::INTEGER];
    random_category_id := category_ids[(random() * (array_length(category_ids, 1) - 1) + 1)::INTEGER];
    random_city_id := city_ids[(random() * (array_length(city_ids, 1) - 1) + 1)::INTEGER];
    random_employment := employment_types[(random() * (array_length(employment_types, 1) - 1) + 1)::INTEGER];
    random_location := work_locations[(random() * (array_length(work_locations, 1) - 1) + 1)::INTEGER];
    random_status := statuses[(random() * (array_length(statuses, 1) - 1) + 1)::INTEGER];

    skill_count := (random() * 5 + 2)::INTEGER;
    selected_skills := ARRAY[]::UUID[];

    FOR j IN 1..skill_count LOOP
      selected_skills := array_append(
        selected_skills,
        skill_ids[(random() * (array_length(skill_ids, 1) - 1) + 1)::INTEGER]
      );
    END LOOP;

    selected_skills := ARRAY(SELECT DISTINCT unnest(selected_skills));

    IF i > 20 THEN
      random_title := random_title || ' - Position ' || i;
    END IF;

    BEGIN
      CALL add_job_with_skills(
          random_title,
          random_description || ' Project ID: JOB-' || LPAD(i::TEXT, 4, '0'),
          random_salary,
          CASE WHEN random() > 0.5 THEN 'Required' ELSE 'Optional' END,
          random_employment,
          random_location,
          random_status,
          'Open to all',
          random_city_id,
          random_position_id,
          random_category_id,
          selected_skills
      );

      IF i % 10 = 0 THEN
          RAISE NOTICE 'Created % jobs...', i;
      END IF;

      EXCEPTION
        WHEN OTHERS THEN
          RAISE NOTICE 'Error creating job %: %', i, SQLERRM;
      END;
  END LOOP;

  RAISE NOTICE 'Successfully created 120 job postings!';
END $$;

DO $$
DECLARE
  v_category_id UUID;
  v_city_id UUID;
  v_position_senior UUID;
  v_position_junior UUID;
  v_skill_js UUID;
  v_skill_react UUID;
  v_skill_node UUID;
  v_skill_python UUID;
  v_skill_docker UUID;
  v_skill_k8s UUID;
BEGIN
  SELECT id INTO v_category_id FROM category LIMIT 1;
  SELECT id INTO v_city_id FROM city LIMIT 1;
  SELECT id INTO v_position_senior FROM position WHERE name = 'Senior Developer' LIMIT 1;
  SELECT id INTO v_position_junior FROM position WHERE name = 'Junior Developer' LIMIT 1;

  SELECT id INTO v_skill_js FROM skill WHERE name = 'JavaScript' LIMIT 1;
  SELECT id INTO v_skill_react FROM skill WHERE name = 'React' LIMIT 1;
  SELECT id INTO v_skill_node FROM skill WHERE name = 'Node.js' LIMIT 1;
  SELECT id INTO v_skill_python FROM skill WHERE name = 'Python' LIMIT 1;
  SELECT id INTO v_skill_docker FROM skill WHERE name = 'Docker' LIMIT 1;
  SELECT id INTO v_skill_k8s FROM skill WHERE name = 'Kubernetes' LIMIT 1;

  CALL add_job_with_skills(
    'Senior Architect - High Salary',
    'Elite position for experienced architect. Lead major initiatives and mentor team members. Excellent compensation package.',
    15000.00,
    'Required',
    'Full-time',
    'Remote',
    'Active',
    'Open to all',
    v_city_id,
    v_position_senior,
    v_category_id,
    ARRAY[v_skill_js, v_skill_react, v_skill_node, v_skill_docker, v_skill_k8s]
  );

  CALL add_job_with_skills(
    'Intern Developer',
    'Great opportunity for students to gain real-world experience. Work with experienced team and learn modern technologies.',
    800.00,
    'Optional',
    'Part-time',
    'Office',
    'Active',
    'Students only',
    v_city_id,
    v_position_junior,
    v_category_id,
    ARRAY[v_skill_js, v_skill_react]
  );

  CALL add_job_with_skills(
    'Full Stack Lead Engineer',
    'Looking for a versatile engineer with broad skill set. You will work on complex projects requiring knowledge of multiple technologies.',
    9500.00,
    'Required',
    'Full-time',
    'Hybrid',
    'Active',
    'Open to all',
    v_city_id,
    v_position_senior,
    v_category_id,
    ARRAY[v_skill_js, v_skill_react, v_skill_node, v_skill_python, v_skill_docker, v_skill_k8s]
  );

  RAISE NOTICE 'Created special test jobs!';
END $$;

RAISE NOTICE '';
RAISE NOTICE '==================================================';
RAISE NOTICE 'SEED COMPLETED SUCCESSFULLY!';
RAISE NOTICE 'Total Jobs Created: %', (SELECT COUNT(*) FROM job);
RAISE NOTICE 'Total Skills: %', (SELECT COUNT(*) FROM skill);
RAISE NOTICE 'Total Positions: %', (SELECT COUNT(*) FROM position);
RAISE NOTICE '==================================================';
