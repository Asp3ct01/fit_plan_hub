from fastapi import Depends, HTTPException
# from fastapi.security import OAuth2PasswordBearer
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from jose import jwt
from auth.jwt import SECRET_KEY, ALGORITHM

# oauth2_scheme = OAuth2PasswordBearer(tokenUrl="/auth/login")
security = HTTPBearer()

# def get_current_user(token: str = Depends(oauth2_scheme)):
def get_current_user(credentials: HTTPAuthorizationCredentials = Depends(security)): 
    token = credentials.credentials
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        return payload
    except:
        raise HTTPException(status_code=401,detail="Invalid Token")
    

def trainer_only(user=Depends(get_current_user)):
    if user.get("role") != "trainer":
        raise HTTPException(status_code=403, detail="Trainer Access Required")
    return user

def user_only(user=Depends(get_current_user)):
    if user.get("role") != "user":
        raise HTTPException(status_code=403, detail="User Access Required")
    return user