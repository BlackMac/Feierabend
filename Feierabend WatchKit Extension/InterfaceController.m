//
//  InterfaceController.m
//  Feierabend WatchKit Extension
//
//  Created by Stefan Lange-Hegermann on 19.05.15.
//  Copyright (c) 2015 Stefan Lange-Hegermann. All rights reserved.
//

#import "InterfaceController.h"
#import "SLHCaiadaView.h"
#import "SLHArrivalTimeManager.h"

@interface InterfaceController()

@end


@implementation InterfaceController

+ (UIImage *) imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:NO];
    UIImage *capturedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return capturedImage;
}

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    // Configure interface objects here.
}

- (void)willActivate {
    SLHArrivalTimeManager *timeManager = [SLHArrivalTimeManager sharedArrivalTimeManager];
    [self.leavingTimeLabel setText:[NSString stringWithFormat:@"um %@", [timeManager formattedLeavingTime]]];
    [self.remainingTimeLabel setText:[NSString stringWithFormat:@"noch %@", [timeManager formattedRemainingTime]]];
    CGRect watchScreen = [[WKInterfaceDevice currentDevice] screenBounds];
    CGRect rectangularRect = CGRectMake(0, 0, watchScreen.size.width*0.65, watchScreen.size.width*0.65);
    SLHCaiadaView *timeView = [[SLHCaiadaView alloc] initWithFrame:rectangularRect];
    [timeView awakeFromNib];
    [timeView setElapsed:[timeManager getElapsed]];
    [timeView setBounds:rectangularRect];
    timeView.lineWidth = 6.0;
    timeView.circleBackgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.1];
    timeView.circleProgressColor = [UIColor colorWithRed:0 green:1 blue:1 alpha:1];
    
    
    UIImage *image = [InterfaceController imageWithView:timeView];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Image-UIViewDemo.png"];
    
    // Save image.
    [UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES];
    //[[WKInterfaceDevice currentDevice] addCachedImage:image name:@"test"];
    [self.remainingTimeImage setImage:image];
    
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end



