//
//  AddEmployeeHoursViewController.h
//  Time Card
//
//  Created by Chris Mays on 8/12/14.
//  Copyright (c) 2014 Chris Mays. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Employee.h"
@interface AddEmployeeHoursViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIDatePicker *StartDatePicker;
@property (weak, nonatomic) IBOutlet UIDatePicker *EndDatePicker;
@property (nonatomic,retain) Employee *currentEmployee;
@end
