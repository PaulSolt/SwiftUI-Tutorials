//
//  MyCalculator.h
//  Calculator
//
//  Created by Paul Solt on 4/5/25.
//

//#import <Foundation/Foundation.h>
@import Foundation;

typedef NS_ENUM(NSInteger, OperatorState) {
    Begin = 0,
    Processing,
    Finished,
};

@interface MyCalculator : NSObject

- (NSInteger)calculate;

@end
