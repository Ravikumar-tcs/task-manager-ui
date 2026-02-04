# CLAUDE.md - AI Assistant Guide for Task Manager UI

This document provides essential context for AI assistants working with this codebase.

## Project Overview

**Type:** Full-stack Task Management Web Application
**Purpose:** Demo application showcasing AI-assisted development with deployment on Google Cloud Run
**Theme:** AmTrust Financial branding (Navy Blue #002855 & Orange #F7931E)
**License:** MIT

This is a lightweight, serverless-first demo application designed for rapid prototyping and teaching serverless concepts.

## Tech Stack

| Layer | Technology |
|-------|------------|
| Backend | Flask 3.0.0 (Python 3.11) |
| Server | Gunicorn 21.2.0 |
| Testing | pytest 8.0.0 |
| Frontend | Vanilla HTML/CSS/JavaScript (no frameworks) |
| Containerization | Docker (Python 3.11-slim) |
| Deployment | Google Cloud Run |
| Port | 8080 |

## Project Structure

```
task-manager-ui/
├── app.py                 # Flask REST API backend (main application)
├── test_app.py            # Pytest test suite (18 tests)
├── requirements.txt       # Python dependencies (Flask, Gunicorn, pytest)
├── Dockerfile            # Docker configuration for Cloud Run
├── templates/
│   └── index.html        # Frontend SPA with AmTrust Financial theme
├── README.md             # User documentation
├── CLAUDE.md             # AI assistant guide (this file)
├── .gitignore            # Python/IDE/OS exclusions
└── push-to-git.sh        # GitHub deployment automation script
```

## Quick Commands

### Local Development
```bash
# Install dependencies
pip install -r requirements.txt

# Run development server
python app.py
# Server starts at http://localhost:8080
```

### Docker
```bash
# Build container
docker build -t task-manager-ui .

# Run container
docker run -p 8080:8080 task-manager-ui
```

### Cloud Run Deployment
```bash
# Deploy via Cloud Build (from project root)
gcloud run deploy task-manager-ui --source .
```

## Architecture

### Data Flow
```
User Interface (index.html)
        ↓
Vanilla JavaScript (fetch API)
        ↓
Flask REST API (app.py)
        ↓
In-Memory Python List
        ↓
JSON Response → DOM Update
```

### Task Data Model
```python
{
    'id': int,           # Auto-incremented
    'title': str,        # Required
    'description': str,  # Optional (empty string if not provided)
    'priority': str,     # 'high', 'medium', or 'low'
    'status': str,       # 'pending' or 'completed'
    'created_at': str    # ISO format timestamp
}
```

## API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/` | Serve web UI |
| GET | `/health` | Health check |
| GET | `/api/tasks` | List all tasks |
| GET | `/api/tasks?priority={level}` | Filter by priority |
| POST | `/api/tasks` | Create task (body: `{title, description?, priority}`) |
| PATCH | `/api/tasks/{id}/toggle` | Toggle task completion status |
| DELETE | `/api/tasks/{id}` | Delete task |

## Code Conventions

### Backend (app.py)
- REST API design with standard HTTP methods
- JSON for all API responses
- Environment-based configuration (PORT from env var)
- Stateless design for serverless compatibility
- In-memory storage (data resets on restart)

### Frontend (templates/index.html)
- Single-page application pattern
- AmTrust Financial theme with CSS custom properties
- All CSS embedded inline (~230 lines)
- All JavaScript embedded inline (~86 lines)
- Async/await for API calls
- Direct DOM manipulation with innerHTML
- Mobile-responsive design with flexbox

### Theme Colors (AmTrust Financial)
```css
--amtrust-navy: #002855       /* Primary - headers, borders */
--amtrust-navy-dark: #001a3a  /* Background gradient */
--amtrust-orange: #F7931E     /* Accent - buttons, highlights */
--amtrust-orange-dark: #e07d0a /* Button hover state */
--amtrust-white: #ffffff      /* Card backgrounds */
--amtrust-gray-light: #f5f7fa /* Task item backgrounds */
```

### General
- Minimal dependencies (only 2 Python packages)
- Self-contained files for portability
- Descriptive variable and function names
- Clear separation between backend and frontend

## Key Files Reference

### app.py
- **Lines:** ~51
- **Routes:** 6 endpoints (root, health, CRUD for tasks)
- **Storage:** `tasks` list at module level (ephemeral)
- **ID Generation:** `task_id_counter` auto-increments

### templates/index.html
- **Lines:** ~322
- **Sections:** `<style>` for CSS, `<script>` for JS
- **Key JS Functions:**
  - `loadTasks()` - Fetch all tasks from API
  - `renderTasks()` - Update DOM with task list
  - `addTask()` - Create new task via POST
  - `toggleTask(id)` - Toggle status via PATCH
  - `deleteTask(id)` - Remove task via DELETE
  - `filterTasks(filter)` - Client-side filtering

## Important Considerations

### Limitations (By Design)
- **No persistence:** In-memory storage resets on restart
- **No authentication:** All tasks are public
- **No database:** Demo simplicity over production features
- **Single worker:** Default Gunicorn configuration

### When Making Changes
1. **Keep it simple:** This is a demo app; avoid over-engineering
2. **Inline styles/scripts:** Frontend is self-contained in one HTML file
3. **Test locally first:** Run `python app.py` before deploying
4. **Cloud Run ready:** Ensure PORT env var compatibility (default 8080)
5. **Stateless:** Don't rely on server-side state between requests

### Planned Enhancements (from README)
- Dark mode toggle with localStorage persistence
- Statistics dashboard (counts, progress bar)
- Due dates with date picker and overdue highlighting

## Testing

**Framework:** pytest 8.0.0
**Test File:** `test_app.py`
**Total Tests:** 18

### Run Tests
```bash
# Run all tests
python -m pytest test_app.py -v

# Run specific test class
python -m pytest test_app.py::TestHealthEndpoint -v

# Run with coverage (if pytest-cov installed)
python -m pytest test_app.py --cov=app
```

### Test Coverage
| Test Class | Description |
|------------|-------------|
| `TestHealthEndpoint` | Health check endpoint (1 test) |
| `TestIndexEndpoint` | Index page and AmTrust branding (2 tests) |
| `TestGetTasks` | GET /api/tasks operations (3 tests) |
| `TestCreateTask` | POST /api/tasks operations (4 tests) |
| `TestDeleteTask` | DELETE /api/tasks operations (2 tests) |
| `TestToggleTask` | PATCH /api/tasks toggle operations (3 tests) |
| `TestThemeIntegration` | AmTrust theme CSS verification (3 tests) |

### Manual Testing
```bash
# Start server
python app.py

# Test health endpoint
curl http://localhost:8080/health

# Test task creation
curl -X POST http://localhost:8080/api/tasks \
  -H "Content-Type: application/json" \
  -d '{"title": "Test Task", "priority": "high"}'

# Test task listing
curl http://localhost:8080/api/tasks
```

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| PORT | 8080 | Server listening port |

## Deployment Notes

### Dockerfile Details
- Base: `python:3.11-slim`
- Working dir: `/app`
- Installs requirements, copies source
- Runs Gunicorn with 1 worker, 8 threads
- Exposes PORT from environment

### Cloud Run Configuration
- Automatically scales to zero
- HTTPS endpoint provided
- Container must respond on PORT
- Health checks via `/health` endpoint
