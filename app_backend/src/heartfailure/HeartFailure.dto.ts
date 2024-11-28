import { User } from "src/user/patient/user.entity";
import { HeartFailure } from "./HeartFailure.entity";

export class HeartFailureDTO {
  HearthFailure_prediction_id: number;
  patient: User;
  anaemia: number;
  diabetes: number;
  creatinine_phosphokinase: number  ;
  high_blood_pressure: number;
  platelets: number;
  serum_creatinine: number;
  serum_sodium: number;
  smoking: number;
  time: number;

  constructor(heartFailure: HeartFailure) {
    this.HearthFailure_prediction_id = heartFailure.HearthFailure_prediction_id;
    this.patient = heartFailure.patient;
    this.anaemia = heartFailure.anaemia;
    this.diabetes = heartFailure.diabetes;
    this.creatinine_phosphokinase = heartFailure.creatinine_phosphokinase;
    this.high_blood_pressure = heartFailure.high_blood_pressure;
    this.platelets = heartFailure.platelets;
    this.serum_creatinine = heartFailure.serum_creatinine;
    this.serum_sodium = heartFailure.serum_sodium;
    this.smoking = heartFailure.smoking;
    this.time = heartFailure.time;
  }
}
