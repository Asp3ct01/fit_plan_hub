# fit_plan_hub

A new Flutter project as per described in the Shared document.


## Features
- User authentication and authorization  
- Browse available fitness plans  
- View detailed plan information  
- Select and manage your fitness plans  
- Responsive Flutter UI for mobile devices  
- RESTful API backend with FastAPI  

## Technology Stack
### Frontend
- Flutter Web
- Dart
- HTTP package for API calls
- setState for state management

### Backend
- FastAPI
- Python
- JWT Authentication
- Pydantic for validation
- SQLAlchemy ORM

### Database
- MySQL


## Setup Instructions

### Backend (FastAPI)
cd backend
python -m venv venv
source venv/bin/activate
venv\Scripts\activate  
pip install -r requirements.txt
uvicorn main:app --reload

### Frontend
cd fit_plan_hub
flutter pub get
flutter run
