import type { Routes } from '@/core/types/routes.js'
import { getCategories, getCategoryJobsCount } from '../handlers/index.js'

export const getCategoriesRoutes = (): Routes => ({
	routes: [
		{
			method: 'GET',
			url: '/categories',
			handler: getCategories,
		},
		{
			method: 'GET',
			url: '/categories/:id/jobs-count',
			handler: getCategoryJobsCount,
		},
	],
})
