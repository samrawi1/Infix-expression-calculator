//
//  InfixCalculator.m
//  infix-expression-calculator
//
//  Created by Samuel Tribehou on 28/06/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "InfixCalculator.h"


@implementation InfixCalculator

- (InfixCalculator*) init{
	self = [super init];
	if (self){
		itp = [[InfixToPostfix alloc] init];
		postCalc = [[PostfixCalculator alloc] init];
	}
	return self;
}

- (void) dealloc{
	[itp release];
	[postCalc release];
	[super dealloc];
}

- (NSDecimalNumber*) computeExpression: (NSString*) infixExpression {
	NSString* postfixExpression = [itp parseInfix: infixExpression];
	NSDecimalNumber *result = nil;
	
	if ([itp hasErrors])
		NSLog(@"Error while transforming expression to infix");
	else {
		result = [postCalc compute: postfixExpression];
		if ([postCalc hasErrors])
			NSLog(@"Error while calculating postix expression result");
	}

	return result;
}

@end