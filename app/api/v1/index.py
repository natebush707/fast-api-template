from fastapi import APIRouter
from app import schemas

router = APIRouter()


@router.get("")
def read_index():
    """
    Retrieve index
    """
    return {"Hello": "World"}