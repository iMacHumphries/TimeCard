//
//  DatabaseManager.m
//  Time Card
//
//  Created by Chris Mays on 8/6/14.
//  Copyright (c) 2014 Chris Mays. All rights reserved.
//

#import "DatabaseManager.h"
#import <sqlite3.h>
#import "Employee.h"
@implementation DatabaseManager

/**
    TimeLog: 
        StartTime int
        EndTime int
        InProgress int  - 1 if in progress
        EmployeeID  Int

 
        Primary Keys:StartTime, EmployeeID
 
 
 
 */

/**
    PayPeriods
        id PrimaryKey
        StartTime int
        EndTime   int

*/
/*
 
  Employees 
 EmployeeID int primary key,
 Name varchar(100), 
 Admin varchar(1),  -- 1 if admin
 HourlyRate BigInt);



*/
+(DatabaseManager *) sharedManager{
    static DatabaseManager *node;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        node = [[self alloc] init];
    });
    
    return node;
}


-(id)init{
    self=[super init];
    NSFileManager *manager=[NSFileManager defaultManager];
    NSArray *pathsArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    
    NSString *doumentDirectoryPath=[pathsArray objectAtIndex:0];
    NSString *dbDestination= [doumentDirectoryPath stringByAppendingPathComponent:@"timecardsv1.0.01.sqlite3"];
    if(![manager fileExistsAtPath:dbDestination]){
       NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"timecards.db"];
        
        //NSString *sourcePath=[[NSBundle mainBundle] pathForResource:@"timecards" ofType:@"db"];
        
        [manager copyItemAtPath:defaultDBPath toPath:dbDestination error:NULL];
    }else{
    }
    
    
    
    if (sqlite3_open([dbDestination UTF8String], &_database) != SQLITE_OK) {
        NSLog(@"Failed to open database!");
    }else{
        NSLog(@"it was ok");
    }
    //[self eraseallClockData];
    //[self clearAllEmployees:false];
    
    return self;
}



#pragma mark PayPeriodsData
-(NSMutableArray *)getPayPeriods{
    /***
     select * from PayPeriods
     
     */
    const char *query = (char *) [[NSString stringWithFormat:@"Select * from PayPeriods ORDER BY StartTime DESC"] UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(_database, query, -1, &statement, NULL)
        == SQLITE_OK) {
        NSMutableArray *list=[[NSMutableArray alloc] init];
        while(sqlite3_step(statement)==SQLITE_ROW)
        {
            char *idChars = (char *) sqlite3_column_text(statement, 0);
            char *startChars = (char *) sqlite3_column_text(statement, 1);
            char *endChars = (char *) sqlite3_column_text(statement, 2);
            long long idnum=[[[NSString alloc] initWithUTF8String:idChars] longLongValue];
            long long startTime=[[[NSString alloc] initWithUTF8String:startChars] longLongValue];
            long long endTime=[[[NSString alloc] initWithUTF8String:endChars] longLongValue];
            NSDictionary *object=[[NSMutableDictionary alloc] init];
            
            [object setValue:[NSNumber numberWithLongLong:idnum] forKey:@"ID"];
            [object setValue:[NSNumber numberWithLongLong:startTime] forKey:@"StartTime"];
            [object setValue:[NSNumber numberWithLongLong:endTime] forKey:@"EndTime"];
            [list addObject:object];
            
            
        }
        return list;
    }else{
        NSLog(@"Database returned error %d: %s", sqlite3_errcode(_database), sqlite3_errmsg(_database));
    }
    return NULL;
}


-(BOOL)insertPayPeriodWithStartDate:(NSDate*)startDate endDate:(NSDate *)endDate{
    long long start=[startDate timeIntervalSince1970];
    long long end =[endDate timeIntervalSince1970];
    const char *query = (char *) [[NSString stringWithFormat:@"insert into PayPeriods (StartTime, EndTime) VALUES(%lld,%lld)",start,end] UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(_database, query, -1, &statement, NULL)
        == SQLITE_OK) {
        if(sqlite3_step(statement)==SQLITE_DONE){
            return true;
        }
    }else{
        NSLog(@"Database returned error %d: %s", sqlite3_errcode(_database), sqlite3_errmsg(_database));
        
    }
    
    return false;
}

-(BOOL)deletePayPeriodWithWithID:(long long)ppid{
    const char *query = (char *) [[NSString stringWithFormat:@"Delete from PayPeriods where ID=%lld", ppid] UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(_database, query, -1, &statement, NULL)
        == SQLITE_OK) {
        if(sqlite3_step(statement)==SQLITE_DONE)
        {
            NSLog(@"it deleted");
            return true;
        }
        NSLog(@"it deleted");
        
    }else{
        NSLog(@"Database returned error %d: %s", sqlite3_errcode(_database), sqlite3_errmsg(_database));
        
    }
    
    return false;
}

#pragma mark ClockingData

-(NSNumber *)getLastClockOut:(Employee *)emp{
    const char *query = (char *)[[NSString stringWithFormat:@"select Endtime from TimeLog where EmployeeID=%@ ORDER BY EndTime DESC", [emp getPin]] UTF8String];
    sqlite3_stmt *statement;
    long long endTime=0;
    if (sqlite3_prepare_v2(_database, query, -1, &statement, NULL)
        == SQLITE_OK) {
        NSLog(@"it inserted");
        while(sqlite3_step(statement) == SQLITE_ROW) {
            char *endChars = (char *) sqlite3_column_text(statement, 0);
            endTime=[[[NSString alloc] initWithUTF8String:endChars] longLongValue];
            return [NSNumber numberWithLongLong:endTime];
        }
        NSLog(@"returning nill because I hate you");
        return NULL;
    }else{
        NSLog(@"error with query");
        return NULL;
    }
}
-(NSNumber *)getLastClockIn:(Employee *)emp{
    const char *query = (char *)[[NSString stringWithFormat:@"select StartTime from TimeLog where EmployeeID=%@ ORDER BY StartTime DESC", [emp getPin]] UTF8String];
    sqlite3_stmt *statement;
    long long endTime=0;
    if (sqlite3_prepare_v2(_database, query, -1, &statement, NULL)
        == SQLITE_OK) {
        NSLog(@"it inserted");
        if(sqlite3_step(statement) == SQLITE_ROW) {
            char *endChars = (char *) sqlite3_column_text(statement, 0);
            endTime=[[[NSString alloc] initWithUTF8String:endChars] longLongValue];
            return [NSNumber numberWithLongLong:endTime];
        }
        return NULL;
    }else{
        return NULL;
    }
}

-(BOOL)clockIn:(Employee *)emp{
    const char *query = (char *) [[NSString stringWithFormat:@"insert into TimeLog VALUES(%lld,'',1,%@,%d)",(long long)[[NSDate date] timeIntervalSince1970], [emp  getPin], [emp getCentEarned]] UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(_database, query, -1, &statement, NULL)
        == SQLITE_OK) {
        if(sqlite3_step(statement)==SQLITE_DONE)
        {
        NSLog(@"it inserted");
            return true;
        }else{
            return false;
        }
       
    }else{
        return false;
    }
    
}
-(BOOL)clockOut:(Employee *)emp{
    /*
     UPDATE TimeLog SET InProgress=0,EndTime=%lld WHERE InProgress=1 AND EmployeeID=%@;
     
     */
    const char *query = (char *) [[NSString stringWithFormat:@"UPDATE TimeLog SET InProgress=0,EndTime=%lld WHERE InProgress=1 AND EmployeeID=%@",(long long)[[NSDate date] timeIntervalSince1970], [emp  getPin]] UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(_database, query, -1, &statement, NULL)
        == SQLITE_OK) {
        if(sqlite3_step(statement)==SQLITE_DONE)
        {
            NSLog(@"it updated");
            return true;
        }else{
            return false;
        }
        
    }else{
        return false;
    }
    
}
-(void)eraseClockDataForEmployee:(Employee *)emp startTime:(long long)time{
    const char *query = (char *) [[NSString stringWithFormat:@"Delete from TimeLog where EmployeeID=%@ AND StartDate=%lld",[emp getPin], time] UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(_database, query, -1, &statement, NULL)
        == SQLITE_OK) {
        if(sqlite3_step(statement)==SQLITE_DONE)
        {
            NSLog(@"it deleted");
            
        }
        NSLog(@"it deleted");
        NSLog(@"Database returned error %d: %s", sqlite3_errcode(_database), sqlite3_errmsg(_database));
        
    }else{
        NSLog(@"Database returned error %d: %s", sqlite3_errcode(_database), sqlite3_errmsg(_database));
        
    }
}
-(void)eraseallClockData{
    const char *query = (char *) [[NSString stringWithFormat:@"Delete from TimeLog"] UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(_database, query, -1, &statement, NULL)
        == SQLITE_OK) {
        if(sqlite3_step(statement)==SQLITE_DONE)
        {
            NSLog(@"it deleted");

        }
        NSLog(@"it deleted");
        NSLog(@"Database returned error %d: %s", sqlite3_errcode(_database), sqlite3_errmsg(_database));

    }else{
        NSLog(@"Database returned error %d: %s", sqlite3_errcode(_database), sqlite3_errmsg(_database));

    }
}
#pragma mark EmployeeQueries


-(Employee *)getEmployeeForPin:(NSString*)pinnum {
    
    NSLog(@"pin %@",pinnum);
    const char *query = (char *)[[NSString stringWithFormat:@"Select  * from Employees where EmployeeID=%@",pinnum] UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_prepare_v2(_database, query, -1, &statement, NULL)
        == SQLITE_OK) {
        NSLog(@"it inserted");
        int pin=0;
        int admin=0;
        int hourlyRate=0;
        NSString *name;
        NSLog(@"%@", [NSString stringWithFormat:@"Select  * from Employees where EmployeeID=%@",pinnum]);
        if (sqlite3_step(statement) == SQLITE_ROW) {
            
            pin = sqlite3_column_int(statement, 0);
            char *nameChars = (char *) sqlite3_column_text(statement, 1);
            admin = sqlite3_column_int(statement, 2);
            hourlyRate = sqlite3_column_int(statement, 3);
            name = [[NSString alloc] initWithUTF8String:nameChars];
            sqlite3_finalize(statement);
            Employee *emp=[[Employee alloc] initWithName:name withPin:[NSString stringWithFormat:@"%d",pin] withHourlyCentsEarned:hourlyRate isAdmin:admin==1];
            return emp;
        }
        return NULL;
    }else{
        NSLog(@"return null error");
        return NULL;
    }/*
      }else{
      NSLog(@"Database returned error %d: %s", sqlite3_errcode(_database), sqlite3_errmsg(_database));
      }*/
    
}

-(NSMutableDictionary *)getLastKnownActionForEmployee:(Employee *)emp{
    
    NSMutableDictionary *data=[[NSMutableDictionary alloc] init];
    if([self isCheckedIn:emp]){
        [data setObject:@"ClockedIn" forKey:@"LastAction"];
        NSNumber *lastclockin=[self getLastClockIn:emp];
        if(lastclockin!=NULL){
            [data setObject:lastclockin forKey:@"LastTime"];
            return data;
        }else{
            return NULL;
        }
        
    }else{
        
        
        
        [data setObject:@"ClockedOut" forKey:@"LastAction"];
        NSNumber *lastclockout=[self getLastClockOut:emp];
        if(lastclockout!=NULL){
            [data setObject:lastclockout forKey:@"LastTime"];
            return data;
        }else{
            NSLog(@"last checkout was null");
            return NULL;
        }
        
    }
    
    return NULL;
    
}

-(Employee *)insertEmployee:(NSString*)name hourlyWageInCents:(int)hourly admin:(BOOL)isadmin {
    int adminNum=(isadmin?1:0);
    int generateRandomNum=(arc4random()%899)+1000;
    
    const char *query = (char *)[[NSString stringWithFormat:@"Insert into Employees values(%d,'%@',%d,%d)",generateRandomNum,name,adminNum,hourly] UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_prepare_v2(_database, query, -1, &statement, NULL)
        == SQLITE_OK) {
        if(sqlite3_step(statement)==SQLITE_DONE){
            NSLog(@"it inserted");
        }
        
        sqlite3_finalize(statement);
        Employee *emp=[[Employee alloc] initWithName:name withPin:[NSString stringWithFormat:@"%d",generateRandomNum] withHourlyCentsEarned:hourly isAdmin:isadmin];
        return emp;
        
    }else{
        return [self insertEmployee:name hourlyWageInCents:hourly admin:isadmin];
    }/*
      }else{
      NSLog(@"Database returned error %d: %s", sqlite3_errcode(_database), sqlite3_errmsg(_database));
      }*/
    
}
-(BOOL)isCheckedIn:(Employee *)emp{
    const char *query = (char *)[[NSString stringWithFormat:@"select * from TimeLog where InProgress=1 and EmployeeID=%@",[emp getPin]] UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(_database, query, -1, &statement, NULL)
        == SQLITE_OK) {
        NSLog(@"it inserted");
        if (sqlite3_step(statement) == SQLITE_ROW) {
            
            return true;
        }
        NSLog(@"returning null");
        return false;
    }else{
        NSLog(@"return null error");
        return false;
    }
    
    return false;
}

-(NSMutableArray *)getAllEmployees{
    NSMutableArray *employees=[[NSMutableArray alloc] init];
    const char *query = (char *)[[NSString stringWithFormat:@"Select * from Employees ORDER BY Admin, Name"] UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(_database, query, -1, &statement, NULL)
        == SQLITE_OK) {
        while(sqlite3_step(statement)==SQLITE_ROW)
        {
            int pin=0;
            int admin=0;
            int hourlyRate=0;
            NSString *name;
            pin = sqlite3_column_int(statement, 0);
            char *nameChars = (char *) sqlite3_column_text(statement, 1);
            admin = sqlite3_column_int(statement, 2);
            hourlyRate = sqlite3_column_int(statement, 3);
            name = [[NSString alloc] initWithUTF8String:nameChars];
            Employee *emp=[[Employee alloc] initWithName:name withPin:[NSString stringWithFormat:@"%d",pin] withHourlyCentsEarned:hourlyRate isAdmin:admin==1];
            [employees addObject:emp];
        }
        sqlite3_finalize(statement);

        return employees;
        
    }else{
        NSLog(@"Database returned error %d: %s", sqlite3_errcode(_database), sqlite3_errmsg(_database));
        
    }

    return NULL;
}

-(void)clearAllEmployees:(BOOL)adminToo{
    const char *query = (char *) [[NSString stringWithFormat:@"Delete from Employees where EmployeeID!=5667"] UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(_database, query, -1, &statement, NULL)
        == SQLITE_OK) {
        if(sqlite3_step(statement)==SQLITE_DONE)
        {
            NSLog(@"it deleted");
            
        }
        NSLog(@"it deleted");
        
    }else{
        NSLog(@"Database returned error %d: %s", sqlite3_errcode(_database), sqlite3_errmsg(_database));
        
    }
}

-(NSMutableArray *)getClockinsForEmployee:(Employee *)emp inBetweeenDate:(NSDate *)startDate andDate:(NSDate *)endDate{
    long long start=[startDate timeIntervalSince1970];
    long long end =[endDate timeIntervalSince1970];
    NSLog(@"start date= %lld end date= %lld", start, end);
    const char *query = (char *) [[NSString stringWithFormat:@"Select * from TimeLog where StartTime>=%lld AND StartTime<=%lld AND EmployeeID=%@ ORDER BY StartTime DESC",start, end, [emp getPin]] UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(_database, query, -1, &statement, NULL)
        == SQLITE_OK) {
        NSMutableArray *list=[[NSMutableArray alloc] init];
        while(sqlite3_step(statement)==SQLITE_ROW)
        {
            /**
             TODO: Create a list
             
             */
            char *startChars = (char *) sqlite3_column_text(statement, 0);
            char *endChars = (char *) sqlite3_column_text(statement, 1);
            char *inProgressChars = (char *) sqlite3_column_text(statement, 2);
            char *employeeIDChars = (char *) sqlite3_column_text(statement, 3);
            NSMutableDictionary *object=[[NSMutableDictionary alloc] init];
            long long startTime=[[[NSString alloc] initWithUTF8String:startChars] longLongValue];
            long long endTime=[[[NSString alloc] initWithUTF8String:endChars] longLongValue];
            int inProgress=[[[NSString alloc] initWithUTF8String:inProgressChars] intValue];
            NSString *employeeID=[[NSString alloc] initWithUTF8String:employeeIDChars];
            
            [object setValue:[NSNumber numberWithLongLong:startTime] forKey:@"StartTime"];
            [object setValue:[NSNumber numberWithLongLong:endTime] forKey:@"EndTime"];
            [object setValue:[NSNumber numberWithInt:inProgress] forKey:@"InProgress"];
            [object setValue:employeeID forKey:@"EmployeeID"];
            [list addObject:object];
            
            
            
            
        }
        return list;
    }
    else{
        NSLog(@"Database returned error %d: %s", sqlite3_errcode(_database), sqlite3_errmsg(_database));
    }
    NSLog(@"returning null");
    return NULL;
    
    
}
-(BOOL)removePayTimeForEmployee:(Employee *)emp withStartTime:(long long)start{
    const char *query = (char *) [[NSString stringWithFormat:@"Delete from TimeLog where EmployeeID=%@ AND StartTime=%lld", [emp getPin],start] UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(_database, query, -1, &statement, NULL)
        == SQLITE_OK) {
        if(sqlite3_step(statement)==SQLITE_DONE)
        {
            NSLog(@"it deleted");
            return true;
        }
        NSLog(@"it deleted");
        
    }else{
        NSLog(@"Database returned error %d: %s", sqlite3_errcode(_database), sqlite3_errmsg(_database));
        
    }
    return false;
}

#pragma mark TODO

/**
    Looks like it works I haven't gotten a chance to test it
 
 */
-(NSMutableDictionary *)getPayForEmployee:(Employee *)emp withStartDate:(long long )start endDate:(long long )end{
   
    /***
     select sum(hoursWorked) as HoursWorked, sum(minutesWorked) as MinutesWorked, sum(centsEarned)/100 as DollarsEarned, EmployeeID, Name from  (select Name,(EndTime-StartTime)/60/60 as hoursWorked, (EndTime-StartTime)/60%60 as minutesWorked,((EndTime-StartTime)/60/60)*HourlyRate+((EndTime-StartTime)/60%60)*(HourlyRate/60.0) centsEarned,startTime, endTime, inProgress, EmployeeID from TimeLog natural join Employees where starttime>=1409486400 AND starttime<=1409486400) group by EmployeeID, Name;

     
     */
    
    NSLog(@"start date= %lld end date= %lld", start, end);
    const char *query = (char *) [[NSString stringWithFormat:@"select sum(Endtime-Starttime)/60/60 hoursWorked, sum(Endtime-Starttime)/60%@60 minutesWorked, sum(((EndTime-StartTime)/60/60*(TimeLog.HourlyRate))+((EndTime-StartTime)/60%@60*(TimeLog.HourlyRate/60.0)))/100 as dollarsearned, Employees.EmployeeID, Name from timeLog inner join Employees on timeLog.EmployeeID=Employees.EmployeeID where starttime>=%lld AND Starttime<=%lld AND Employees.employeeID=%@ group by Employees.EmployeeID, Name",@"%",@"%",start, end, [emp getPin]] UTF8String];
    NSLog(@"%s",query);
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(_database, query, -1, &statement, NULL)
        == SQLITE_OK) {
        if(sqlite3_step(statement)==SQLITE_ROW)
        {
            char *hoursWorkedChar = (char *) sqlite3_column_text(statement, 0);
            char *minutesWorkedChar = (char *) sqlite3_column_text(statement, 1);
            char *DollarsEarnedChar = (char *) sqlite3_column_text(statement, 2);
            char *EmployeeIDChar = (char *) sqlite3_column_text(statement, 3);
            char *EmployeeNameChar = (char *) sqlite3_column_text(statement, 4);
            
            int hoursWorked=[[[NSString alloc] initWithUTF8String:hoursWorkedChar] intValue];
            int minutesWorked=[[[NSString alloc] initWithUTF8String:minutesWorkedChar] intValue];
            float dollarsEarned=[[[NSString alloc] initWithUTF8String:DollarsEarnedChar] floatValue];
            NSString *employeeID=[[NSString alloc] initWithUTF8String:EmployeeIDChar] ;
            NSString *employeeName=[[NSString alloc] initWithUTF8String:EmployeeNameChar] ;
            NSMutableDictionary *object=[[NSMutableDictionary alloc] init];
            [object setValue:[NSNumber numberWithInt:hoursWorked] forKey:@"HoursWorked"];
            [object setValue:[NSNumber numberWithInt:minutesWorked] forKey:@"MinutesWorked"];
            [object setValue:[NSNumber numberWithFloat:dollarsEarned] forKey:@"DollarsEarned"];
            [object setValue:employeeID forKey:@"EmployeeID"];
            [object setValue:employeeName forKey:@"EmployeeName"];
            return object;
            
            
            
        }
        NSMutableDictionary *object=[[NSMutableDictionary alloc] init];
        [object setValue:[NSNumber numberWithInt:0] forKey:@"HoursWorked"];
        [object setValue:[NSNumber numberWithInt:0] forKey:@"MinutesWorked"];
        [object setValue:[NSNumber numberWithFloat:0.0] forKey:@"DollarsEarned"];
        [object setValue:[emp getPin] forKey:@"EmployeeID"];
        [object setValue:[emp getName] forKey:@"EmployeeName"];
        NSLog(@"blank");
        return object;
    }else{
        NSLog(@"Database returned error %d: %s", sqlite3_errcode(_database), sqlite3_errmsg(_database));

    }
    NSLog(@"nill");
    return NULL;

}

-(bool)insertTimeForEmployee:(Employee *)emp withStartTime:(NSDate *)startTime withEndTime:(NSDate *)endTime{
    long long start=[startTime timeIntervalSince1970];
    long long end =[endTime timeIntervalSince1970];
    const char *query = (char *) [[NSString stringWithFormat:@"insert into TimeLog (StartTime, EndTime,InProgress,EmployeeID,HourlyRate) VALUES(%lld,%lld,0,%@,%d)",start,end, [emp getPin], [emp getCentEarned]] UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(_database, query, -1, &statement, NULL)
        == SQLITE_OK) {
        if(sqlite3_step(statement)==SQLITE_DONE){
            return true;
        }
    }else{
        NSLog(@"Database returned error %d: %s", sqlite3_errcode(_database), sqlite3_errmsg(_database));
        
    }
    
    return false;
}


@end
