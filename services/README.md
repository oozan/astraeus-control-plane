# Services

Application runtime is split into independently deployable services with clear operational boundaries:

- `api`: synchronous ingress, request validation, persistence, and queue publication.
- `worker`: asynchronous processing and status/result updates.

Each service has its own container image and lifecycle, while sharing platform configuration conventions and observability patterns.
