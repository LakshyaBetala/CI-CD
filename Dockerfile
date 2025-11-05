# Dockerfile (Podman-compatible)
FROM python:3.11-slim

WORKDIR /app

# Copy only requirements first to leverage cache
COPY requirements.txt /app/requirements.txt

# Use python3 -m pip to ensure correct interpreter, upgrade pip and install packages
RUN python3 -m pip install --upgrade pip \
 && python3 -m pip install --no-cache-dir -r /app/requirements.txt

# Copy app files
COPY . /app

# Ensure 'python' points to python3 for compatibility (optional but safe)
RUN ln -sf /usr/bin/python3 /usr/local/bin/python

ENV PYTHONUNBUFFERED=1 \
    FLASK_APP=app/main.py

EXPOSE 5000

# Use python3 explicitly
CMD ["python3", "-u", "app/main.py"]
