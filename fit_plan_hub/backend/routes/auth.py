from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from database import SessionLocal
from models.user import User
from schemas.user_schema import UserSignup, UserLogin, TokenResponse
from auth.jwt import hash_password,verify_password, create_access_token

router = APIRouter(prefix="/auth",tags=["Authentication"])
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.post("/signup")
def signup(user: UserSignup, db: Session = Depends(get_db)):
    if db.query(User).filter(User.mail_add == user.email).first():
        raise HTTPException(status_code=400, detail="Email Already Exists")
    
    new_user = User(
        u_name = user.name,
        mail_add = user.email,
        pass_hash = hash_password(user.password),
        u_role = user.role
    )
    db.add(new_user)
    db.commit()
    db.refresh(new_user)

    return {
        "success": True,
        "message":"User Created Successfully"
        }

@router.post("/login",response_model=TokenResponse)
def login(user: UserLogin, db: Session = Depends(get_db)):
    db_user = db.query(User).filter(User.mail_add == user.email).first()
    if not db_user or not verify_password(user.password, db_user.pass_hash):
        raise HTTPException(status_code=401, detail="Invalid Credentials")
    
    token = create_access_token({
        "user_id": db_user.id,
        "role": db_user.u_role
    })

    return {
        "success": True,
        "access_token": token
        }