import sys
import numpy as np
import pandas as pd
import pickle
import json
import os

MODEL_PATH = os.getenv("MODEL_PATH", "src/brainstroke/BRModel.pkl")

def main():
    try:
        if len(sys.argv) != 11:
            raise ValueError("Incorrect number of arguments. Expected 10 input values.")
        
        data = sys.argv[1:] 
        
        if not all(isinstance(val, str) for val in data):
            raise ValueError("All input values must be strings.")
        
        columns = ['gender', 'age', 'hypertension', 'heart_disease', 'ever_married',
                   'work_type', 'Residence_type', 'avg_glucose_level', 'bmi', 'smoking_status']
        
        df = pd.DataFrame([data], columns=columns)
        
        if not os.path.exists(MODEL_PATH):
            raise FileNotFoundError(f"Model file not found: {MODEL_PATH}")
        
        with open(MODEL_PATH, 'rb') as file:
            svm_model = pickle.load(file)
        
        y_pred = svm_model.predict(df)
        y_pred_value = y_pred[0]

        prediction_result = {
            "prediction": y_pred_value,
            "message": "Prediction indicates whether a stroke risk is present based on the input data."
        }
        
        print(json.dumps(prediction_result))

    except Exception as e:
        error_message = {"error": str(e)}
        print(json.dumps(error_message))
    
    # data = sys.argv[1:]  
    
    # columns = ['gender', 'age', 'hypertension', 'heart_disease', 'ever_married',
    #         'work_type', 'Residence_type', 'avg_glucose_level', 'bmi', 'smoking_status']

    # df = pd.DataFrame([data], columns=columns)

    # with open(model_path, 'rb') as file:
    #     svm_model = pickle.load(file)

    # y_pred = svm_model.predict(df)
    # y_pred_value = y_pred[0] 
    
    # y_pred_value1 = np.isscalar(y_pred_value)

    # # pred_json = {
    # #     "prediction2":y_pred,
    # #     "prediction1": y_pred_value,
    # #     "prediction":y_pred_value1
    # # }
    
    # # json_data = json.dumps(pred_json)
    # print('{"prediction":'+str(y_pred[0])+"}")

    # # return y_pred

if __name__ == "__main__":
    main()
