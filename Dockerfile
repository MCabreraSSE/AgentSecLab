# ---------- Etapa base ----------
FROM python:3.10-slim

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=on \
    PIP_DISABLE_PIP_VERSION_CHECK=on

# ---------- Dependencias ----------
WORKDIR /app
COPY requirements.txt /app/

# ---------- Dependencias OS + Python ----------
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    ffmpeg \
    graphviz \
 && pip install --upgrade pip \
 && pip install -r requirements.txt \
 && python -m nltk.downloader punkt \
 && apt-get purge -y build-essential \
 && apt-get autoremove -y \
 && rm -rf /var/lib/apt/lists/*


# ---------- Copia del proyecto ----------
COPY . /app

# ---------- Exponer Streamlit ----------
EXPOSE 8501

# ---------- Arranque ----------
CMD ["streamlit", "run", "llm_app.py", "--server.port=8501", "--server.address=0.0.0.0"]
