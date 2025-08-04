from flask import Flask, render_template, request
from prometheus_client import Counter, Histogram, Gauge, generate_latest, CONTENT_TYPE_LATEST
import time

app = Flask(__name__)

# Prometheus metrics
REQUEST_COUNT = Counter('flask_requests_total', 'Total Flask requests', ['method', 'endpoint', 'status'])
REQUEST_DURATION = Histogram('flask_request_duration_seconds', 'Flask request duration')
ACTIVE_TASKS = Gauge('flask_active_tasks', 'Number of active tasks')
TASK_OPERATIONS = Counter('flask_task_operations_total', 'Task operations', ['operation'])

# A dictionary to store tasks with an ID
tasks = {}
task_id_counter = 1

@app.before_request
def before_request():
    request.start_time = time.time()

@app.after_request
def after_request(response):
    if hasattr(request, 'start_time'):
        REQUEST_DURATION.observe(time.time() - request.start_time)
    
    REQUEST_COUNT.labels(
        method=request.method, 
        endpoint=request.endpoint or 'unknown',
        status=response.status_code
    ).inc()
    
    return response

@app.route('/', methods=['GET', 'POST'])
def index():
    global task_id_counter
    
    if request.method == 'POST':
        if 'add_task' in request.form:
            task_content = request.form.get('task_content')
            if task_content:
                tasks[task_id_counter] = task_content
                task_id_counter += 1
                TASK_OPERATIONS.labels(operation='add').inc()

        elif 'delete_task' in request.form:
            task_id_to_delete = int(request.form.get('task_id_to_delete'))
            if task_id_to_delete in tasks:
                tasks.pop(task_id_to_delete, None)
                TASK_OPERATIONS.labels(operation='delete').inc()

    # Update active tasks gauge
    ACTIVE_TASKS.set(len(tasks))
    return render_template('index.html', tasks=tasks)

@app.route('/metrics')
def metrics():
    """Prometheus metrics endpoint"""
    return generate_latest(), 200, {'Content-Type': CONTENT_TYPE_LATEST}

@app.route('/health')
def health_check():
    return {'status': 'healthy', 'message': 'Omar ElNemr Flask App is running!', 'active_tasks': len(tasks)}, 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=False)