import { relations, sql } from 'drizzle-orm'
import { pgTable } from 'drizzle-orm/pg-core'
import { cityTable } from './city.js'
import { positionTable } from './position.js'
import { categoryTable } from './category.js'

export const jobTable = pgTable('job', (t) => ({
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
	name: t.varchar().notNull(),
	description: t.text().notNull(),
	salary: t.numeric({ precision: 10, scale: 2 }).notNull(),
	cvRequirement: t.varchar().notNull(),
	employmentType: t.varchar().notNull(),
	workLocation: t.varchar().notNull(),
	status: t.varchar().notNull(),
	eligibility: t.varchar().notNull(),
	cityId: t
		.uuid()
		.notNull()
		.references(() => cityTable.id, {
			onDelete: 'cascade',
			onUpdate: 'cascade',
		}),
	positionId: t
		.uuid()
		.notNull()
		.references(() => positionTable.id, {
			onDelete: 'cascade',
			onUpdate: 'cascade',
		}),
	categoryId: t
		.uuid()
		.notNull()
		.references(() => categoryTable.id, {
			onDelete: 'cascade',
			onUpdate: 'cascade',
		}),
}))

export const jobTableRelations = relations(jobTable, ({ one }) => ({
	category: one(categoryTable, {
		fields: [jobTable.categoryId],
		references: [categoryTable.id],
	}),
	city: one(cityTable, {
		fields: [jobTable.cityId],
		references: [cityTable.id],
	}),
	position: one(positionTable, {
		fields: [jobTable.positionId],
		references: [positionTable.id],
	}),
}))
