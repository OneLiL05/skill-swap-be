import type { Routes } from '@/core/types/routes.js'
import { getCities } from '../handlers/index.js'

export const getCitiesRoutes = (): Routes => ({
	routes: [
		{
			method: 'GET',
			url: '/cities',
			handler: getCities,
		},
	],
})
