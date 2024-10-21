import subprocess
from flask import Flask, request, jsonify

app = Flask(__name__)
8
@app.route('/generate', methods=['POST'])
def generate_response():
    input_text = request.json.get('input')
    
    # Validate input
    if not input_text:
        return jsonify({"error": "Input text is required"}), 400

    # Call the LLaMA model using subprocess
    process = subprocess.Popen(
        ['ollama', 'run', 'llama3.2'],
        stdin=subprocess.PIPE,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True,
        encoding='utf-8'  # Ensure output is encoded as utf-8
    )

    try:
        # Send the input_text to the LLaMA model
        stdout, stderr = process.communicate(input=f"{input_text}\n")
        
        # Check for errors in the subprocess
        if process.returncode != 0:
            return jsonify({"error": stderr.strip()}), 500
        
        # Extract LLaMA's response
        response_lines = stdout.strip().splitlines()
        response = response_lines[-1] if response_lines else "No response received"

        return jsonify({"response": response})

    except UnicodeDecodeError as e:
        return jsonify({"error": f"Unicode decode error: {str(e)}"}), 500
    except Exception as e:
        return jsonify({"error": f"Unexpected error: {str(e)}"}), 500

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
