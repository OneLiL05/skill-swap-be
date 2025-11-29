import { positionTable } from '@/db/schema/position.js'
import type { FastifyReply, FastifyRequest } from 'fastify'

export const getPositions = async (
	request: FastifyRequest,
	reply: FastifyReply,
): Promise<void> => {
	const { db } = request.diScope.cradle

	const positions = await db.client
		.select()
		.from(positionTable)
		.orderBy(positionTable.name)

	return reply.status(200).send(positions)
}
