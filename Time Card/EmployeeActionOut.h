//
//  EmployeeActionOut.h
//  Time Card
//
//  Created by Chris Mays on 3/17/14.
//  Copyright (c) 2014 Chris Mays. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class EmployeeAction;

@interface EmployeeActionOut : NSManagedObject

@property (nonatomic, retain) NSString * month;
@property (nonatomic, retain) NSNumber * timeInitiated;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSNumber * year;
@property (nonatomic, retain) EmployeeAction *emplyeeIn;

@end
