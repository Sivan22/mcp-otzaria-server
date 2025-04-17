# Docker Deployment for Jewish Library MCP Server

This document provides instructions for deploying the Jewish Library MCP Server using Docker.

## Prerequisites

- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/install/) (optional, but recommended)

## Quick Start with Docker Compose

The easiest way to deploy the server is using Docker Compose:

```bash
# Build and start the container
docker-compose up -d

# View logs
docker-compose logs -f
```

## Manual Docker Deployment

If you prefer to use Docker commands directly:

```bash
# Build the Docker image
docker build -t jewish-library-mcp .

# Run the container
docker run -d --name jewish-library-server \
  -e PYTHONIOENCODING=utf-8 \
  -v $(pwd)/jewish_library.log:/app/jewish_library.log \
  --restart unless-stopped \
  jewish-library-mcp
```

## What the Docker Setup Does

The Docker configuration:

1. Uses Python 3.10 as the base image
2. Installs necessary system dependencies (wget, unzip)
3. Installs the uv package manager and gdown for Google Drive downloads
4. Copies the application code
5. Installs the application dependencies
6. Downloads and extracts the search index from Google Drive
7. Sets up the environment for proper UTF-8 encoding (important for Hebrew text)
8. Runs the server using the uv package manager

## MCP Client Configuration

To connect to the containerized server from an MCP client (like Claude desktop app or Cline), you'll need to update your MCP client configuration. 

For direct connection to the Docker container (when using host networking mode):

```json
{
  "mcpServers": {        
      "jewish_library": {
          "command": "docker",
          "args": [
              "exec",
              "-i",
              "jewish-library-server",
              "uv",
              "--directory",
              "/app",
              "run",
              "jewish_library"
          ],
          "env": {
            "PYTHONIOENCODING": "utf-8" 
          }
      }
  }
}
```

## Customization

### Persistent Index Storage

If you want to avoid downloading the index every time you rebuild the container, you can modify the docker-compose.yml to add a volume for the index:

```yaml
volumes:
  - ./jewish_library.log:/app/jewish_library.log
  - ./index:/app/index
```

Then you'll need to modify the Dockerfile to not download the index if it already exists:

```dockerfile
# Download index only if it doesn't exist
RUN if [ ! -d "/app/index" ] || [ -z "$(ls -A /app/index)" ]; then \
    gdown 1lpbBCPimwcNfC0VZOlQueA4SHNGIp5_t -O index.zip && \
    unzip index.zip -d index/ && \
    rm index.zip; \
fi
```

## Troubleshooting

### Index Download Issues

If the container fails to build due to issues downloading the index from Google Drive, you can:

1. Download the index manually from [this link](https://drive.google.com/file/d/1lpbBCPimwcNfC0VZOlQueA4SHNGIp5_t/view?usp=drive_link)
2. Extract it to an `index` directory in your project root
3. Use the volume mounting approach mentioned above to use your local index

### UTF-8 Encoding

If you see garbled Hebrew text in the logs or search results, ensure the `PYTHONIOENCODING=utf-8` environment variable is set correctly.

### Log Access

Logs are written to `/app/jewish_library.log` in the container and mounted to `./jewish_library.log` on your host system with the default configuration.
