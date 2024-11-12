import sys

import pandas as pd

import pickle
import json
import os

script_dir = os.path.dirname(__file__)

model_path = os.path.join(script_dir, 'HFModel.pkl')


def main():



    data =sys.argv[1:]  
    # print(data)
    
    columns = ['age', 'anaemia', 'creatinine',
                'diabetes', 'high_blood_pressure',
                  'platelets',
                   'serum_creatinine', 'serum_sodium', 
                   'sex', 'smoking','time']

    
    df = pd.DataFrame([data], columns=columns)

    # print('DataFrame:')
    # print(df)

    # print('Before loading model')
    with open(model_path, 'rb') as file:
        HF_model = pickle.load(file)

    # print('Before prediction model')
    y_pred = HF_model.predict(df)
    y_pred_list = y_pred.tolist()

    
   
    # y_pred_list = 0
    pred_json = {
        "prediction": y_pred_list
    }
    
    json_data = json.dumps(pred_json)

    # print(json_data)
    print('{"prediction":'+str(y_pred[0])+"}")

    return json_data
    

if __name__ == "__main__":
    main()


