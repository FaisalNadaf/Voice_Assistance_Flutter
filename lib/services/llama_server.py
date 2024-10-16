from flask import Flask, request, jsonify
import torch
from transformers import LlamaForCausalLM, LlamaTokenizer

app = Flask(__name__)

# Load LLaMA model and tokenizer
model_name = "your-llama-model-path"
model = LlamaForCausalLM.from_pretrained(model_name)
tokenizer = LlamaTokenizer.from_pretrained(model_name)

@app.route('/generate', methods=['POST'])
def generate_response():
    input_data = request.json['input']
    inputs = tokenizer(input_data, return_tensors="pt")
    
    outputs = model.generate(**inputs, max_new_tokens=100)
    response = tokenizer.decode(outputs[0], skip_special_tokens=True)

    return jsonify({"response": response})

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
