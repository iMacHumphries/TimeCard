//
//  DetailPayPeriodViewController.h
//  Time Card
//
//  Created by Chris Mays on 8/12/14.
//  Copyright (c) 2014 Chris Mays. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailPayPeriodViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>{
    UITableView *payPeriodsTable;
}
@property (nonatomic,retain) NSMutableDictionary *timePeriods;
@property (nonatomic,retain) NSMutableArray *employeeInfo;

@property (weak, nonatomic) IBOutlet UILabel *NameLabel;
@property (weak, nonatomic) IBOutlet UILabel *HoursWorkedLabel;
@property (weak, nonatomic) IBOutlet UILabel *PayLabel;
@end
