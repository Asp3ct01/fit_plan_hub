from sqlalchemy import Column, Integer, String, Enum
from database import Base

class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key = True, index=True)
    u_name = Column(String(100), nullable = False)
    mail_add = Column(String(100), nullable = False)
    pass_hash = Column(String(255), nullable= False)
    u_role = Column(Enum("user","trainer"), nullable = False)

