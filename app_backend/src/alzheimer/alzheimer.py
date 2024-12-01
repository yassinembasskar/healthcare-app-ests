import sys
import json
import numpy as np
from tensorflow.keras.models import load_model
from tensorflow.keras.preprocessing import image
# import os
# import logging

# # Suppress TensorFlow logs
# os.environ['TF_CPP_MIN_LOG_LEVEL'] = '3'  # Suppress TensorFlow C++ backend logs
# logging.getLogger('tensorflow').setLevel(logging.ERROR)
# Ensure that stdout uses UTF-8 encoding
sys.stdout = open(sys.stdout.fileno(), mode='w', encoding='utf-8')

# Define the class names
class_names = ['Mild Demented', 'Moderate Demented', 'Non-Demented', 'Very Mild Demented']

# Ensure an image path is passed as an argument
if len(sys.argv) < 2:
    print("Error: No image path provided")
    sys.exit(1)

image_path = sys.argv[1]  # This should now correctly handle Windows paths

# Load the trained model
model_path = 'C://Users//tanan//healthcare-app-ests//app_backend//src//alzheimer//alzheimermodel.h5'
loaded_model = load_model(model_path)

# Load and preprocess the image
img = image.load_img(image_path, target_size=(224, 224))
img_array = image.img_to_array(img)
img_array = np.expand_dims(img_array, axis=0)  # Add batch dimension
img_array = img_array / 255.0  # Normalize as done during training

# Predict the class
predictions = loaded_model.predict(img_array, verbose=0)
predicted_class = np.argmax(predictions, axis=1)[0]

# Get the class name using the index
predicted_class_name = class_names[predicted_class]

# Create a dictionary for the prediction output
output = {
    "prediction": predicted_class_name
}

# Convert the dictionary to JSON format
print(json.dumps(output))
