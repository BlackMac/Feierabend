//
//  InterfaceController.m
//  Feierabend Extension
//
//  Created by Stefan Lange-Hegermann on 28.03.16.
//  Copyright © 2016 Stefan Lange-Hegermann. All rights reserved.
//

#import "InterfaceController.h"
#import "SLHArrivalTimeManager.h"

@interface InterfaceController()
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *leavingTimeLabel;

@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    SLHArrivalTimeManager *manager = [SLHArrivalTimeManager sharedArrivalTimeManager];
    [self.leavingTimeLabel setText:[manager formattedLeavingTime]];
    // Configure interface objects here.
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end



