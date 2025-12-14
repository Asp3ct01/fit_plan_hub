from passlib.context import CryptContext
from jose import jwt
from datetime import datetime, timedelta

SECRET_KEY = "my-secret-token"
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_IN_MIN = 60

pwd_context = CryptContext(schemes=["bcrypt"], deprecated = "auto")

def hash_password(password: str):
    print("Password Length plain", len(password))
    return pwd_context.hash(password)

def verify_password(password, hashed):
    return pwd_context.verify(password,hashed)


def create_access_token(data: dict):
    to_encode = data.copy()
    expire = datetime.utcnow() + timedelta(minutes=ACCESS_TOKEN_EXPIRE_IN_MIN)
    to_encode.update({"exp": expire})
    return jwt.encode(to_encode,SECRET_KEY,algorithm=ALGORITHM)