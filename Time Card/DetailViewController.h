//
//  DetailViewController.h
//  Time Card
//
//  Created by Benjamin Humphries on 3/16/14.
//  Copyright (c) 2014 Chris Mays. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RemoveEmployeeViewController;
@interface DetailViewController : UIViewController{
       NSString *pin;
    NSString *name;
    NSInteger detailIndex;
}
-(void)setDetailIndex:(NSInteger)ndex;

@property (weak, nonatomic) IBOutlet UINavigationItem *navBar;
@property (nonatomic,retain)  NSString *name;
@property (nonatomic,retain)  NSString *pin;
@property (nonatomic) NSInteger detailIndex;
@end
