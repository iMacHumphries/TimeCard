//
//  EmailMessage.m
//  Time Card
//
//  Created by Benjamin Humphries on 6/24/14.
//  Copyright (c) 2014 Chris Mays. All rights reserved.
//

#import "EmailMessage.h"

@implementation EmailMessage
@synthesize message;
@synthesize employeeNames;
@synthesize employeeMonthlyHours;

- (id)init
{
    
    self = [super init];
    employeeNames = [[NSMutableArray alloc]init];
    employeeMonthlyHours = [[NSMutableArray alloc]init];
    message = [[NSMutableArray alloc] init];
    [self setupEmployeeNames];
    [self composeMessage];
    return self;
}

-(NSMutableArray *)getMessage{
    return message;
}

-(void)composeMessage{

    for (int i = 0; i <[employeeNames count]; i++) {
        NSString *msg = [[employeeNames objectAtIndex:i] stringByAppendingString:[employeeMonthlyHours objectAtIndex:i]];
        [message addObject:msg];

           }
    
   // message = [NSString stringWithFormat:@"%@  %@",employeeNames,employeeMonthlyHours];
   
    NSLog(@"%@",message);
    
}
-(void)setupEmployeeNames{

    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Employees" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    for (Employees *info in fetchedObjects) {
        NSString *hours =[self getTotalHoursWorkedForThisMonthForEmployee:info];
        [employeeMonthlyHours addObject:hours];
        [employeeNames addObject:[info valueForKey:@"name"]];
    }
}
-(NSString *)getTotalHoursWorkedForThisMonthForEmployee:(Employees *)currentEmployee{
    double totalSecondsWorked = 0.0;
    NSSet *hours=currentEmployee.employeesToAction;
    for(EmployeeAction *a in hours){
        if(a.employeeOut!=NULL && (a.archived==NULL || [a.archived boolValue]==false)){
            totalSecondsWorked+=[a.employeeOut.timeInitiated doubleValue]-[a.timeInitiated doubleValue];
           
        }
    }
    
   return [NSString stringWithFormat:@"      %f hours this month", totalSecondsWorked/(60*60)];
}
@end
