import { sql } from 'drizzle-orm'
import { pgTable } from 'drizzle-orm/pg-core'

export const skillTable = pgTable('skill', (t) => ({
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
	level: t.varchar().notNull(),
}))
