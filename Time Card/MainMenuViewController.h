//
//  MainMenuViewController.h
//  Time Card
//
//  Created by Benjamin Humphries on 3/14/14.
//  Copyright (c) 2014 Chris Mays. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "Employees.h"
#import "EmployeeAction.h"
#import "EmployeeActionOut.h"
#import <MessageUI/MessageUI.h>
#import "EmailMessage.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "Employee.h"
@interface MainMenuViewController : UIViewController<MFMailComposeViewControllerDelegate,AVAudioPlayerDelegate>{
    NSArray *praise;
    AVAudioPlayer* audioPlayer;
    
}

@property (nonatomic, retain) Employee *employee;
@property (weak, nonatomic) IBOutlet UILabel *welcomeLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastLoginLabel;
@property (weak, nonatomic) IBOutlet UIButton *clockInOutButton;
@property (weak, nonatomic) IBOutlet UIButton *addEmployeeButton;
@property (weak, nonatomic) IBOutlet UIButton *manageEmployees;
@property (weak, nonatomic) IBOutlet UIButton *emailTimeSheetButton;

- (IBAction)addEmployeeButton:(UIButton *)sender;

- (IBAction)clockInOutButton:(UIButton *)sender;
- (IBAction)cancelButton:(UIButton *)sender;
- (IBAction)emailButton:(UIButton *)sender;
- (IBAction)manageEmployeeButton:(UIButton *)sender;
@property (retain,nonatomic) AVAudioPlayer* audioPlayer;


@end
