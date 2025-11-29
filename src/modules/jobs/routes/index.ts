import type { Routes } from '@/core/types/routes.js'
import { createJob, getJobDetails, getJobs } from '../handlers/index.js'

export const getJobsRoutes = (): Routes => ({
	routes: [
		{
			method: 'GET',
			url: '/jobs',
			handler: getJobs,
		},
		{
			method: 'GET',
			url: '/jobs/:id',
			handler: getJobDetails,
		},
		{
			method: 'POST',
			url: '/jobs',
			handler: createJob,
		},
	],
})
