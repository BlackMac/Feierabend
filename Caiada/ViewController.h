//
//  ViewController.h
//  Caiada
//
//  Created by Stefan Lange-Hegermann on 01.05.15.
//  Copyright (c) 2015 Stefan Lange-Hegermann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLHCaiadaView.h"

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *currentDate;
@property (weak, nonatomic) IBOutlet UILabel *currentArrivalTime;
@property (weak, nonatomic) IBOutlet UILabel *currentLeavingTime;
@property (weak, nonatomic) IBOutlet SLHCaiadaView *currentProgressView;
@property (weak, nonatomic) IBOutlet UILabel *currentTimeIntervalToLeavingTime;
- (IBAction)pickArrivalDateNow:(id)sender;

@end

