from contextlib import asynccontextmanager

from fastapi import Depends, FastAPI, HTTPException
from sqlalchemy.orm import Session

from app.config import get_settings
from app.db import get_db, init_db
from app.models import Job
from app.queue_client import get_queue
from app.schemas import JobCreateRequest, JobResponse

settings = get_settings()


@asynccontextmanager
async def lifespan(_: FastAPI):
    if settings.auto_create_schema:
        try:
            init_db()
        except Exception:
            # Startup stays resilient for environments where DB may initialize later.
            pass
    yield


app = FastAPI(title=settings.app_name, lifespan=lifespan)


@app.get("/health")
def health_check() -> dict[str, str]:
    return {"status": "ok", "environment": settings.environment}


@app.post("/jobs", response_model=JobResponse, status_code=201)
def create_job(request: JobCreateRequest, db: Session = Depends(get_db)) -> Job:
    job = Job(status="queued", payload=request.payload)
    db.add(job)
    db.commit()
    db.refresh(job)

    queue = get_queue()
    queue.enqueue("worker.process_job", str(job.id))

    return job


@app.get("/jobs/{job_id}", response_model=JobResponse)
def get_job(job_id: str, db: Session = Depends(get_db)) -> Job:
    job = db.get(Job, job_id)
    if not job:
        raise HTTPException(status_code=404, detail="Job not found")
    return job
