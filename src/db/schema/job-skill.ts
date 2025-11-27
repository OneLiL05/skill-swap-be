import { pgTable } from 'drizzle-orm/pg-core'
import { jobTable } from './job.js'
import { skillTable } from './skill.js'

export const jobSkillTable = pgTable('job_skill', (t) => ({
	jobId: t
		.uuid()
		.notNull()
		.references(() => jobTable.id, { onDelete: 'cascade' }),
	skillId: t
		.uuid()
		.notNull()
		.references(() => skillTable.id, { onDelete: 'cascade' }),
}))
