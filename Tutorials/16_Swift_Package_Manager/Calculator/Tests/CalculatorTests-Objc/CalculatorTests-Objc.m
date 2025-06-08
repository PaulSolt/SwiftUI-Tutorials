//
//  CalculatorTests-Objc.m
//  Calculator
//
//  Created by Paul Solt on 4/5/25.
//

//#import <XCTest/XCTest.h>

@import XCTest;
@import Calculator;

@interface CalculatorTests_Objc : XCTestCase

@end

@implementation CalculatorTests_Objc

- (void)setUp {
}

- (void)tearDown {
}

- (void)testExample {

    MyCalculator *calculator = [[MyCalculator alloc] init];

    XCTAssertEqual([calculator calculate], 27);
}


@end
