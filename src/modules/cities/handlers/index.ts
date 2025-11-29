import { cityTable } from '@/db/schema/city.js'
import type { FastifyReply, FastifyRequest } from 'fastify'

export const getCities = async (
	request: FastifyRequest,
	reply: FastifyReply,
): Promise<void> => {
	const { db } = request.diScope.cradle

	const cities = await db.client
		.select()
		.from(cityTable)
		.orderBy(cityTable.name)

	return reply.status(200).send(cities)
}
