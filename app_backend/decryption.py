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
import subprocess
subprocess.run(['python', 'decryption.py', image_path])
message = extraction.getmessage(image_path)
openai.api_key = openai_api_key
messages = [ {"role": "system", "content": "you are an intelligent decrypter with medical knwoledge, you' ve been given a text containing lab sample results extracted using ocr. It's known that these tests are for a {age}-year-old {gender}. Your task is identify the identifiant and its value and interpret those values as either 'low', 'normal' or 'high'. and formulate every line like this: \{\"identifiant\"\:\"something\",\"value\":\"45\",\"mesurement\": \"ml\"', \|\"interpretation\":\"low\"} and make sure to convert the french characters to the english ones for example e accent to e, for the creatinine the mesure must be in mg/dL, and for cpk mcg/L, and for sodium mEq/L"} ]
if message:
        messages.append(
            {"role": "user", "content": message},
        )
chat = openai.chat.completions.create(
    model="gpt-3.5-turbo", messages=messages, temperature=0.3
)
reply = chat.choices[0].message.content
pattern = r'{.*?}'
matches = re.findall(pattern, reply, re.DOTALL)
data = [json.loads(match) for match in matches]
print(data)
def get_reply():
    return data