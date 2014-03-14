//
//  Employees.h
//  Time Card
//
//  Created by Chris Mays on 3/14/14.
//  Copyright (c) 2014 Chris Mays. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class EmployeeAction;

@interface Employees : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * pin;
@property (nonatomic, retain) NSSet *employeesToAction;
@end

@interface Employees (CoreDataGeneratedAccessors)

- (void)addEmployeesToActionObject:(EmployeeAction *)value;
- (void)removeEmployeesToActionObject:(EmployeeAction *)value;
- (void)addEmployeesToAction:(NSSet *)values;
- (void)removeEmployeesToAction:(NSSet *)values;

@end
