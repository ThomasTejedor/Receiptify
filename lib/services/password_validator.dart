import 'package:form_field_validator/form_field_validator.dart';

class UsernameValidator extends TextFieldValidator {
  UsernameValidator({String errorText = 'username is taken', this.userAvail = false}): super(errorText);

  bool userAvail;
  @override
  bool get ignoreEmptyValues => false;

  @override
  bool isValid(String? value) {
    return userAvail;
  }
}