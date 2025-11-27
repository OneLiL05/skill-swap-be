const EMPLOYMENT_TYPE = {
	FULL_TIME: 'full-time',
	PART_TIME: 'part-time',
	CONTRACT: 'contract',
	INTERNSHIP: 'internship',
} as const

type EmploymentType = (typeof EMPLOYMENT_TYPE)[keyof typeof EMPLOYMENT_TYPE]

const CV_REQUIREMENT = {
	REQUIRED: 'required',
	OPTIONAL: 'optional',
	NOT_REQUIRED: 'not-required',
} as const

type CvRequirement = (typeof CV_REQUIREMENT)[keyof typeof CV_REQUIREMENT]

const JOB_STATUS = {
	OPEN: 'open',
	CLOSED: 'closed',
	DRAFT: 'draft',
} as const

type JobStatus = (typeof JOB_STATUS)[keyof typeof JOB_STATUS]

const JOB_ALIGIBILITY = {
	ALL: 'all',
	PROFESSIONALS_ONLY: 'professionals-only',
	STUDENTS_ALLOWED: 'students-allowed',
} as const

type JobAligibility = (typeof JOB_ALIGIBILITY)[keyof typeof JOB_ALIGIBILITY]

export { EMPLOYMENT_TYPE, CV_REQUIREMENT, JOB_STATUS, JOB_ALIGIBILITY }
export type { EmploymentType, CvRequirement, JobStatus, JobAligibility }
