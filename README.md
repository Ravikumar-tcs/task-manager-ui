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
