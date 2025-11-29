import type { Routes } from '@/core/types/routes.js'
import { HEALTH_CHECK_SCHEMA } from '@/core/schemas/index.js'
import { getJobsRoutes } from './jobs/routes/index.js'
import { getCategoriesRoutes } from './categories/routes/index.js'
import { getCitiesRoutes } from './cities/routes/index.js'
import { getPositionsRoutes } from './positions/routes/index.js'
import { getSkillsRoutes } from './skills/routes/index.js'
import { getStatisticsRoutes } from './statistics/routes/index.js'

export const getRoutes = (): Routes => {
	return {
		routes: [
			{
				method: 'GET',
				url: '/health',
				handler: (_, reply) => {
					const data = {
						uptime: process.uptime(),
						message: 'Healthy!',
						date: new Date(),
					}

					return reply.status(200).send(data)
				},
				schema: {
					tags: ['System Check'],
					summary: 'Get system status',
					response: {
						200: HEALTH_CHECK_SCHEMA,
					},
				},
			},
			...getJobsRoutes().routes,
			...getCategoriesRoutes().routes,
			...getCitiesRoutes().routes,
			...getPositionsRoutes().routes,
			...getSkillsRoutes().routes,
			...getStatisticsRoutes().routes,
		],
	}
}
