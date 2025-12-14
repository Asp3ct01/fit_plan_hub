from pydantic import BaseModel
from decimal import Decimal

class PlanCreate(BaseModel):
    title: str
    p_description: str
    price: Decimal
    duration_days : int

class PlanUpdate(BaseModel):
    title: str
    p_description: str
    price: Decimal
    duration_days : int

class PlanResponse(BaseModel):
    id: int
    title: str
    p_description: str
    price: Decimal
    duration_days : int

    class Config:
        orm_mode = True