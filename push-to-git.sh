#!/bin/bash

set -e

echo "📦 Pushing Task Manager UI to GitHub"
echo "======================================"
echo "Repository: https://github.com/Ravikumar-tcs/task-manager-ui"
echo ""

# Check if we're in the right directory
if [ ! -f "app.py" ]; then
    echo "❌ Error: Run this from the task-manager-ui directory"
    echo "Current directory: $(pwd)"
    exit 1
fi

echo "✅ Found app.py - in correct directory"
echo ""

# Create .gitignore if it doesn't exist
if [ ! -f ".gitignore" ]; then
    echo "Creating .gitignore..."
    cat > .gitignore << 'EOF'
# Python
__pycache__/
*.pyc
*.pyo
*.pyd
.Python
*.so
*.egg
*.egg-info/
dist/
build/

# Virtual environments
.env
.venv
env/
venv/
ENV/

# IDE
.vscode/
.idea/
*.swp
*.swo
*~

# OS
.DS_Store
Thumbs.db

# Logs
*.log

# GCP
service-account-key.json
*-key.json
EOF
    echo "✅ Created .gitignore"
fi

# Create or update README
echo "Creating README.md..."
cat > README.md << 'EOF'
# Task Manager UI

A modern, responsive task management web application deployed on Google Cloud Run.

![Task Manager](https://img.shields.io/badge/Cloud-GCP-blue)
![Python](https://img.shields.io/badge/Python-3.11-green)
![Flask](https://img.shields.io/badge/Flask-3.0-lightgrey)

## 🚀 Live Demo

Deployed on Google Cloud Run - [View Live App](#)

## ✨ Features

- ✅ Create, update, and delete tasks
- 🎯 Priority levels (High, Medium, Low)
- ✔️ Mark tasks as complete/pending
- 🔍 Filter tasks by status (All/Pending/Completed)
- 🎨 Beautiful gradient UI with smooth animations
- 📱 Responsive design for mobile and desktop
- 🚀 Serverless deployment on GCP Cloud Run

## 🛠️ Tech Stack

- **Backend**: Flask (Python 3.11)
- **Frontend**: HTML5, CSS3, Vanilla JavaScript
- **Deployment**: Google Cloud Run
- **Container**: Docker
- **CI/CD**: Google Cloud Build

## 📁 Project Structure
```
task-manager-ui/
├── app.py              # Flask application with REST API
├── requirements.txt    # Python dependencies
├── Dockerfile         # Container configuration
├── templates/
│   └── index.html     # Frontend UI with inline CSS/JS
└── README.md          # This file
```

## 🏃 Local Development

### Prerequisites
- Python 3.11+
- pip

### Setup and Run
```bash
# Clone the repository
git clone https://github.com/Ravikumar-tcs/task-manager-ui.git
cd task-manager-ui

# Install dependencies
pip install -r requirements.txt

# Run the application
python app.py

# Visit: http://localhost:8080
```

## 🐳 Docker
```bash
# Build the image
docker build -t task-manager-ui .

# Run the container
docker run -p 8080:8080 task-manager-ui

# Visit: http://localhost:8080
```

## ☁️ Deploy to GCP Cloud Run

### Prerequisites
- Google Cloud SDK installed
- GCP project with billing enabled
- Cloud Run API enabled

### Deployment
```bash
# Set your project
gcloud config set project YOUR-PROJECT-ID

# Deploy
gcloud run deploy task-manager-ui \
  --source . \
  --region us-central1 \
  --allow-unauthenticated \
  --memory 512Mi \
  --port 8080

# Get the deployed URL
gcloud run services describe task-manager-ui \
  --region us-central1 \
  --format 'value(status.url)'
```

## 🔌 API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/` | Web UI |
| GET | `/health` | Health check |
| GET | `/api/tasks` | List all tasks |
| GET | `/api/tasks?priority=high` | Filter tasks by priority |
| POST | `/api/tasks` | Create new task |
| PATCH | `/api/tasks/{id}/toggle` | Toggle task status |
| DELETE | `/api/tasks/{id}` | Delete task |

### Example API Usage
```bash
# Create a task
curl -X POST https://your-app-url/api/tasks \
  -H "Content-Type: application/json" \
  -d '{"title": "New Task", "description": "Task details", "priority": "high"}'

# Get all tasks
curl https://your-app-url/api/tasks

# Filter by priority
curl https://your-app-url/api/tasks?priority=high

# Toggle task status
curl -X PATCH https://your-app-url/api/tasks/1/toggle

# Delete task
curl -X DELETE https://your-app-url/api/tasks/1
```

## 🎯 Demo Use Case

This application demonstrates:
- **Rapid Development**: Built with Claude Code AI assistant
- **Modern UI/UX**: Responsive design with smooth animations
- **Cloud-Native**: Serverless deployment on GCP
- **RESTful API**: Clean API design for task management
- **DevOps**: Simple CI/CD with Cloud Build

## 🔄 Making Changes with Claude Code

1. Clone the repository in Claude Code
2. Provide a user story (e.g., "Add dark mode toggle")
3. Let Claude Code implement the changes
4. Redeploy to Cloud Run
5. See changes live in seconds!

## 📝 Sample User Stories for Demo

### Add Dark Mode
```
Add a dark mode toggle to the task manager with:
- Toggle button in header
- Dark color scheme (#1a1a2e background, #16213e cards)
- Save preference to localStorage
- Smooth transition animations
```

### Add Statistics Dashboard
```
Add a statistics card showing:
- Total tasks count
- Pending tasks count
- Completed tasks count
- Completion percentage with progress bar
```

### Add Due Dates
```
Add due date functionality:
- Date picker for setting due dates
- Display "Due in X days" or "Overdue"
- Highlight overdue tasks in red
- Sort by due date option
```

## 🤝 Contributing

This is a demo project. Feel free to fork and experiment!

## 📄 License

MIT License - feel free to use for learning and demos

## 👨‍💻 Author

**Ravikumar Sankara Subbu**
- Business Relationship Manager & AI Transformation Leader
- TCS London
- GitHub: [@Ravikumar-tcs](https://github.com/Ravikumar-tcs)

## 🙏 Acknowledgments

- Built with Claude AI assistance
- Deployed on Google Cloud Platform
- Demo for showcasing AI-powered development workflows

---

⭐ Star this repo if you find it useful for your demos!
EOF

echo "✅ Created README.md"
echo ""

# Initialize git if not already done
if [ ! -d ".git" ]; then
    echo "Initializing git repository..."
    git init
    echo "✅ Git initialized"
else
    echo "✅ Git already initialized"
fi

echo ""
echo "Adding files to git..."
git add .

echo "Creating commit..."
if git diff-index --quiet HEAD -- 2>/dev/null; then
    echo "⚠️  No changes to commit"
else
    git commit -m "Initial commit - Task Manager UI for GCP Cloud Run demo

Features:
- Flask REST API backend
- Modern responsive UI
- Task CRUD operations
- Priority levels and status filtering
- Docker containerization
- Ready for Cloud Run deployment"
    echo "✅ Committed changes"
fi

echo ""
echo "Configuring remote repository..."

# Remove origin if it exists
if git remote | grep -q origin; then
    echo "Removing existing origin remote..."
    git remote remove origin
fi

# Add the correct remote
git remote add origin https://github.com/Ravikumar-tcs/task-manager-ui.git
echo "✅ Added remote: https://github.com/Ravikumar-tcs/task-manager-ui.git"

# Ensure we're on main branch
git branch -M main

echo ""
echo "Pushing to GitHub..."
echo ""
echo "If prompted for credentials:"
echo "  Username: Ravikumar-tcs"
echo "  Password: Use your GitHub Personal Access Token"
echo "  (Create at: https://github.com/settings/tokens)"
echo ""

# Push to GitHub
if git push -u origin main; then
    echo ""
    echo "✅ Successfully pushed to GitHub!"
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "🎉 Repository Setup Complete!"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "🌐 Repository URL:"
    echo "   https://github.com/Ravikumar-tcs/task-manager-ui"
    echo ""
    echo "📝 To use in Claude Code web version:"
    echo "   git clone https://github.com/Ravikumar-tcs/task-manager-ui.git"
    echo "   cd task-manager-ui"
    echo ""
    echo "🚀 To deploy changes to GCP:"
    echo "   gcloud run deploy task-manager-ui \\"
    echo "     --source . \\"
    echo "     --region us-central1 \\"
    echo "     --allow-unauthenticated \\"
    echo "     --project=demoproj-486421"
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
else
    echo ""
    echo "❌ Push failed. This could be because:"
    echo "   1. Repository doesn't exist on GitHub"
    echo "   2. Authentication failed (need Personal Access Token)"
    echo "   3. No changes to push"
    echo ""
    echo "To create Personal Access Token:"
    echo "   1. Go to: https://github.com/settings/tokens"
    echo "   2. Click: Generate new token (classic)"
    echo "   3. Select scope: repo (full control)"
    echo "   4. Generate and copy token"
    echo "   5. Use token as password when pushing"
    echo ""
    echo "Then try: git push -u origin main"
fi