import sys
import pandas as pd
import pickle
import json
import os

script_dir = os.path.dirname(__file__)

model_path = os.path.join(script_dir, 'HFModel.pkl')


def main():



    data =sys.argv[1:]  
    
    columns = ['age', 'anaemia', 'creatinine',
                'diabetes', 'high_blood_pressure',
                  'platelets',
                   'serum_creatinine', 'serum_sodium', 
                   'sex', 'smoking','time']

    
    df = pd.DataFrame([data], columns=columns)


    with open(model_path, 'rb') as file:
        HF_model = pickle.load(file)

    y_pred = HF_model.predict(df)
    y_pred_list = y_pred.tolist()

    
    pred_json = {
        "prediction": y_pred_list
    }
    
    json_data = json.dumps(pred_json)

    print('{"prediction":'+str(y_pred[0])+"}")

    return json_data
    

if __name__ == "__main__":
    main()


