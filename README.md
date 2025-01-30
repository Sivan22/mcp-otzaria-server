# Jewish Library MCP Server

[![smithery badge](https://smithery.ai/badge/jewish_library)](https://smithery.ai/server/jewish_library)
An MCP (Model Context Protocol) server that provides powerful search capabilities for Jewish texts and literature. This server enables Large Language Models to search and reference Jewish texts through a standardized interface.

## Features

- Full-text search across Jewish texts and literature
- Advanced query syntax support:
  - Field-specific search (text:term, reference:term, topics:term)
  - Boolean operators (AND, OR)
  - Required/excluded terms (+term, -term)
  - Phrase search ('exact phrase')
  - Wildcards (?, *)
- Relevance-based scoring
- Rich search results including references, topics, and highlighted excerpts

## Installation

Requires Python 3.10 or higher.

### Installing via Smithery

To install Jewish Library for Claude Desktop automatically via [Smithery](https://smithery.ai/server/jewish_library):

```bash
npx -y @smithery/cli install jewish_library --client claude
```

### Clone the repository
```bash
git clone https://github.com/sivan22/mcp-otzaria-server.git
cd mcp-otzaria-server
```
### Get the index
download and extract the index from [here](https://drive.google.com/file/d/1lpbBCPimwcNfC0VZOlQueA4SHNGIp5_t/view?usp=drive_link)

### Install dependencies
```
pip install .
```
## Running the Server

The server can be run directly:

```bash
uv --directory path/to/directory run jewish_library
```

Or through an MCP client that supports the Model Context Protocol.
for claude desktop app and cline you should use the following config:
```
{
  "mcpServers": {        
      "jewish_library": {
          "command": "uv",
          "args": [
              "--directory",
              "your/path/to/directory",
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

## Available tools

The server provides a single tool through the MCP interface:

### full_text_search

Performs a full-text search across the Jewish library with advanced query capabilities.

Example query formats:
```
# Basic search
"maimonides on prayer"

# Field-specific search
text:"love your neighbor" AND topics:mitzvot

# Required terms
+shabbat +candles

# Phrase search with topic filter
"four species" AND topics:sukkot

# Wildcard search
pray* AND reference:psalms
```

Search results include:
- Reference information
- Relevant topics
- Highlighted excerpts showing query matches
- Relevance score

## Development

This project uses:
- [MCP SDK](https://github.com/modelcontextprotocol/sdk) for server implementation
- [Tantivy](https://github.com/quickwit-oss/tantivy) for full-text search capabilities





## Requirements

- Python >= 3.10
- MCP SDK >= 1.1.1
- Tantivy search engine

## License

MIT License
