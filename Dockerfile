FROM python:3.11-slim-bookworm

WORKDIR /MoneyPrinterTurbo

RUN chmod 777 /MoneyPrinterTurbo

ENV PYTHONPATH="/MoneyPrinterTurbo"

# Install system dependencies from official Debian repositories
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        git \
        ffmpeg \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements first for Docker cache
COPY requirements.txt ./

# Use official PyPI
RUN pip install --no-cache-dir \
    --retries 3 \
    --timeout 60 \
    -r requirements.txt

# Copy application
COPY . .

# Default Streamlit port
EXPOSE 8501

# Railway provides $PORT.
# Fall back to 8501 when running locally.
CMD ["sh", "-c", "streamlit run ./webui/Main.py --server.address=0.0.0.0 --server.port=${PORT:-8501} --browser.gatherUsageStats=False --client.toolbarMode=minimal --logger.hideWelcomeMessage=True --server.showEmailPrompt=False"]
