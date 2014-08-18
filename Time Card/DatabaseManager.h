//
//  DatabaseManager.h
//  Time Card
//
//  Created by Chris Mays on 8/6/14.
//  Copyright (c) 2014 Chris Mays. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "Employee.h"
@interface DatabaseManager : NSObject{
    sqlite3 *_database;
}
+(DatabaseManager *) sharedManager;
-(Employee *)insertEmployee:(NSString*)name hourlyWageInCents:(int)hourly admin:(BOOL)isadmin;
-(Employee *)getEmployeeForPin:(NSString*)pin;
-(NSMutableDictionary *)getLastKnownActionForEmployee:(Employee *)emp;
-(BOOL)clockIn:(Employee *)emp;
-(BOOL)clockOut:(Employee *)emp;
-(BOOL)isCheckedIn:(Employee *)emp;
-(NSMutableArray *)getAllEmployees;
-(void)eraseClockDataForEmployee:(Employee *)emp startTime:(long long)time;
-(NSMutableArray *)getClockinsForEmployee:(Employee *)emp inBetweeenDate:(NSDate *)startDate andDate:(NSDate *)endDate;
-(NSMutableArray *)getPayPeriods;
-(NSMutableDictionary *)getPayForEmployee:(Employee *)emp withStartDate:(long long )start endDate:(long long )end;
-(BOOL)insertPayPeriodWithStartDate:(NSDate*)startDate endDate:(NSDate *)endDate;
-(BOOL)deletePayPeriodWithWithID:(long long)ppid;
-(BOOL)removePayTimeForEmployee:(Employee *)emp withStartTime:(long long)start;
-(bool)insertTimeForEmployee:(Employee *)emp withStartTime:(NSDate *)startTime withEndTime:(NSDate *)endTime;
@end
