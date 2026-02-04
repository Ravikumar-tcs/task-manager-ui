"""
Tests for Task Manager Flask Application
"""
import pytest
import json
from app import app, tasks


@pytest.fixture
def client():
    """Create a test client for the Flask application."""
    app.config['TESTING'] = True
    with app.test_client() as client:
        yield client
    # Clear tasks after each test
    tasks.clear()


@pytest.fixture
def sample_task():
    """Sample task data for testing."""
    return {
        'title': 'Test Task',
        'description': 'Test Description',
        'priority': 'high'
    }


class TestHealthEndpoint:
    """Tests for the health check endpoint."""

    def test_health_returns_healthy_status(self, client):
        """Health endpoint should return healthy status."""
        response = client.get('/health')
        assert response.status_code == 200
        data = json.loads(response.data)
        assert data['status'] == 'healthy'


class TestIndexEndpoint:
    """Tests for the main index page."""

    def test_index_returns_html(self, client):
        """Index should return HTML page."""
        response = client.get('/')
        assert response.status_code == 200
        assert b'Task' in response.data
        assert b'Manager' in response.data

    def test_index_contains_amtrust_branding(self, client):
        """Index should contain AmTrust Financial branding."""
        response = client.get('/')
        assert response.status_code == 200
        assert b'AmTrust Financial' in response.data
        assert b'--amtrust-navy' in response.data
        assert b'--amtrust-orange' in response.data


class TestGetTasks:
    """Tests for GET /api/tasks endpoint."""

    def test_get_tasks_empty_list(self, client):
        """Should return empty list when no tasks exist."""
        response = client.get('/api/tasks')
        assert response.status_code == 200
        data = json.loads(response.data)
        assert data == []

    def test_get_tasks_returns_all_tasks(self, client, sample_task):
        """Should return all created tasks."""
        # Create multiple tasks
        client.post('/api/tasks',
                    data=json.dumps(sample_task),
                    content_type='application/json')
        client.post('/api/tasks',
                    data=json.dumps({'title': 'Task 2', 'priority': 'low'}),
                    content_type='application/json')

        response = client.get('/api/tasks')
        assert response.status_code == 200
        data = json.loads(response.data)
        assert len(data) == 2

    def test_get_tasks_filter_by_priority(self, client):
        """Should filter tasks by priority."""
        # Create tasks with different priorities
        client.post('/api/tasks',
                    data=json.dumps({'title': 'High Task', 'priority': 'high'}),
                    content_type='application/json')
        client.post('/api/tasks',
                    data=json.dumps({'title': 'Low Task', 'priority': 'low'}),
                    content_type='application/json')

        response = client.get('/api/tasks?priority=high')
        assert response.status_code == 200
        data = json.loads(response.data)
        assert len(data) == 1
        assert data[0]['priority'] == 'high'


class TestCreateTask:
    """Tests for POST /api/tasks endpoint."""

    def test_create_task_success(self, client, sample_task):
        """Should create a new task successfully."""
        response = client.post('/api/tasks',
                               data=json.dumps(sample_task),
                               content_type='application/json')
        assert response.status_code == 201
        data = json.loads(response.data)
        assert data['title'] == sample_task['title']
        assert data['description'] == sample_task['description']
        assert data['priority'] == sample_task['priority']
        assert data['status'] == 'pending'
        assert 'id' in data
        assert 'created_at' in data

    def test_create_task_assigns_incremental_id(self, client, sample_task):
        """Should assign incremental IDs to tasks."""
        response1 = client.post('/api/tasks',
                                data=json.dumps(sample_task),
                                content_type='application/json')
        response2 = client.post('/api/tasks',
                                data=json.dumps(sample_task),
                                content_type='application/json')

        data1 = json.loads(response1.data)
        data2 = json.loads(response2.data)
        assert data2['id'] == data1['id'] + 1

    def test_create_task_sets_pending_status(self, client, sample_task):
        """New tasks should have pending status."""
        response = client.post('/api/tasks',
                               data=json.dumps(sample_task),
                               content_type='application/json')
        data = json.loads(response.data)
        assert data['status'] == 'pending'

    def test_create_task_without_description(self, client):
        """Should create task without description."""
        task = {'title': 'No Description Task', 'priority': 'medium'}
        response = client.post('/api/tasks',
                               data=json.dumps(task),
                               content_type='application/json')
        assert response.status_code == 201


class TestDeleteTask:
    """Tests for DELETE /api/tasks/<id> endpoint."""

    def test_delete_task_success(self, client, sample_task):
        """Should delete an existing task."""
        # Create a task first
        create_response = client.post('/api/tasks',
                                      data=json.dumps(sample_task),
                                      content_type='application/json')
        task_id = json.loads(create_response.data)['id']

        # Delete the task
        response = client.delete(f'/api/tasks/{task_id}')
        assert response.status_code == 200
        data = json.loads(response.data)
        assert data['success'] is True

        # Verify task is deleted
        get_response = client.get('/api/tasks')
        tasks_data = json.loads(get_response.data)
        assert len(tasks_data) == 0

    def test_delete_nonexistent_task(self, client):
        """Should handle deletion of non-existent task."""
        response = client.delete('/api/tasks/999')
        assert response.status_code == 200


class TestToggleTask:
    """Tests for PATCH /api/tasks/<id>/toggle endpoint."""

    def test_toggle_task_pending_to_completed(self, client, sample_task):
        """Should toggle task from pending to completed."""
        # Create a task
        create_response = client.post('/api/tasks',
                                      data=json.dumps(sample_task),
                                      content_type='application/json')
        task_id = json.loads(create_response.data)['id']

        # Toggle the task
        response = client.patch(f'/api/tasks/{task_id}/toggle')
        assert response.status_code == 200
        data = json.loads(response.data)
        assert data['status'] == 'completed'

    def test_toggle_task_completed_to_pending(self, client, sample_task):
        """Should toggle task from completed back to pending."""
        # Create and toggle a task
        create_response = client.post('/api/tasks',
                                      data=json.dumps(sample_task),
                                      content_type='application/json')
        task_id = json.loads(create_response.data)['id']
        client.patch(f'/api/tasks/{task_id}/toggle')

        # Toggle again
        response = client.patch(f'/api/tasks/{task_id}/toggle')
        assert response.status_code == 200
        data = json.loads(response.data)
        assert data['status'] == 'pending'

    def test_toggle_nonexistent_task(self, client):
        """Should return 404 for non-existent task."""
        response = client.patch('/api/tasks/999/toggle')
        assert response.status_code == 404
        data = json.loads(response.data)
        assert 'error' in data


class TestThemeIntegration:
    """Tests for AmTrust Financial theme integration."""

    def test_theme_colors_present(self, client):
        """Should have AmTrust brand colors defined."""
        response = client.get('/')
        html = response.data.decode('utf-8')
        # Check for AmTrust navy color
        assert '#002855' in html or '--amtrust-navy' in html
        # Check for AmTrust orange color
        assert '#F7931E' in html or '--amtrust-orange' in html

    def test_theme_css_variables(self, client):
        """Should define CSS custom properties for theming."""
        response = client.get('/')
        html = response.data.decode('utf-8')
        assert '--amtrust-navy:' in html
        assert '--amtrust-orange:' in html
        assert '--amtrust-white:' in html

    def test_brand_accent_element(self, client):
        """Should have brand accent element."""
        response = client.get('/')
        html = response.data.decode('utf-8')
        assert 'brand-accent' in html
