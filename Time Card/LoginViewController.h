//
//  LoginViewController.h
//  Time Card
//
//  Created by Benjamin Humphries on 3/13/14.
//  Copyright (c) 2014 Chris Mays. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Employees.h"
#import "EmployeeAction.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface LoginViewController : UIViewController<AVAudioPlayerDelegate>{
    NSMutableArray *pinArray;
    BOOL textFieldAlert;
    AVAudioPlayer* audioPlayer;
}
- (IBAction)pinButton:(UIButton *)sender;
- (IBAction)deleteButton:(UIButton *)sender;
- (IBAction)questionButton:(UIButton *)sender;
- (IBAction)admin:(UIButton *)sender;
@property (retain,nonatomic) NSMutableArray *pinArray;
@property (weak, nonatomic) IBOutlet UIImageView *indicator1;
@property (weak, nonatomic) IBOutlet UIImageView *indicator2;
@property (weak, nonatomic) IBOutlet UIImageView *indicator3;
@property (weak, nonatomic) IBOutlet UIImageView *indicator4;

@property (retain,nonatomic) AVAudioPlayer* audioPlayer;

@end
