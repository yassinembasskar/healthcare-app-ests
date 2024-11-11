import { BrainStroke } from "./BrainStroke.entity";

export class BrainStrokeDTO {
    BrainStroke_prediction_id: number;
    id_patient: number;
    hypertension: boolean;
    heart_disease: boolean;
    ever_married: string;
    work_type: string;
    residence_type: string;
    avg_glucose_level: number;
    bmi: number;
    smoking_status: string;
  
    constructor(entity: BrainStroke) {
      this.BrainStroke_prediction_id = entity.BrainStroke_prediction_id;
      this.id_patient = entity.id_patient;
      this.hypertension = entity.hypertension;
      this.heart_disease = entity.heart_disease;
      this.ever_married = entity.ever_married;
      this.work_type = entity.work_type;
      this.residence_type = entity.residence_type;
      this.avg_glucose_level = entity.avg_glucose_level;
      this.bmi = entity.bmi;
      this.smoking_status = entity.smoking_status;
    }
  }
  