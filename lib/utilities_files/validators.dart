/// This class is just to run unit tests on. due to some internal flutter error, I couldn't run tests on actual functions used in the app. Hence, instead I duplicated those functions and made this class.
class Validators {
  static String emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return "Email address is not valid";
    } else if (value.length == 0) {
      return "Please provide valid email";
    } else {
      return null;
    }
  }

  static String nameValidator(String value) {
    Pattern pattern = r'^[a-zA-Z ]*$';
    RegExp regExp = new RegExp(pattern);
    if (value.trim().length == 0) {
      return "We would like to know your name";
    } else if (!regExp.hasMatch(value.trim())) {
      return "Name can only contain alphabets";
    } else {
      return null;
    }
  }

  static String countryValidator(String value) {
    Pattern pattern = r'^[a-zA-Z ]*$';
    RegExp regExp = new RegExp(pattern);
    if (value.trim().length == 0) {
      return "Please provide Country.";
    } else if (!regExp.hasMatch(value.trim())) {
      return "Country name can contain only alphabets.";
    } else {
      return null;
    }
  }

  static String stateValidator(String value) {
    Pattern pattern = r'^[a-zA-Z ]*$';
    RegExp regExp = new RegExp(pattern);
    if (value.trim().length == 0) {
      return "Please provide Region or State.";
    } else if (!regExp.hasMatch(value.trim())) {
      return "Region/State name can contain only alphabets.";
    } else {
      return null;
    }
  }

  static String cityValidator(String value) {
    Pattern pattern = r'^[a-zA-Z ]*$';
    RegExp regExp = new RegExp(pattern);
    if (value.trim().length == 0) {
      return "Please provide City.";
    } else if (!regExp.hasMatch(value.trim())) {
      return "City name can contain only alphabets.";
    } else {
      return null;
    }
  }

  static String mobileNumberValidator(String value) {
    //TODO adapt to handle country code
    Pattern pattern = r'^[0-9]+$';
    RegExp regExp = new RegExp(pattern);
    if (value.trim().length == 0) {
      return "Please provide mobile number";
    } else if (value.trim().length != 10) {
      return "This mobile number is not valid";
    } else if (!regExp.hasMatch(value.trim())) {
      return "Mobile number can only containe numbers";
    } else {
      return null;
    }
  }

  static String questionHeadingValidator(value) {
    if (value.trim().length < 10) {
      return "Heading needs atleast 10 characters";
    } else {
      return null;
    }
  }

  static String questionDescriptionValidator(value) {
    if (value.trim().length < 20) {
      return "Please, describe question in atleast 20 characters";
    } else {
      return null;
    }
  }

  static String articleTitleValidator(value) {
    if (value.trim().length < 10) {
      return "Article title should be atleast 10 charactes long";
    } else {
      return null;
    }
  }

  static String articleSubtitleValidator(value) {
    if (value.trim().length < 20) {
      return "Article Subtitle should be atleast 20 charactes long";
    } else {
      return null;
    }
  }

  static String articleContentValidator(value) {
    if (value.trim().length < 100) {
      return "Article content should be atleast 100 charactes long";
    } else {
      return null;
    }
  }

  static String answerValidator(value) {
    if (value.trim().length < 100) {
      return "Please write answer atleast 100 characters long";
    } else {
      return null;
    }
  }

  static String reportCommentValidator(value) {
    if (value.trim().length < 10) {
      return "Description should be atleast 10 characters long";
    } else {
      return null;
    }
  }
}
