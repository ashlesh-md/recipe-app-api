FROM python:3.9-alpine3.13

ENV PYTHONUNBUFFERED 1

# Debugging statements
RUN echo "Step 1: Setting up Python environment variables"
COPY requirements.txt /tmp/requirements.txt
COPY requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app
WORKDIR /app
EXPOSE 8000

RUN echo "Step 2: Creating Python virtual environment"
RUN python -m venv /py

RUN echo "Step 3: Upgrading pip and installing dependencies"
ARG DEV=false
RUN /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = "true"]; \
    then /py/bin/pip install -r /tmp/requirents.dev.txt ; \
    fi && \
    rm -rf /tmp

RUN echo "Step 4: Creating django-user"
RUN adduser \
    --disabled-password \
    --no-create-home \
    django-user

ENV PATH="/py/bin:$PATH"

USER django-user
