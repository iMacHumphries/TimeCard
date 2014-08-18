//
//  ViewPayPeriodsViewController.h
//  Time Card
//
//  Created by Chris Mays on 8/12/14.
//  Copyright (c) 2014 Chris Mays. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewPayPeriodsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>{
    UITableView *payPeriodsTable;
    NSMutableArray *payperiodsArray;
}
- (IBAction)cancelButtonPressed:(id)sender;

@end
