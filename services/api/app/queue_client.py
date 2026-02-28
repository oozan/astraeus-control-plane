from app.config import get_settings

settings = get_settings()


def get_queue():
    from redis import Redis
    from rq import Queue

    redis_conn = Redis.from_url(settings.redis_url)
    return Queue(settings.queue_name, connection=redis_conn)
