from flask import Flask, render_template, request

app = Flask(__name__)

# A dictionary to store tasks with an ID
tasks = {}
task_id_counter = 1

@app.route('/', methods=['GET', 'POST'])
def index():
    global task_id_counter
    
    if request.method == 'POST':
        if 'add_task' in request.form:
            task_content = request.form.get('task_content')
            if task_content:
                tasks[task_id_counter] = task_content
                task_id_counter += 1

        elif 'delete_task' in request.form:
            task_id_to_delete = int(request.form.get('task_id_to_delete'))
            if task_id_to_delete in tasks:
                tasks.pop(task_id_to_delete, None)

    return render_template('index.html', tasks=tasks)

@app.route('/metrics')
def metrics():
    """Simple metrics endpoint for monitoring"""
    return {
        'active_tasks': len(tasks),
        'total_tasks_created': task_id_counter - 1,
        'status': 'healthy'
    }, 200

@app.route('/health')
def health_check():
    return {'status': 'healthy', 'message': 'Omar ElNemr Flask App is running!', 'active_tasks': len(tasks)}, 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=False)