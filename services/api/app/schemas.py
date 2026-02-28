from datetime import datetime
from uuid import UUID

from pydantic import BaseModel, ConfigDict, Field


class JobCreateRequest(BaseModel):
    payload: dict = Field(default_factory=dict)


class JobResponse(BaseModel):
    id: UUID
    status: str
    payload: dict
    result: dict | None
    created_at: datetime
    updated_at: datetime

    model_config = ConfigDict(from_attributes=True)
