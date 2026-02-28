# API Service

HTTP ingress service responsible for:

- health reporting (`GET /health`)
- job submission (`POST /jobs`)
- job state retrieval (`GET /jobs/{job_id}`)

## Runtime contract

- Persists job metadata in PostgreSQL.
- Enqueues background execution requests to Redis-backed RQ.
- Uses environment-driven configuration through `app/config.py`.

## Quality gates

- Unit checks run in CI via `pytest -q`.
- Syntax guard via `python -m py_compile app/*.py`.
