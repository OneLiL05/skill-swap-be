import type { Routes } from '@/core/types/routes.js'
import { getSkills } from '../handlers/index.js'

export const getSkillsRoutes = (): Routes => ({
	routes: [
		{
			method: 'GET',
			url: '/skills',
			handler: getSkills,
		},
	],
})
