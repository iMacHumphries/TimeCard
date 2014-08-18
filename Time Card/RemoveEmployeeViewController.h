//
//  RemoveEmployeeViewController.h
//  Time Card
//
//  Created by Benjamin Humphries on 3/15/14.
//  Copyright (c) 2014 Chris Mays. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Employees.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
@interface RemoveEmployeeViewController : UITableViewController<UITableViewDataSource, UITableViewDelegate,AVAudioPlayerDelegate>{
    NSMutableArray *employeeNames;
    NSMutableArray *employeePins;
    int editingIndex;
    NSIndexPath *editingIndexPath;
    AVAudioPlayer* audioPlayer;
    NSMutableArray *employees;
    
}
- (IBAction)editButtonPressed:(id)sender;
- (IBAction)doneButtonPressed:(id)sender;
- (IBAction)addEmployeeButton:(UIButton *)sender;

-(NSString *)getEmployeeNameForIndex:(int)ndex;
-(NSString *)getEmployeePinForIndex:(int)ndex;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (retain,nonatomic) AVAudioPlayer* audioPlayer;

@end
