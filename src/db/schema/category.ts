import { relations, sql } from 'drizzle-orm'
import { pgTable } from 'drizzle-orm/pg-core'
import { jobTable } from './job.js'

export const categoryTable = pgTable('category', (t) => ({
	id: t
		.uuid()
		.primaryKey()
		.default(sql`uuidv7()`),
	createdAt: t.timestamp({ withTimezone: true }).defaultNow().notNull(),
	updatedAt: t
		.timestamp({ withTimezone: true })
		.defaultNow()
		.notNull()
		.$onUpdateFn(() => new Date()),
	name: t.varchar().notNull().unique(),
}))

export const categoryTableRelations = relations(categoryTable, ({ many }) => ({
	jobs: many(jobTable),
}))
