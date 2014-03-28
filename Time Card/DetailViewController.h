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
#import <MessageUI/MessageUI.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>


@class RemoveEmployeeViewController;
@interface DetailViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,MFMailComposeViewControllerDelegate,AVAudioPlayerDelegate>{
       NSString *pin;
    NSString *name;
    NSInteger detailIndex;
   IBOutlet UITableView *tableView;
    NSMutableArray *clockedInDate;
    int selectedButtonIndex;
    AVAudioPlayer* audioPlayer;
}
-(void)setDetailIndex:(NSInteger)ndex;

@property (retain,nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *pinLabel;
@property (weak, nonatomic) IBOutlet UINavigationItem *navBar;
@property (nonatomic,retain)  NSString *name;
@property (nonatomic,retain)  NSString *pin;
@property (nonatomic,retain) Employees *currentEmployee;
@property (nonatomic) NSInteger detailIndex;
@property (weak, nonatomic) IBOutlet UILabel *hoursWorkedLabel;
@property (nonatomic, retain) NSMutableArray *clockedInDate;

- (IBAction)dayButton:(UIButton *)sender;
- (IBAction)monthButton:(UIButton *)sender;
- (IBAction)yearButton:(UIButton *)sender;
- (IBAction)allButton:(UIButton *)sender;
- (IBAction)payPeriodButton:(UIButton *)sender;
- (IBAction)emailButton:(UIBarButtonItem *)sender;
- (IBAction)questionButton:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *dayButton;
@property (weak, nonatomic) IBOutlet UIButton *monthButton;
@property (weak, nonatomic) IBOutlet UIButton *yearButton;
@property (weak, nonatomic) IBOutlet UIButton *allButton;
@property (weak, nonatomic) IBOutlet UIButton *payPeriodButton;

@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (retain,nonatomic) AVAudioPlayer* audioPlayer;
@end
