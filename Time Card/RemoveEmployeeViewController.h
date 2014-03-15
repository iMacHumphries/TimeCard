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
}
- (IBAction)editButtonPressed:(id)sender;
- (IBAction)doneButtonPressed:(id)sender;


@property (strong, nonatomic) IBOutlet UITableView *tableView;
@end
