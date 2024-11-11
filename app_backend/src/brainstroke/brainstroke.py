import sys
import numpy as np
import pandas as pd
import pickle
import json

def main():
    data = sys.argv[1:]  
    
    columns = ['gender', 'age', 'hypertension', 'heart_disease', 'ever_married',
               'work_type', 'Residence_type', 'avg_glucose_level', 'bmi', 'smoking_status']

    df = pd.DataFrame([data], columns=columns)

    with open('C:\\Users\\HP\\Desktop\\PFE_PROJECT\\app_backend\\app\\src\\brainstroke\\BRModel.pkl', 'rb') as file:
        svm_model = pickle.load(file)

    y_pred = svm_model.predict(df)
    y_pred_value = y_pred[0] 
    
    y_pred_value1 = np.isscalar(y_pred_value)

    # pred_json = {
    #     "prediction2":y_pred,
    #     "prediction1": y_pred_value,
    #     "prediction":y_pred_value1
    # }
    
    # json_data = json.dumps(pred_json)
    print('{"prediction":'+str(y_pred[0])+"}")

    # return y_pred

if __name__ == "__main__":
    main()
