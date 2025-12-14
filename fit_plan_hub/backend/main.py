from fastapi import FastAPI
from database import Base, engine
from routes import auth, trainer, user
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI(title="Fit Plan Hub API")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

Base.metadata.create_all(bind=engine)
app.include_router(auth.router)
app.include_router(trainer.router)
app.include_router(user.router)