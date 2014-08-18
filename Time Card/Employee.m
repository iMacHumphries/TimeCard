//
//  Employee.m
//  Time Card
//
//  Created by Chris Mays on 3/13/14.
//  Copyright (c) 2014 Chris Mays. All rights reserved.
//

#import "Employee.h"

@implementation Employee

-(id)initWithName:(NSString *)_name withPin:(NSString *)_pin withHourlyCentsEarned:(int)_centsEarnedAnHour isAdmin:(bool)_isAdmin{
    self=[super init];
    name=_name;
    pin=_pin;
    centsEarnedAnHour=_centsEarnedAnHour;
    isAdmin=_isAdmin;
    return self;
}
-(NSString *)getName{
    return name;
}
-(int)getCentEarned{
    return centsEarnedAnHour;
}
-(BOOL)isAdmin{
    return isAdmin;
}
-(NSString *)getPin{
    return pin;
}
@end
