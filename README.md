Jquery validateForm Plugin
===================
Designed to be a simple and straight-forward way of adding validation to any form. No stylesheets to add.

## Installation

Include javascript file
```html
<script type="text/javascript" href="js/jquery.form-validator.min.js"></script>
```

Add data-validate to the input fields

```html
<input data-validate="string" type="text" />
```

Setup validation on the form
```javascript
$("form").validateForm();
```

## Validation Types

```
Type              Validation

String            Checks for the presence of a string
Email             Checks for a properly formated email address. Example: user@example.com
Check Box         Detects if the checkbox was checked
Phone             Removes all characters except numbers and checks for a length of 10
Number            Validates string contains only numbers
```

## Input Options

data-minlength
```html
<!-- Set the minimum length the text fields should be -->
<input data-minlength="5" data-validate="string" type="text" />
```

data-maxlength
```html
<!-- Set the maximum length the text fields should be -->
<input data-maxlength="20" data-validate="string" type="text" />
```

data-label
```html
<!-- Labels are used when displaying error message -->
<input data-label="First Name" data-validate="string" type="text" />
```

## Plugin Options

showRequired
```javascript
// Set mark used to display required fields
$("form").validateForm({
  showRequired: " * " // Default: "<span style=\"color:#CB4721;\"> *</span>"
});
```

requiredLocation
```javascript
// Tell plugin where to put required mark for field
$("form").validateForm({
  requiredLocation: " .field-label " // Default: "label"
});
```

errorMessageLocation
```javascript
// Set where error messages will appear
$("form").validateForm({
  errorMessageLocation: " .form-errors " // Default: ".error-message"
});
```

errorStyles
```javascript
// By default, the plugin adds styles to the head. You can set it to false, or add your own.
// errorStyles are for the input and label elements
$("form").validateForm({
  errorStyles: " .validation-error { background: #ff0000; } " // Default: "input.validation-error { border-color: #CB4721; } label.validation-error { color: #CB4721; } .validation-error { color: #CB4721; } "
});
```

errorMsgStyles
```javascript
// This sets the error message window style. You can set it to false, or add your own.
$("form").validateForm({
  errorMsgStyles: " .form-errors { background: #ff0000; } " // Default: "{placeholder} { padding: 1em 1.2em 0.6em; line-height: 1.5em; margin: 1em 0; display: none; color: #CB4721; border: 1px solid #FBD3C6; background-color: #FDE4E1; border-radius: 4px; }"
});
```

## Change error messages
```javascript
$("form").validateForm({
  msgMinLength      : "String not long enough",       // Default: "#{label} is too short (#{length} > #{minLength})"
  msgMaxLength      : "String too long",              // Default: "#{label} is too long (#{length} > #{maxLength})"
  msgInvalidEmail   : "Not a valid email",            // Default: "Invalid Email"
  msgCheckBox       : "Must check item",              // Default: "#{label} must be checked"
  msgPhoneMinLength : "Phone number not long enough", // Default: "Phone number must be 10 digits"
  msgPhoneMaxLength : "Phone number too long"         // Default: "Phone number must be 10 digits"
});
```
