//
//  GlanceController.m
//  Feierabend WatchKit Extension
//
//  Created by Stefan Lange-Hegermann on 19.05.15.
//  Copyright (c) 2015 Stefan Lange-Hegermann. All rights reserved.
//

#import "GlanceController.h"
#import "SLHCaiadaView.h"

@interface GlanceController()

@end


@implementation GlanceController

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
    SLHCaiadaView *timeView = [[SLHCaiadaView alloc] initWithFrame:CGRectMake(0, 0, 120, 120)];
    [timeView awakeFromNib];
    [timeView setElapsed:0.5];
    [timeView setBounds:CGRectMake(0, 0, 120, 120)];
    UIImage *image = [GlanceController imageWithView:timeView];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Image-UIViewDemo.png"];
    
    // Save image.
    [UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES];
    //[[WKInterfaceDevice currentDevice] addCachedImage:image name:@"test"];
    [self.mainInterfaceImage setImage:image];
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end



