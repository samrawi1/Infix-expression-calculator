/***
 Copyright (c) 2010 Samuel Tribehou.
 Licensed under: whatever license you want.
 ***/

#define USE_APPLICATION_UNIT_TEST 1


#import <SenTestingKit/SenTestingKit.h>
#import <UIKit/UIKit.h>

#import "PostfixCalculator.h"
#import "SimpleStack.h"
#import "InfixToPostfix.h"
#import "InfixCalculator.h"

@interface OperationTestCase : SenTestCase {
	
}
@end


@implementation OperationTestCase

#if USE_APPLICATION_UNIT_TEST    

- (void) testStack{
	SimpleStack * stack = [[SimpleStack alloc] init];
	
	[stack push: @"a"];
	[stack push: @"b"];
	
	STAssertEquals([stack size],
						 2,
						 @"Stack size should have been 2", nil);
	
	NSString* item = [[stack pop] autorelease];
	STAssertEqualObjects(item,
						@"b",
						 @"Stack pop gave wrong item ??", nil);
	[stack pop];
	STAssertEquals([stack empty],
						 YES,
						 @"Stack should be empty", nil);
	
	
	[stack release];
}	


- (void) testPostfixComputation{
	PostfixCalculator *postfix = [[PostfixCalculator  alloc] init];
	  
	NSDecimalNumber * result = [postfix compute:@"5.202343 1 2 + 4 * + -3 -"];
	NSDecimalNumber * expected = [NSDecimalNumber decimalNumberWithString:@"20.202343"];

	STAssertEqualObjects(result, expected,
						 @"Postfix calculation error : unexpected result");
	
	expected = [NSDecimalNumber notANumber];
	result = [postfix compute:@"5 0 /"];
	
	STAssertEqualObjects(result, expected,
						 @"Postfix calculation error : divide by zero not handled properly");


	[postfix release];
}

- (void) testInfixToPostfix{

	InfixToPostfix *itp = [[InfixToPostfix alloc] init];
	NSString * result = [itp parseInfix:@"5 + ((123.2243224545 hgh + 2) *4) - -3^2  "];
	NSString * expected = @"5 123.2243224545 2 + 4 * + -3 2 ^ -";
	
	
	STAssertEqualObjects(result, expected,
						 @"Infix to Postfix conversion error");

	expected = nil;
	result = [itp parseInfix: @"("];
	
	STAssertEqualObjects(result, expected,
						 @"Infix to postfix : mismatched brackets not detected");
	
	[itp release];
}

- (void) testCalculator{
	InfixCalculator * calc = [[InfixCalculator alloc] init];

	
	STAssertEqualObjects([calc computeExpression: @"-3"], [NSDecimalNumber decimalNumberWithString: @"-3"],
						 @"Calculator result error");
	
	
	STAssertEqualObjects([calc computeExpression: @"(10.5656565656 * 2 + ((40 / 4) *4) / 4 *2 +20 *4 -78 - 0.5656565656 *2)^2"], 
						 [NSDecimalNumber decimalNumberWithString: @"1764"],
						 @"Calculator result error");

	
	STAssertEqualObjects(nil, 
	[calc computeExpression: @"(45345(2454"]					 
						 , @"Calculator should have returned null to an unbalanced expression");
	
	[calc release];
}

#endif


@end
