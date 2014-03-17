//
//  DetailViewController.h
//  Time Card
//
//  Created by Benjamin Humphries on 3/16/14.
//  Copyright (c) 2014 Chris Mays. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Employees.h"
#import "EmployeeAction.h"
#import "EmployeeActionOut.h"
@class RemoveEmployeeViewController;
@interface DetailViewController : UIViewController{
       NSString *pin;
    NSString *name;
    NSInteger detailIndex;
}
-(void)setDetailIndex:(NSInteger)ndex;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *pinLabel;
@property (weak, nonatomic) IBOutlet UINavigationItem *navBar;
@property (nonatomic,retain)  NSString *name;
@property (nonatomic,retain)  NSString *pin;
@property (nonatomic,retain) Employees *currentEmployee;
@property (nonatomic) NSInteger detailIndex;
@property (weak, nonatomic) IBOutlet UILabel *hoursWorkedLabel;

@end