-- Starter schema for graduation tracking

CREATE TABLE students (
  id UUID PRIMARY KEY,
  district_student_id TEXT UNIQUE NOT NULL,
  first_name TEXT NOT NULL,
  last_name TEXT NOT NULL,
  expected_cohort_year INT NOT NULL,
  school_code TEXT,
  grade_level INT,
  created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

CREATE TABLE courses (
  id UUID PRIMARY KEY,
  local_course_code TEXT NOT NULL,
  title TEXT NOT NULL,
  subject_area TEXT NOT NULL,
  credit_value NUMERIC(4,2) NOT NULL,
  is_cte BOOLEAN DEFAULT FALSE NOT NULL,
  is_dual_credit BOOLEAN DEFAULT FALSE NOT NULL,
  UNIQUE(local_course_code)
);

CREATE TABLE course_attempts (
  id UUID PRIMARY KEY,
  student_id UUID NOT NULL REFERENCES students(id),
  course_id UUID NOT NULL REFERENCES courses(id),
  term_code TEXT NOT NULL,
  school_year TEXT NOT NULL,
  grade_mark TEXT,
  credits_earned NUMERIC(4,2) DEFAULT 0 NOT NULL,
  passed BOOLEAN DEFAULT FALSE NOT NULL,
  repeated_attempt_no INT DEFAULT 1 NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

CREATE TABLE graduation_rulesets (
  id UUID PRIMARY KEY,
  ruleset_key TEXT UNIQUE NOT NULL,
  jurisdiction TEXT NOT NULL,
  cohort_year INT NOT NULL,
  effective_date DATE NOT NULL,
  payload JSONB NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

CREATE TABLE student_hsbp_events (
  id UUID PRIMARY KEY,
  student_id UUID NOT NULL REFERENCES students(id),
  event_code TEXT NOT NULL,
  event_date DATE NOT NULL,
  evidence JSONB,
  created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

CREATE TABLE student_pathway_evidence (
  id UUID PRIMARY KEY,
  student_id UUID NOT NULL REFERENCES students(id),
  pathway_type TEXT NOT NULL,
  status TEXT NOT NULL,
  evidence JSONB,
  verified_by TEXT,
  verified_at TIMESTAMPTZ
);

CREATE TABLE graduation_audits (
  id UUID PRIMARY KEY,
  student_id UUID NOT NULL REFERENCES students(id),
  ruleset_id UUID NOT NULL REFERENCES graduation_rulesets(id),
  audit_status TEXT NOT NULL,
  risk_score INT NOT NULL,
  unmet_requirements JSONB NOT NULL,
  recommendations JSONB,
  run_at TIMESTAMPTZ DEFAULT NOW() NOT NULL
);
