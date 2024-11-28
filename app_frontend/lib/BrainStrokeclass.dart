import 'package:app/user_storage.dart';

class BrainStroke {
  int BrainStroke_prediction_id;
  int id_patient;
  String? hypertension;
  String? heart_disease;
  String? ever_married;
  String? work_type;
  String? residence_type;
  dynamic avg_glucose_level;
  dynamic bmi;
  String? smoking_status;

  BrainStroke({
    required this.BrainStroke_prediction_id,
    required this.id_patient,
    this.hypertension,
    this.heart_disease,
    this.ever_married,
    this.work_type,
    this.residence_type,
    this.avg_glucose_level,
    this.bmi,
    this.smoking_status,
  });
  Map<String, dynamic> toJson() {
    return {
      'BrainStroke_prediction_id': BrainStroke_prediction_id,
      'id_patient': id_patient,
      'hypertension': hypertension,
      'heart_disease': heart_disease,
      'ever_married': ever_married,
      'work_type': work_type,
      'residence_type': residence_type,
      'avg_glucose_level': avg_glucose_level,
      'bmi': bmi,
      'smoking_status': smoking_status,
    };
  }
 
  static Future<BrainStroke> fromJson(Map<String, dynamic> json) async {
    final userId = await UserStorage.getUserId(); // Wait for the Future to complete.
    return BrainStroke(
      BrainStroke_prediction_id: json['BrainStroke_prediction_id'] as int,
      id_patient: userId ?? 0, // Handle null case.
      hypertension: json['hypertension'].toString(),
      heart_disease: json['heart_disease'].toString(),
      ever_married: json['ever_married'].toString(),
      work_type: json['work_type'].toString(),
      residence_type: json['residence_type'].toString(),
      avg_glucose_level: json['avg_glucose_level'],
      bmi: json['bmi'],
      smoking_status: json['smoking_status'].toString(),
    );
  }
}