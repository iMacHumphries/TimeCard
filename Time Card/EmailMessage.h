//
//  EmailMessage.h
//  Time Card
//
//  Created by Benjamin Humphries on 6/24/14.
//  Copyright (c) 2014 Chris Mays. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "Employees.h"
#import "EmployeeAction.h"
#import "EmployeeActionOut.h"

@interface EmailMessage : NSObject{
    NSMutableArray *employeeNames;
    NSMutableArray *employeeMonthlyHours;
    NSMutableArray *message;
    
}
-(NSMutableArray *)getMessage;
@property (nonatomic, retain)NSMutableArray *employeeNames;
@property (nonatomic, retain)NSMutableArray *employeeMonthlyHours;
@property (nonatomic, retain)NSMutableArray *message;
@end
