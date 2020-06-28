import 'package:ednet/setup/login_page.dart';
import 'package:ednet/setup/onboarding_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main(){
    Widget makeTestableWidget({Widget child}){
        return MaterialApp(
            home: child,
        );
    }

    testWidgets('When user first opens the app, onboarding should start from page 1. Tapping on the next page should display page 2 of onboarding replacing the page 1', (WidgetTester tester) async {
        Widget widget = Onboarding(isLogin: false,);
        await tester.pumpWidget(makeTestableWidget(child: widget));
        //since login is false, we expect that onboarding starts from page1
        Finder page1 = find.byType(Page1);
        Finder page2 = find.byType(Page2);
        expect(page1, findsOneWidget);
        expect(page2, findsNothing);

        //when tapped on next button, the onboarding should display page2
        Finder nextButton = find.byKey(Key('nextButton'));
        expect(nextButton,findsOneWidget);
        await tester.tap(nextButton);
        //since the page view is animated transition from page1 to page2 we are telling flutter to wait till the animation completes to check our next expectation
        await tester.pumpAndSettle();
        expect(page2, findsOneWidget);
        expect(page1, findsNothing);
    });

    testWidgets('When user open the app not for the first time, onboarding should start from page 5 which has login page. tapping on previous button should display page 4 of onboarding replacing the login page', (WidgetTester tester) async {
        Widget widget = Onboarding(isLogin: true,);
        await tester.pumpWidget(makeTestableWidget(child: widget));
        //since login is false, we expect that onboarding starts from page1
        Finder loginPage = find.byType(LoginPage);
        expect(loginPage, findsOneWidget);

        //when tapped on next button, the onboarding should display page2
        Finder nextButton = find.byKey(Key('nextButton'));
        expect(nextButton,findsOneWidget);
        await tester.tap(nextButton);
        //since the page view is animated transition from page1 to page2 we are telling flutter to wait till the animation completes to check our next expectation
        await tester.pumpAndSettle();
        expect(loginPage, findsOneWidget);

        //when tapped on previous button, login page should move out of view and page 4 of onboarding should be displayed
        Finder prevButton = find.byKey(Key('prevButton'));
        expect(prevButton, findsOneWidget);
        await tester.tap(prevButton);
        await tester.pumpAndSettle();
        expect(loginPage, findsNothing);
        expect(find.byType(Page4), findsOneWidget);
    });
}