FROM python:3.10-slim

# --- NETFREE CERT INTSALL - USE ONLY IF YOUR ISP IS NETFREE ---
   ADD https://netfree.link/dl/unix-ca.sh /home/netfree-unix-ca.sh 
    RUN cat  /home/netfree-unix-ca.sh | sh
    ENV NODE_EXTRA_CA_CERTS=/etc/ca-bundle.crt
    ENV REQUESTS_CA_BUNDLE=/etc/ca-bundle.crt
    ENV SSL_CERT_FILE=/etc/ca-bundle.crt
    # --- END NETFREE CERT INTSALL ---

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Install uv package manager and gdown for Google Drive downloads
RUN pip install uv gdown

# Copy the application code
COPY pyproject.toml .
COPY README.md .
COPY src/ ./src/

# Install application dependencies
RUN pip install .

# Create directory for index
RUN mkdir -p index

# Download and extract the index (from Google Drive) using gdown
RUN gdown 1lpbBCPimwcNfC0VZOlQueA4SHNGIp5_t -O index.zip && \
    unzip index.zip -d /app && \
    rm index.zip

# Set environment variables
ENV PYTHONIOENCODING=utf-8

# Expose the port if needed (depends on how the MCP server is accessed)
# EXPOSE 8000

# Command to run the server
# Add logging to help diagnose index path issues
CMD ["bash", "-c", "echo 'Index path: /app/index' && ls -la /app/index && uv --directory /app run jewish_library"]
