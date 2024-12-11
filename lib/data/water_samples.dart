import '../models/water_sample_model.dart';

class WaterSamples {
  static const String jsonString = '''{
  "water_samples": [
    { "month": "January", "chlorine_wavelength": 520, "silver_wavelength": 430 },
    { "month": "February", "chlorine_wavelength": 515, "silver_wavelength": 435 },
    { "month": "March", "chlorine_wavelength": 530, "silver_wavelength": 440 },
    { "month": "April", "chlorine_wavelength": 525, "silver_wavelength": 445 },
    { "month": "May", "chlorine_wavelength": 540, "silver_wavelength": 450 },
    { "month": "June", "chlorine_wavelength": 535, "silver_wavelength": 455 },
    { "month": "July", "chlorine_wavelength": 550, "silver_wavelength": 460 },
    { "month": "August", "chlorine_wavelength": 545, "silver_wavelength": 465 },
    { "month": "September", "chlorine_wavelength": 560, "silver_wavelength": 470 },
    { "month": "October", "chlorine_wavelength": 555, "silver_wavelength": 475 },
    { "month": "November", "chlorine_wavelength": 570, "silver_wavelength": 480 },
    { "month": "December", "chlorine_wavelength": 565, "silver_wavelength": 485 }
  ]
}
''';
  static List<WaterSampleModel> samples = parseWaterSamples(jsonString);
}
