# Operations Runbook

## Health checks

- API health endpoint: `GET /health`
- ECS service health from target group and task status
- Background worker health from CloudWatch logs and queue throughput

## Common incidents

### API returns 5xx

1. Check ALB 5xx alarm.
2. Inspect API logs in `/ecs/<project>/api` log group.
3. Validate DB connectivity and secret values.

### Queue backlog grows

1. Check worker logs in `/ecs/<project>/worker`.
2. Scale worker desired count.
3. Verify Redis connectivity.

### RDS performance warning

1. Inspect RDS CPU alarm and connections.
2. Check slow queries.
3. Increase instance class if sustained pressure continues.

## Recovery drills

- Restart API service with `--force-new-deployment`.
- Restart worker service with `--force-new-deployment`.
- Run point-in-time restore drill monthly for RDS.
