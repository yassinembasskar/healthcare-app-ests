import openai
import os
import re
import extraction
import sys
import json
from dotenv import load_dotenv

load_dotenv()
openai_api_key = os.getenv("OPENAI_API_KEY")

if len(sys.argv) != 4:
    sys.exit(1)

image_path = sys.argv[1]
gender = sys.argv[2]
age = sys.argv[3]

message = extraction.getmessage(image_path)
message = message.replace('\n', ' ')
message = re.sub(r'\d{2}-\d{2}-\d{2,4}', '', message)

openai.api_key = openai_api_key

if message:
    messages = [{
        "role": "system", 
        "content": f"You are an intelligent medical data analyzer with expertise in interpreting lab results. Provided with OCR-extracted lab sample results {message} for a {age}-year-old {gender}, your task is to identify each test identifier and its value, then interpret each as 'bad,' 'normal,' or 'illogical' based on standard medical ranges. Structure each line in the following format: ```json{{'identifiant': 'test_name', 'value': 45, 'measurement': 'ml', 'interpretation': 'bad'}}```"
    }]

chat = openai.chat.completions.create(
    model="gpt-4o-mini", messages=messages, temperature=0.1
)
reply = chat.choices[0].message.content
reply = reply.replace("'", '"')

pattern = r'{.*?}'
matches = re.findall(pattern, reply, re.DOTALL)
data = [json.loads(match) for match in matches]
messages = [
{
    "role": "system",
    "content": (
        f"You are a knowledgeable and general doctor. Analyze the following medical data rows {data}, which contains information about a {age}-year-old {gender}. Perform the following tasks in a json format:\n\n"
        f"1. For each component in the data:\n"
        f"   - If the interpretation is 'bad,' provide a concise explanation of the issue tailored for the patient.\n"
        f"   - If the component is one of the following: glucose, platelets, cpk, serum sodium, serum creatinine, hemoglobin:\n"
        f"       - 'needed' must be true"
        f"       - Generate an additional boolean indicator as follows:\n"
        f"         - Hemoglobin: 'anemia' (True if the value suggests anemia, False otherwise).\n"
        f"         - Glucose: 'diabetes' (True if the value suggests diabetes, False otherwise).\n"
        f"       - Convert their value into the following standard units:\n"
        f"         - Hemoglobin: g/dL\n"
        f"         - Glucose: mg/dL\n"
        f"         - Platelets: kiloplatelets/mL\n"
        f"         - CPK: mcg/L\n"
        f"         - Serum creatinine: mg/dL\n"
        f"2. If any data is 'bad', recommend the type of doctor inside inside /*/ /*/ the patient should see from the following list:\n"
        f"   - Cardiologue, Endocrinologue, Gastro-entérologue, Hématologue, Néphrologue, Neurologue ,Oncologue médical, Pneumologue, Rhumatologue.\n\n"
        f"3. Return a json string for doctor_type and for infos that contain each component with the following attributes:\n"
        f"   - identifiant: Original identifier.\n"
        f"   - value: Converted or original value.\n"
        f"   - mesure: Converted or original unit.\n"
        f"   - interpretation: Original interpretation.\n"
        f"   - explanation: A concise explanation (only if interpretation is 'bad').\n"
        f"   - additional_info: A dictionary of any additional indicators (e.g., anemia, diabetes, etc.).\n"
        f"   - needed: True if the component is one of the mentionned components, otherwise False."
    )
}
]
chat = openai.chat.completions.create(
    model="gpt-4o-mini", messages=messages, temperature=0.1
)
reply = chat.choices[0].message.content

pattern = r"```json\s*(.*?)\s*```"
json_match = re.search(pattern, reply, re.DOTALL)

if json_match:
    json_string = json_match.group(1).strip() 
    try:
        json_data = json.loads(json_string)  
    except json.JSONDecodeError as e:
        print(f"Error decoding JSON: {e}")
else:
    print("No JSON block found.")
    
print(json_data)
def get_reply():
    return json_data
