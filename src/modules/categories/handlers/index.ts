import { categoryTable } from '@/db/schema/category.js'
import { sql } from 'drizzle-orm'
import type { FastifyReply, FastifyRequest } from 'fastify'

export const getCategories = async (
	request: FastifyRequest,
	reply: FastifyReply,
): Promise<void> => {
	const { db } = request.diScope.cradle

	const positions = await db.client
		.select()
		.from(categoryTable)
		.orderBy(categoryTable.name)

	return reply.status(200).send(positions)
}

export const getCategoryJobsCount = async (
	request: FastifyRequest<{ Params: { id: string } }>,
	reply: FastifyReply,
): Promise<void> => {
	const { id } = request.params
	const { db } = request.diScope.cradle

	const result = await db.client.execute(
		sql`select count_jobs_in_category(${id}) as count`,
	)

	return reply.status(200).send(result.at(0))
}
