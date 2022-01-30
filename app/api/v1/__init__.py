from fastapi import APIRouter

from app.api.v1 import index

api_router = APIRouter()
api_router.include_router(index.router, prefix="/test", tags=["test"])