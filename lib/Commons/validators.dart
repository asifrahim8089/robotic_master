import 'package:form_field_validator/form_field_validator.dart';

final nameValidator = RequiredValidator(errorText: '*required');
final phoneValidator = MultiValidator([
  RequiredValidator(errorText: '*required'),
  MinLengthValidator(10, errorText: 'Enter a valid Mobile number'),
  MaxLengthValidator(10, errorText: 'Enter a valid Mobile number'),
]);
