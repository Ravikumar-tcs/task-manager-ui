from flask import Flask, render_template, request, jsonify
from datetime import datetime
import os

app = Flask(__name__)

# In-memory storage
tasks = []

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/api/tasks', methods=['GET'])
def get_tasks():
    priority = request.args.get('priority')
    if priority:
        filtered = [t for t in tasks if t.get('priority') == priority]
        return jsonify(filtered)
    return jsonify(tasks)

@app.route('/api/tasks', methods=['POST'])
def create_task():
    task = request.json
    task['id'] = len(tasks) + 1
    task['created_at'] = datetime.now().isoformat()
    task['status'] = 'pending'
    tasks.append(task)
    return jsonify(task), 201

@app.route('/api/tasks/<int:task_id>', methods=['DELETE'])
def delete_task(task_id):
    global tasks
    tasks = [t for t in tasks if t['id'] != task_id]
    return jsonify({'success': True})

@app.route('/api/tasks/<int:task_id>/toggle', methods=['PATCH'])
def toggle_task(task_id):
    task = next((t for t in tasks if t['id'] == task_id), None)
    if task:
        task['status'] = 'completed' if task['status'] == 'pending' else 'pending'
        return jsonify(task)
    return jsonify({'error': 'Not found'}), 404

@app.route('/health')
def health():
    return jsonify({'status': 'healthy'})

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 8080))
    app.run(host='0.0.0.0', port=port, debug=False)
