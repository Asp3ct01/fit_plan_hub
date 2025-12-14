from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from database import SessionLocal
from models.plan import FitnessPlan
from models.subscription import Subscription
from models.follow import TrainerFollower
from auth.dependencies import user_only

router = APIRouter(prefix="/user",tags=["User"])

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.get("/plans")
def view_plans(
    db:Session = Depends(get_db),
    user= Depends(user_only)
):
    plans =db.query(FitnessPlan).all()

    subscribed_plans_ids = {
        s.plan_id for s in db.query(Subscription).filter(Subscription.user_id == user["user_id"]).all()
    }

    response = []
    for plan in plans:
        data = {
            "id": plan.id,
            "title": plan.title,
            "price" : plan.price,
            "duration_days" : plan.duration_days
        }

        if plan.id in subscribed_plans_ids:
            data["p_description"] = plan.p_description
        else:
            data["p_description"] = "Subscribe to view full details"

        response.append(data)

    return response

@router.post("/plans/{plan_id}/subscribe")
def subscribe_plan(
    plan_id: int,
    db: Session = Depends(get_db),
    user = Depends(user_only)
):
    if db.query(Subscription).filter(
        Subscription.user_id == user["user_id"], 
        Subscription.plan_id == plan_id
    ).first():
        raise HTTPException(status_code=400,detail = "Already Subscribed")
    
    subscription = Subscription(
        user_id = user["user_id"],
        plan_id = plan_id
    )

    db.add(subscription)
    db.commit()

    return {
        "success": True,
        "message": "Subscribed Successfully"
        }

@router.post("/trainers/{trainer_id}/follow")
def follow_trainer(
    trainer_id: int,
    db: Session = Depends(get_db),
    user=Depends(user_only)
):
    if db.query(TrainerFollower).filter(
        TrainerFollower.user_id == user["user_id"],
        TrainerFollower.trainer_id == trainer_id
    ).first():
        raise HTTPException(status_code=400, detail="Already following")
    
    follow = TrainerFollower(
        user_id=user["user_id"],
        trainer_id=trainer_id
    )

    db.add(follow)
    db.commit()

    return {
        "success": True,
        "message" : "Trainer followed"
        }

@router.delete("/trainer/{trainer_id}/unfollow")
def unfollow_trainer(
    trainer_id: int,
    db: Session = Depends(get_db),
    user = Depends(user_only)
):
    follow = db.query(TrainerFollower).filter(
        TrainerFollower.user_id == user["user_id"],
        TrainerFollower.trainer_id == trainer_id
    ).first()

    if not follow:
        raise HTTPException(status_code=404, detail = "Not Following")
    
    db.delete(follow)
    db.commit()

    return {
        "success": True,
        "message": "Trainer unfollowed"
        }

@router.get("/feed")
def user_feed(
    db: Session = Depends(get_db),
    user = Depends(user_only)
):
    follow_trainers = [ f.trainer_id for f in db.query(TrainerFollower).filter(
        TrainerFollower.user_id == user["user_id"]
    ).all()
    ]

    plans = db.query(FitnessPlan).filter(
        FitnessPlan.trainer_id.in_(follow_trainers)
    ).all()

    subscribed_plan_ids = {
        s.plan_id for s in db.query(Subscription).filter(
            Subscription.user_id == user["user_id"]
        ).all()
    }

    response = []
    for plan in plans:
        response.append({
            "id": plan.id,
            "title" : plan.title,
            "trainer_id": plan.trainer_id,
            "price" : plan.price,
            "subscribed" : plan.id in subscribed_plan_ids
        })

    return response