# Free SSE Hosting Guide

This guide covers how to deploy your Hyperliquid Info MCP Server using SSE (Server-Sent Events) transport on free hosting platforms.

## Why SSE?

SSE (Server-Sent Events) is ideal for free hosting because:
- ✅ Simple HTTP-based protocol
- ✅ Works well with reverse proxies
- ✅ Compatible with most free hosting platforms
- ✅ Lower resource usage than WebSockets
- ✅ Built-in reconnection handling

## Free Hosting Options

### 1. Railway (Recommended)
**Cost:** Free tier with 500 execution hours/month
**SSL:** Automatic HTTPS
**Custom domains:** Supported

**Deploy Steps:**
1. Connect your GitHub repo to Railway
2. Auto-deploys with Dockerfile
3. Get URL: `https://your-service-production.up.railway.app`

### 2. Render
**Cost:** Free tier with 750 hours/month
**SSL:** Automatic HTTPS
**Custom domains:** Supported on paid plans

**Deploy Steps:**
1. Connect GitHub repo to Render
2. Choose "Web Service"
3. Use Dockerfile
4. Get URL: `https://your-service.onrender.com`

### 3. Fly.io
**Cost:** Free allowances, pay-as-you-go after
**SSL:** Automatic HTTPS
**Custom domains:** Supported

**Deploy Steps:**
```bash
flyctl auth login
flyctl launch
flyctl deploy
```

### 4. Google Cloud Run
**Cost:** 2 million requests/month free
**SSL:** Automatic HTTPS
**Custom domains:** Supported

**Deploy Steps:**
1. Build image: `docker build -t gcr.io/PROJECT/hyperliquid-mcp .`
2. Push: `docker push gcr.io/PROJECT/hyperliquid-mcp`
3. Deploy: `gcloud run deploy --image gcr.io/PROJECT/hyperliquid-mcp`

### 5. Heroku (Limited Free Tier)
**Cost:** Free dyno hours (limited)
**SSL:** Automatic HTTPS
**Custom domains:** Supported

**Deploy Steps:**
1. Install Heroku CLI
2. `heroku create your-app-name`
3. `git push heroku main`

## Configuration for SSE

Your server is already configured for SSE! The key changes:

```python
# Host/port in constructor
mcp = FastMCP(
    name="Hyperliquid Info",
    host=os.getenv("HOST", "0.0.0.0"),
    port=int(os.getenv("PORT", 8000))
)

# SSE transport in run()
mcp.run(transport="sse")
```

## Testing Your Deployment

### 1. Health Check
Once deployed, test with curl:
```bash
curl -X POST https://your-deployed-url.com/ \
  -H "Content-Type: application/json" \
  -d '{
    "jsonrpc": "2.0",
    "id": 1,
    "method": "tools/call",
    "params": {
      "name": "health_check",
      "arguments": {}
    }
  }'
```

### 2. Get Market Data
```bash
curl -X POST https://your-deployed-url.com/ \
  -H "Content-Type: application/json" \
  -d '{
    "jsonrpc": "2.0",
    "id": 1,
    "method": "tools/call",
    "params": {
      "name": "get_all_mids",
      "arguments": {}
    }
  }'
```

## Platform-Specific Tips

### Railway
- Automatically provides PORT environment variable
- Uses Dockerfile by default
- Easy GitHub integration
- Good for development and production

### Render
- May have cold start delays on free tier
- Excellent for static sites + APIs
- Good monitoring dashboard

### Fly.io
- Fast global deployment
- Good for edge computing
- Pay-per-use pricing is predictable

### Google Cloud Run
- Excellent auto-scaling
- Only pay for actual requests
- Integrates well with other Google services

## Environment Variables

All platforms automatically provide:
- `PORT` - The port your app should listen on
- `HOST` - Usually defaults to `0.0.0.0`

No additional configuration needed!

## Connecting MCP Clients

Once deployed, connect your MCP clients to:
```
https://your-deployed-url.com
```

**Available tools:**
- `health_check` - Server status
- `get_user_state` - Account positions
- `get_all_mids` - Market prices
- `get_user_trade_history` - Trade history
- `get_l2_snapshot` - Order book data
- `get_candles_snapshot` - Price charts
- And 15+ more Hyperliquid data tools

## Monitoring

Most platforms provide:
- Deployment logs
- Runtime logs
- Performance metrics
- Uptime monitoring
- Error tracking

Check your platform's dashboard for monitoring details.

## Troubleshooting

**Common Issues:**
1. **Cold starts:** Free tiers may have startup delays
2. **Timeouts:** Some platforms have request time limits
3. **Memory limits:** Monitor usage on free tiers
4. **Sleep mode:** Some free tiers sleep after inactivity

**Solutions:**
- Use health check endpoints to keep services warm
- Implement proper error handling
- Monitor resource usage
- Consider upgrading to paid tiers for production use