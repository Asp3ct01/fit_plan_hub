from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from database import SessionLocal
from models.plan import FitnessPlan
from schemas.plan_schema import PlanCreate, PlanUpdate, PlanResponse
from auth.dependencies import trainer_only

router = APIRouter(prefix="/trainer", tags=["Trainer"])

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.post("/plans",response_model=PlanResponse)
def create_plan(
    plan: PlanCreate,
    db: Session = Depends(get_db),
    user= Depends(trainer_only)
):
    new_plan = FitnessPlan(
        trainer_id = user["user_id"],
        title =plan.title,
        p_description= plan.p_description,
        price= plan.price,
        duration_days = plan.duration_days
    )
    db.add(new_plan)
    db.commit()
    db.refresh(new_plan)
    return new_plan

@router.get("/plans",response_model=list[PlanResponse])
def get_my_plans(
    db: Session = Depends(get_db),
    user = Depends(trainer_only)
):
    return db.query(FitnessPlan).filter(FitnessPlan.trainer_id == user["user_id"]).all()

@router.put("/plans/{plan_id}",response_model=PlanResponse)
def update_plan(
    plan_id: int,
    plan: PlanUpdate,
    db: Session = Depends(get_db),
    user=Depends(trainer_only)
):
    db_plan = db.query(FitnessPlan).filter(
        FitnessPlan.id == plan_id , 
        FitnessPlan.trainer_id == user["user_id"]
).first()

    if not db_plan:
        raise HTTPException(status_code=404, detail="Plan Not Found")
    
    db_plan.title = plan.title
    db_plan.p_description = plan.p_description
    db_plan.price = plan.price
    db_plan.duration_days = plan.duration_days

    db.commit()
    db.refresh(db_plan)

    return db_plan

@router.delete("plans/{plan_id}")
def delete_plan(
    plan_id: int,
    db: Session = Depends(get_db),
    user=Depends(trainer_only)
):
    db_plan = db.query(FitnessPlan).filter(
        FitnessPlan.id == plan_id,
        FitnessPlan.trainer_id == user["user_id"]
    ).first()

    if not db_plan:
        raise HTTPException(status_code=404, detail="Plan Not Found")
    
    db.delete(db_plan)
    db.commit()
    return {
        "success": True,
        "message":"Plan deleted Successfully"
        }


