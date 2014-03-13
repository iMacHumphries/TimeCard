//
//  Employee.m
//  Time Card
//
//  Created by Chris Mays on 3/13/14.
//  Copyright (c) 2014 Chris Mays. All rights reserved.
//

#import "Employee.h"

@implementation Employee

-(id)initWithName:(NSString *)_name withPin:(NSString *)_pin{
    self=[super init];
    name=_name;
    pin=_pin;
    return self;
}

@end
