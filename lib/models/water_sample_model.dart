import 'dart:convert';

class WaterSampleModel {
  final String month;
  final int chlorineWavelength;
  final int silverWavelength;

  WaterSampleModel({
    required this.month,
    required this.chlorineWavelength,
    required this.silverWavelength,
  });

  factory WaterSampleModel.fromJson(Map<String, dynamic> json) {
    return WaterSampleModel(
      month: json['month'],
      chlorineWavelength: json['chlorine_wavelength'],
      silverWavelength: json['silver_wavelength'],
    );
  }
}

List<WaterSampleModel> parseWaterSamples(String jsonString) {
  final data = json.decode(jsonString)['water_samples'] as List;
  return data.map((item) => WaterSampleModel.fromJson(item)).toList();
}
