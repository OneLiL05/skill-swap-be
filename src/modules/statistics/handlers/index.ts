import type { FastifyReply, FastifyRequest } from 'fastify'

export const getCategoriesStatistics = async (
	request: FastifyRequest,
	reply: FastifyReply,
): Promise<void> => {
	const { db } = request.diScope.cradle

	const statistics = await db.client.execute(
		`SELECT * FROM get_category_statistics()`,
	)

	return reply.status(200).send(statistics)
}
