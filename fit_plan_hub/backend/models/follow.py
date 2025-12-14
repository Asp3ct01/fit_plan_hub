from sqlalchemy import Column, Integer, ForeignKey
from database import Base

class TrainerFollower(Base):
    __tablename__ = "trainer_followers"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    trainer_id = Column(Integer, ForeignKey("users.id"), nullable=False)