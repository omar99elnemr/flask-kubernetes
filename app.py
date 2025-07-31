from flask import Flask, render_template, request
from prometheus_client import Counter, Histogram, generate_latest, CONTENT_TYPE_LATEST
import time

app = Flask(__name__)

# Prometheus metrics
REQUEST_COUNT = Counter('flask_app_requests_total', 'Total requests', ['method', 'endpoint'])
REQUEST_DURATION = Histogram('flask_app_request_duration_seconds', 'Request duration in seconds')
TASK_OPERATIONS = Counter('flask_app_task_operations_total', 'Task operations', ['operation'])

# A dictionary to store tasks with an ID
tasks = {}
task_id_counter = 1

@app.route('/', methods=['GET', 'POST'])
def index():
    start_time = time.time()
    global task_id_counter
    response_text = ""

    if request.method == 'POST':
        if 'add_task' in request.form:
            task_content = request.form.get('task_content')
            if task_content:
                tasks[task_id_counter] = task_content
                task_id_counter += 1
                TASK_OPERATIONS.labels(operation='add').inc()

        elif 'delete_task' in request.form:
            task_id_to_delete = int(request.form.get('task_id_to_delete'))
            tasks.pop(task_id_to_delete, None)
            TASK_OPERATIONS.labels(operation='delete').inc()

    # Record metrics
    REQUEST_COUNT.labels(method=request.method, endpoint='/').inc()
    REQUEST_DURATION.observe(time.time() - start_time)
        
    return render_template('index.html', tasks=tasks)

@app.route('/health')
def health_check():
    start_time = time.time()
    REQUEST_COUNT.labels(method='GET', endpoint='/health').inc()
    REQUEST_DURATION.observe(time.time() - start_time)
    return {'status': 'healthy', 'message': 'Omar ElNemr Flask App is running!'}, 200

@app.route('/metrics')
def metrics():
    return generate_latest(), 200, {'Content-Type': CONTENT_TYPE_LATEST}

if __name__ == '__main__':
    # app.run(port=5000,debug=True)
    app.run(host='0.0.0.0',port=5000,debug=True)
