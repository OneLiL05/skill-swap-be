import { skillTable } from '@/db/schema/skill.js'
import type { FastifyReply, FastifyRequest } from 'fastify'

export const getSkills = async (
	request: FastifyRequest,
	reply: FastifyReply,
): Promise<void> => {
	const { db } = request.diScope.cradle

	const skills = await db.client
		.select()
		.from(skillTable)
		.orderBy(skillTable.name)

	return reply.status(200).send(skills)
}
