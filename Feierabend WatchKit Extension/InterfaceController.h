//
//  InterfaceController.h
//  Feierabend WatchKit Extension
//
//  Created by Stefan Lange-Hegermann on 19.05.15.
//  Copyright (c) 2015 Stefan Lange-Hegermann. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>

@interface InterfaceController : WKInterfaceController
@property (weak, nonatomic) IBOutlet WKInterfaceImage *remainingTimeImage;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *remainingTimeLabel;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *leavingTimeLabel;

@end
