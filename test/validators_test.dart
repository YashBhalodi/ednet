import 'package:ednet/utilities_files/validators.dart';
import 'package:test/test.dart';
void main(){
    group('Email Validators:-', (){
        //if the result is null, that means no error is reported. otherwise the result will be considered error message
        test('Empty email throws error',(){
            String result = Validators.emailValidator('');
            expect(result, isNotNull);
        });
        test('Invalid email throws error: "email.com"',(){
            String result = Validators.emailValidator('email.com');
            expect(result, isNotNull);
        });
        test('Valid email accepted: "abc@xyz.com"',(){
            String result = Validators.emailValidator('abc@xyz.com');
            expect(result, isNull);
        });
    });

    group('Name Validators:-', (){
        test('Empty name gives error', (){
            String result = Validators.nameValidator('');
            expect(result, isNotNull);
        });
        test('Non-alphabetic name gives error: Yash12', (){
            String result = Validators.nameValidator('Yash12');
            expect(result, isNotNull);
        });
        test('Valid name accepted: Yash', (){
            String result = Validators.nameValidator('Yash');
            expect(result, isNull);
        });
        test('Valid name with spaces accepted: Yash Bhalodi', (){
            String result = Validators.nameValidator('Yash Bhalodi');
            expect(result, isNull);
        });
    });

    group('Country Validators:-', (){
        test('Empty country gives error', (){
            String result = Validators.nameValidator('');
            expect(result, isNotNull);
        });
        test('Non-alphabetic country gives error: India12', (){
            String result = Validators.nameValidator('India12');
            expect(result, isNotNull);
        });
        test('Valid country accepted: India', (){
            String result = Validators.nameValidator('India');
            expect(result, isNull);
        });
        test('Valid country with spaces accepted: South Korea', (){
            String result = Validators.nameValidator('South Korea');
            expect(result, isNull);
        });
    });

    group('State Validators:-', (){
        test('Empty state gives error', (){
            String result = Validators.nameValidator('');
            expect(result, isNotNull);
        });
        test('Non-alphabetic state gives error: Gujarat12', (){
            String result = Validators.nameValidator('Gujarat12');
            expect(result, isNotNull);
        });
        test('Valid state accepted: Gujarat', (){
            String result = Validators.nameValidator('Gujarat');
            expect(result, isNull);
        });
        test('Valid state with spaces accepted: Las Vegas', (){
            String result = Validators.nameValidator('Las Vegas');
            expect(result, isNull);
        });
    });

    group('City Validators:-', (){
        test('Empty city gives error', (){
            String result = Validators.nameValidator('');
            expect(result, isNotNull);
        });
        test('Non-alphabetic city gives error: Area 51', (){
            String result = Validators.nameValidator('Area 51');
            expect(result, isNotNull);
        });
        test('Valid city accepted: Delhi', (){
            String result = Validators.nameValidator('Delhi');
            expect(result, isNull);
        });
        test('Valid city with spaces accepted: New York', (){
            String result = Validators.nameValidator('New York');
            expect(result, isNull);
        });
    });

    group('Mobile Number Validators:-', (){
        test('Empty number gives error', (){
            String result = Validators.mobileNumberValidator('');
            expect(result, isNotNull);
        });
        test('9 digit number gives error: 123456789', (){
            String result = Validators.mobileNumberValidator('123456789');
            expect(result, isNotNull);
        });
        test('11 digit number gives error: 12345678901', (){
            String result = Validators.mobileNumberValidator('12345678901');
            expect(result, isNotNull);
        });
        test('Alphabetic number gives error: 123ab6789', (){
            String result = Validators.mobileNumberValidator('123ab6789');
            expect(result, isNotNull);
        });
        test('10 digit number with special character gives error: 1234@!7890', (){
            String result = Validators.mobileNumberValidator('1234@!7890');
            expect(result, isNotNull);
        });
        test('10 digit number accepted: 1234567890', (){
            String result = Validators.mobileNumberValidator('1234567890');
            expect(result, isNull);
        });
    });

    group('Question Heading Validators:-', (){
        test('Less than 10 characters gives error: "Who is it"', (){
            String result = Validators.questionHeadingValidator("Who is it");
            expect(result, isNotNull);
        });
        test('Less than 10 characters excluding trailing spaces gives error: "Who is it   "', (){
            String result = Validators.questionHeadingValidator("Who is it   ");
            expect(result, isNotNull);
        });
        test('10 characters accepted: "What is it"', (){
            String result = Validators.questionHeadingValidator("What is it");
            expect(result, isNull);
        });
    });

    group('Question Description Validators:-', (){
        test('Less than 20 characters gives error: "What do I do?"', (){
            String result = Validators.questionDescriptionValidator("What do I do?");
            expect(result, isNotNull);
        });
        test('Less than 20 characters excluding trailing spaces gives error: "What do I do?             "', (){
            String result = Validators.questionDescriptionValidator("What do I do?             ");
            expect(result, isNotNull);
        });
        test('20 characters accepted: "This is 20 character"', (){
            String result = Validators.questionDescriptionValidator("This is 20 character");
            expect(result, isNull);
        });
    });

    group('Article Title Validators:-', (){
        test('Less than 10 characters gives error: "Who is it"', (){
            String result = Validators.articleTitleValidator("Who is it");
            expect(result, isNotNull);
        });
        test('Less than 10 characters excluding trailing spaces gives error: "Who is it   "', (){
            String result = Validators.articleTitleValidator("Who is it   ");
            expect(result, isNotNull);
        });
        test('10 characters accepted: "What is it"', (){
            String result = Validators.articleTitleValidator("What is it");
            expect(result, isNull);
        });
    });

    group('Article Subtitle Validators:-', (){
        test('Less than 20 characters gives error: "What do I do?"', (){
            String result = Validators.articleSubtitleValidator("What do I do?");
            expect(result, isNotNull);
        });
        test('Less than 20 characters excluding trailing spaces gives error: "What do I do?             "', (){
            String result = Validators.articleSubtitleValidator("What do I do?             ");
            expect(result, isNotNull);
        });
        test('20 characters accepted: "This is 20 character"', (){
            String result = Validators.articleSubtitleValidator("This is 20 character");
            expect(result, isNull);
        });
    });

    group('Article Content Validators:-', (){
        test('Less than 100 characters gives error: "What do I do?"', (){
            String result = Validators.articleContentValidator("What do I do?");
            expect(result, isNotNull);
        });
        test('Less than 100 characters excluding trailing spaces gives error: "What do I do?             "', (){
            String result = Validators.articleContentValidator("What do I do?             ");
            expect(result, isNotNull);
        });
        test('100 characters or more accepted: "A husband and wife are sitting in their car. The husband say: What would you do if I won the lottery?""', (){
            String result = Validators.articleContentValidator("A husband and wife are sitting in their car. The husband say: What would you do if I won the lottery?");
            expect(result, isNull);
        });
    });

    group('Answer Validators:-', (){
        test('Less than 100 characters gives error: "This is what you do"', (){
            String result = Validators.answerValidator("This is what you do");
            expect(result, isNotNull);
        });
        test('Less than 100 characters excluding trailing spaces gives error: "This is what you do          "', (){
            String result = Validators.answerValidator("This is what you do          ");
            expect(result, isNotNull);
        });
        test('100 characters or more accepted: "A husband and wife are sitting in their car. The husband say: What would you do if I won the lottery?""', (){
            String result = Validators.answerValidator("A husband and wife are sitting in their car. The husband say: What would you do if I won the lottery?");
            expect(result, isNull);
        });
    });

    group('Report Comment Validators:-', (){
        test('Less than 10 characters gives error: "Who is it"', (){
            String result = Validators.reportCommentValidator("Who is it");
            expect(result, isNotNull);
        });
        test('Less than 10 characters excluding trailing spaces gives error: "Who is it   "', (){
            String result = Validators.reportCommentValidator("Who is it   ");
            expect(result, isNotNull);
        });
        test('10 characters accepted: "What is it"', (){
            String result = Validators.reportCommentValidator("What is it");
            expect(result, isNull);
        });
    });
}