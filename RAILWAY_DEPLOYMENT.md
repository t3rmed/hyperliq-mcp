# Railway Deployment Guide

This guide explains how to deploy the Hyperliquid Info MCP Server to Railway.

## Prerequisites

1. A [Railway](https://railway.app/) account
2. Railway CLI installed (optional, can use web interface)
3. This repository with the Docker setup

## Deployment Steps

### Option 1: Deploy via Railway Web Interface

1. **Connect your repository to Railway:**
   - Go to [Railway](https://railway.app/) and log in
   - Click "New Project"
   - Choose "Deploy from GitHub repo"
   - Select this repository

2. **Configure the deployment:**
   - Railway will automatically detect the Dockerfile
   - No additional configuration needed - the Dockerfile handles everything

3. **Deploy:**
   - Click "Deploy"
   - Railway will build and deploy your container
   - Wait for the deployment to complete

### Option 2: Deploy via Railway CLI

1. **Install Railway CLI:**
   ```bash
   npm install -g @railway/cli
   ```

2. **Login to Railway:**
   ```bash
   railway login
   ```

3. **Initialize Railway project:**
   ```bash
   railway init
   ```

4. **Deploy:**
   ```bash
   railway up
   ```

## Environment Variables

The server is configured to work out-of-the-box with Railway's environment. It automatically:
- Binds to `0.0.0.0` (required for Railway)
- Uses Railway's `$PORT` environment variable
- Falls back to port 8000 if `$PORT` is not set

## Endpoint Information

Once deployed, your MCP server will be available at:
```
https://your-service-name-production.up.railway.app
```

**API Endpoints:**
- **Health Check:** Use the `health_check` tool via MCP client
- **MCP Protocol:** The server runs on the root path `/` using MCP protocol over SSE (Server-Sent Events)
- **All Tools:** Access via MCP client (get_user_state, get_all_mids, etc.)

**Note:** This server now uses SSE transport which is optimal for Railway's free hosting.

## Testing the Deployment

1. **Check deployment status:**
   - In Railway dashboard, verify the service is running
   - Check the deployment logs for any errors

2. **Test the MCP server:**
   - Use an MCP client to connect to your Railway URL
   - Example tools like `get_all_mids`, `get_user_state`, etc. should be available

## Troubleshooting

1. **Build failures:**
   - Check the build logs in Railway dashboard
   - Ensure all dependencies in `pyproject.toml` are correct

2. **Runtime errors:**
   - Check application logs in Railway dashboard
   - Verify environment variables are set correctly

3. **Connection issues:**
   - Ensure your MCP client is connecting to the correct Railway URL
   - Check that the server is binding to `0.0.0.0:$PORT`

## Cost Considerations

- Railway provides a free tier with limitations
- Monitor your usage to avoid unexpected charges
- Consider upgrading to a paid plan for production use

## Security Notes

- The server provides read-only access to Hyperliquid data
- No authentication is implemented - consider adding auth for production
- Railway URLs are publicly accessible by default