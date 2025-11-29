import { sql } from 'drizzle-orm'
import type { FastifyReply, FastifyRequest } from 'fastify'
import type {
	CvRequirement,
	EmploymentType,
	JobAligibility,
	JobStatus,
} from '../constants/index.js'

export const getJobs = async (
	request: FastifyRequest<{
		Querystring: {
			minSalary: number
			maxSalary: number
			cityId: string
			categoryId: string
			positionId: string
		}
	}>,
	reply: FastifyReply,
): Promise<void> => {
	const { minSalary, maxSalary, cityId, categoryId, positionId } = request.query
	const { db } = request.diScope.cradle

	const jobs = await db.client.execute(
		sql`select * from get_jobs_detailed(
			${minSalary || sql`null`},
			${maxSalary || sql`null`},
			${cityId || sql`null`},
			${categoryId || sql`null`},
			${positionId || sql`null`}
		)`,
	)

	return reply.status(200).send(jobs)
}

export const getJobDetails = async (
	request: FastifyRequest<{ Params: { id: string } }>,
	reply: FastifyReply,
): Promise<void> => {
	const { id } = request.params
	const { db } = request.diScope.cradle

	const result = await db.client.execute(
		sql`select * from get_job_full_info(${id})`,
	)

	return reply.status(200).send(result.at(0))
}

export const createJob = async (
	request: FastifyRequest<{
		Body: {
			name: string
			description: string
			salary: number
			cvRequirement: CvRequirement
			employmentType: EmploymentType
			workLocation: string
			status: JobStatus
			aligibility: JobAligibility
			cityId: string
			positionId: string
			categoryId: string
			skillIds: string[]
		}
	}>,
	reply: FastifyReply,
): Promise<void> => {
	const {
		name,
		description,
		salary,
		cvRequirement,
		employmentType,
		workLocation,
		status,
		aligibility,
		cityId,
		positionId,
		categoryId,
		skillIds,
	} = request.body
	const { db } = request.diScope.cradle

	try {
		await db.client.execute(
			sql`call add_job_with_skills(${name}::VARCHAR, ${description}::TEXT, ${salary}::NUMERIC(10, 2), ${cvRequirement}::VARCHAR, ${employmentType}::VARCHAR, ${workLocation}::VARCHAR, ${status}::VARCHAR, ${aligibility}::VARCHAR, ${cityId}::UUID, ${positionId}::UUID, ${categoryId}::UUID, ARRAY[${sql.join(skillIds, sql`, `)}]::uuid[])`,
		)
	} catch (error: unknown) {
		// @ts-expect-error assume error is PostgresError
		return reply.status(500).send({ message: error.cause.message })
	}

	return reply.status(201).send()
}
