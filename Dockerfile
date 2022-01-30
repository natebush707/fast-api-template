##########################################################
# Base image
##########################################################
FROM python:3.11.0a4-alpine3.15 as python-base

# set environment variables
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=off \
    PIP_DISABLE_PIP_VERSION_CHECK=on \
    PIP_DEFAULT_TIMEOUT=100 \
    POETRY VERSION=1.1.5 \
    POETRY_HOME="/opt/poetry" \
    POETRY_VIERTUALENVS_IN_PROJECT=true \
    POETRY_NO_INTERACTION=1 \
    PYSETUP_PATH="/opt/pysetup" \
    VENV_PATH="/opt/pysetup/.venv"

# prepend poetry and venv to path
ENV PATH="$POETRY_HOME/bin:$VENV_PATH/bin:$PATH"



##########################################################
# Builder image
##########################################################
FROM python-base as builder-base

# update base image
RUN apk update \
    && apk add --upgrade apk-tools \
    && apk --no-cache add curl \
    && apk upgrade --available

# install poetry
RUN curl -sSL https://raw.githubusercontent.com/sdispater/poetry/master/get-poetry.py | python

# copy project requirement files for caching
WORKDIR $PYSETUP_PATH
COPY poetry.lock pyproject.toml ./

# install dependencies
RUN poetry install --no-dev 



##########################################################
# Production image
##########################################################
FROM python-base as production
COPY --from=builder-base $PYSETUP_PATH $PYSETUP_PATH
COPY ./app /app/

# setup non-root user
RUN adduser -DH dockeruser && chown -R dockeruser /app

# Uset new non-root user
USER dockeruser

# run the application
CMD ["python", "-m", "app.main"]