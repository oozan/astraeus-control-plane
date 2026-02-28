from functools import lru_cache

from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    app_name: str = "Astraeus Control Plane API"
    environment: str = "development"
    api_port: int = 8080

    database_url: str = "postgresql+psycopg2://cloud:cloud@db:5432/cloud"
    redis_url: str = "redis://redis:6379/0"

    auto_create_schema: bool = True
    queue_name: str = "job_queue"

    model_config = SettingsConfigDict(env_file=".env", env_file_encoding="utf-8", extra="ignore")


@lru_cache

def get_settings() -> Settings:
    return Settings()
