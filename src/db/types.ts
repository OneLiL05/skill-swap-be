import type { categoryTable } from './schema/category.js'

type Category = typeof categoryTable.$inferSelect

export type { Category }
