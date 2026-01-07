# Deployment Guide

## Deployment Options for Shiny Apps

### ❌ Vercel - NOT Recommended for Shiny Apps

**Vercel is NOT suitable for Shiny applications** because:
- Vercel is designed for static sites and serverless functions (Node.js, Python, etc.)
- Shiny apps require an **R runtime environment** and **Shiny server**
- Shiny apps are **not static** - they require a running R process
- Vercel cannot execute R code or run Shiny server

**Alternative for Vercel**: You would need to convert your Shiny app to a static HTML/JavaScript app (e.g., using `htmlwidgets` to export static maps), but this would lose all interactivity.

---

### ✅ Recommended: ShinyApps.io (Best Option)

**ShinyApps.io** is the official hosting platform for Shiny applications by RStudio/Posit.

#### Advantages:
- ✅ **Free tier available** (5 apps, 25 hours/month)
- ✅ **Built specifically for Shiny apps**
- ✅ **Easy deployment** - just connect your GitHub repo
- ✅ **Automatic updates** when you push to GitHub
- ✅ **SSL certificates** included
- ✅ **No server management** required
- ✅ **Scales automatically**

#### How to Deploy to ShinyApps.io:

1. **Sign up**: Go to https://www.shinyapps.io/ and create a free account

2. **Install rsconnect package**:
   ```r
   install.packages("rsconnect")
   ```

3. **Authorize your account**:
   ```r
   library(rsconnect)
   rsconnect::setAccountInfo(
     name = "your-account-name",
     token = "your-token",
     secret = "your-secret"
   )
   ```
   (Get token and secret from shinyapps.io dashboard)

4. **Deploy the app**:
   ```r
   setwd("Group Work")
   rsconnect::deployApp(
     appDir = "covid19_interactive_map",
     appName = "covid19-malaysia-map",
     account = "your-account-name"
   )
   ```

5. **Your app will be live at**: `https://your-account-name.shinyapps.io/covid19-malaysia-map/`

#### Pricing:
- **Free**: 5 apps, 25 hours/month
- **Starter**: $9/month - 10 apps, 200 hours/month
- **Professional**: $99/month - Unlimited apps, 1000 hours/month

---

### ✅ Alternative Options

#### 1. **RStudio Connect** (Enterprise)
- Self-hosted solution
- Requires your own server
- Best for organizations
- **Cost**: License-based (expensive)

#### 2. **DigitalOcean / AWS / Azure**
- Deploy Shiny Server on cloud VPS
- Full control but requires server management
- **Cost**: ~$5-20/month for basic VPS

#### 3. **Docker + Cloud Platform**
- Containerize your Shiny app
- Deploy to any container platform
- More complex setup
- **Cost**: Varies by platform

---

## Recommended Deployment Steps (ShinyApps.io)

### Step 1: Prepare Your App

Make sure your app structure is clean:
```
Group Work/
└── covid19_interactive_map/
    ├── ui.R
    ├── server.R
    ├── global.R
    └── fetch_data.R
```

### Step 2: Create a `.Rprofile` (Optional)

Create `.Rprofile` in your app directory to ensure packages are installed:
```r
# .Rprofile
if (!require("shiny")) install.packages("shiny")
if (!require("tidyverse")) install.packages("tidyverse")
# ... add all required packages
```

### Step 3: Deploy

```r
# Install rsconnect if not already installed
install.packages("rsconnect")

# Load library
library(rsconnect)

# Set account info (one-time setup)
rsconnect::setAccountInfo(
  name = "your-account-name",
  token = "YOUR_TOKEN",
  secret = "YOUR_SECRET"
)

# Navigate to app directory
setwd("Group Work")

# Deploy
rsconnect::deployApp(
  appDir = "covid19_interactive_map",
  appName = "covid19-malaysia-map",
  account = "your-account-name"
)
```

### Step 4: Update App

To update your deployed app, just run deploy again:
```r
rsconnect::deployApp(
  appDir = "covid19_interactive_map",
  appName = "covid19-malaysia-map",
  account = "your-account-name"
)
```

---

## Important Notes for Deployment

### Data Files
- ✅ **Shapefile**: Must be included in app directory or accessible via URL
- ✅ **CSV files**: Include as fallback, but API will be used primarily
- ⚠️ **API calls**: Will work from ShinyApps.io (has internet access)

### Dependencies
Make sure all required packages are listed. ShinyApps.io will install them automatically:
- shiny
- tidyverse
- leaflet
- htmlwidgets
- RColorBrewer
- sf
- httr
- jsonlite
- vroom
- lubridate

### File Size Limits
- **Free tier**: 100MB per app
- **Paid tiers**: Larger limits available

### Environment Variables
If you need API keys (not needed for this app), use:
```r
Sys.setenv(API_KEY = "your-key")
```

---

## Quick Comparison

| Platform | Free Tier | Shiny Support | Ease of Use | Best For |
|----------|-----------|---------------|-------------|----------|
| **ShinyApps.io** | ✅ Yes | ✅ Native | ⭐⭐⭐⭐⭐ | Most users |
| **Vercel** | ✅ Yes | ❌ No | ⭐⭐ | Static sites only |
| **RStudio Connect** | ❌ No | ✅ Native | ⭐⭐⭐ | Enterprise |
| **Cloud VPS** | ❌ No | ✅ Yes | ⭐⭐ | Advanced users |

---

## Recommendation

**Use ShinyApps.io** - It's the easiest and most reliable option for Shiny apps. The free tier is perfect for getting started, and deployment is straightforward.

Your app will be accessible worldwide at a URL like:
`https://yourname.shinyapps.io/covid19-malaysia-map/`

