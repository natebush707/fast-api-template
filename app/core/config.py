import secrets

from pydantic import BaseSettings

class Settings(BaseSettings):
    API_V1_STR: str = "/backend/api/v1"
    PROJECT_NAME: str = "Ego Peek"
    PORT: int = 5000

    class Config:
        env_file = ".env"


settings = Settings()