//
//  RemoveEmployeeViewController.h
//  Time Card
//
//  Created by Benjamin Humphries on 3/15/14.
//  Copyright (c) 2014 Chris Mays. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RemoveEmployeeViewController : UITableViewController<UITableViewDataSource, UITableViewDelegate>{
    NSMutableArray *employeeNames;
    NSMutableArray *employeePins;
}
- (IBAction)editButtonPressed:(id)sender;
- (IBAction)doneButtonPressed:(id)sender;
- (IBAction)addEmployeeButton:(UIButton *)sender;
-(NSString *)getEmployeeNameForIndex:(int)ndex;
-(NSString *)getEmployeePinForIndex:(int)ndex;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@end
