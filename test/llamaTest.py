import subprocess
import os

# Set the environment to use UTF-8 encoding
env = os.environ.copy()
env['PYTHONIOENCODING'] = 'UTF-8'

# Test the LLaMA model with a simple input
process = subprocess.Popen(
    ['ollama', 'run', 'llama3.2'],  # Replace 'llama3.2' with your model name if different
    stdin=subprocess.PIPE,
    stdout=subprocess.PIPE,
    stderr=subprocess.PIPE,
    text=True,
    env=env  # Use modified environment
)

# Send input to the LLaMA model
input_text = "Hello, who are you?"
stdout, stderr = process.communicate(input=f"{input_text}\n")

# Print the outputs
print('User Input :', input_text)
print(f"stdout: {stdout}")
print(f"stderr: {stderr}")
