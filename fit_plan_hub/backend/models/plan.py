#contains all the CRUD api for trainer

from sqlalchemy import Column, Integer, String, Text, ForeignKey, DECIMAL
from database import Base

class FitnessPlan(Base):
    __tablename__ = "fitness_plans"

    id = Column(Integer, primary_key= True, index= True)
    trainer_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    title = Column(String(100), nullable=False)
    p_description = Column(Text, nullable= False)
    price = Column(DECIMAL(8,2), nullable= False)
    duration_days = Column(Integer, nullable= False)
    