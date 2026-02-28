# Worker Service

Background execution component responsible for:

- consuming queued jobs from Redis/RQ
- executing async processing logic
- updating job lifecycle state in PostgreSQL (`queued`, `processing`, `completed`, `failed`)

## Operational notes

- Deploys independently from the API service.
- Can be scaled by changing ECS desired count for backlog control.
- Emits logs to a dedicated CloudWatch log group in AWS deployments.
