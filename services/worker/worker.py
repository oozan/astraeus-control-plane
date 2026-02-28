from datetime import datetime

from redis import Redis
from rq import Connection, Queue, Worker

from app.config import get_settings
from app.db import get_session_factory
from app.models import Job

settings = get_settings()


def process_job(job_id: str) -> None:
    db = get_session_factory()()
    try:
        job = db.get(Job, job_id)
        if not job:
            return

        job.status = "processing"
        job.updated_at = datetime.utcnow()
        db.commit()

        payload = job.payload or {}
        text = str(payload.get("text", ""))
        result = {
            "original_payload": payload,
            "text_length": len(text),
            "word_count": len([w for w in text.split(" ") if w]),
            "processed_at": datetime.utcnow().isoformat(),
        }

        job.status = "completed"
        job.result = result
        job.updated_at = datetime.utcnow()
        db.commit()
    except Exception as exc:
        if 'job' in locals() and job:
            job.status = "failed"
            job.result = {"error": str(exc)}
            job.updated_at = datetime.utcnow()
            db.commit()
        raise
    finally:
        db.close()


def run_worker() -> None:
    redis_conn = Redis.from_url(settings.redis_url)
    with Connection(redis_conn):
        worker = Worker([Queue(settings.queue_name)])
        worker.work()


if __name__ == "__main__":
    run_worker()
