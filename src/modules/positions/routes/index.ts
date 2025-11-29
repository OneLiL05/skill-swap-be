import type { Routes } from '@/core/types/index.js'
import { getPositions } from '../handlers/index.js'

export const getPositionsRoutes = (): Routes => ({
	routes: [
		{
			method: 'GET',
			url: '/positions',
			handler: getPositions,
		},
	],
})
