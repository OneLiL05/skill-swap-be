import type { Routes } from '@/core/types/routes.js'
import { getCategoriesStatistics } from '../handlers/index.js'

export const getStatisticsRoutes = (): Routes => ({
	routes: [
		{
			method: 'GET',
			url: '/statistics/categories',
			handler: getCategoriesStatistics,
		},
	],
})
