//
//  Employee.h
//  Time Card
//
//  Created by Chris Mays on 3/13/14.
//  Copyright (c) 2014 Chris Mays. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Employee : NSObject {
        NSString *name;
        NSString *pin;
        int centsEarnedAnHour;
        BOOL isAdmin;
}

-(NSString *)getName;
-(int)getCentEarned;
-(BOOL)isAdmin;
-(NSString *)getPin;
-(id)initWithName:(NSString *)_name withPin:(NSString *)_pin withHourlyCentsEarned:(int)_centsEarnedAnHour isAdmin:(bool)_isAdmin;

@end
