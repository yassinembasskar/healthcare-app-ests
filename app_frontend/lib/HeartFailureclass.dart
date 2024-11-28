class HeartFailure {
  int? HearthFailure_prediction_id;
  int? id_patient;
  int? anaemia;
  int? diabetes;
  dynamic creatinine_phosphokinase;
  int? high_blood_pressure;
  dynamic platelets;
  dynamic serum_creatinine;
  dynamic serum_sodium;
  int? smoking;
  int? time;

  HeartFailure({
    this.HearthFailure_prediction_id,
    this.id_patient,
    this.anaemia,
    this.diabetes,
    this.creatinine_phosphokinase,
    this.high_blood_pressure,
    this.platelets,
    this.serum_creatinine,
    this.serum_sodium,
    this.smoking,
    this.time,
  });

  Map<String, dynamic> toJson() {
    return {
      'HearthFailure_prediction_id': HearthFailure_prediction_id,
      'id_patient': id_patient,
      'anaemia': anaemia,
      'diabetes': diabetes,
      'creatinine_phosphokinase': creatinine_phosphokinase,
      'high_blood_pressure': high_blood_pressure,
      'platelets': platelets,
      'serum_creatinine': serum_creatinine,
      'serum_sodium': serum_sodium,
      'smoking': smoking,
      'time': time,
    };
  }

  factory HeartFailure.fromJson(Map<String, dynamic> json) {
    return HeartFailure(
      HearthFailure_prediction_id: json['HearthFailure_prediction_id'] as int?,
      id_patient: json['id_patient'] as int?,
      anaemia: json['anaemia'] as int?,
      diabetes: json['diabetes'] as int?,
      creatinine_phosphokinase: json['creatinine_phosphokinase'],
      high_blood_pressure: json['high_blood_pressure'] as int?,
      platelets: json['platelets'],
      serum_creatinine: json['serum_creatinine'],
      serum_sodium: json['serum_sodium'],
      smoking: json['smoking'] as int?,
      time: json['time'] as int?,
    );
  }
}
