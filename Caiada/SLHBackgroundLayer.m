//
//  SLHBackgroundLayer.m
//  Caiada
//
//  Created by Stefan Lange-Hegermann on 28.03.16.
//  Copyright © 2016 Stefan Lange-Hegermann. All rights reserved.
//

#import "SLHBackgroundLayer.h"
@import UIKit;

@implementation SLHBackgroundLayer

+ (CAGradientLayer*) greyGradient {
    
    UIColor *colorOne = [UIColor colorWithRed:0.59 green:0.86 blue:0.96 alpha:1.0];
    UIColor *colorTwo = [UIColor colorWithRed:0.40 green:0.82 blue:0.98 alpha:1.0];
    UIColor *colorThree = [UIColor colorWithRed:0.12 green:0.32 blue:0.56 alpha:1.0];
    
    NSArray *colors =  [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, colorThree.CGColor, nil];
    
    NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
    NSNumber *stopTwo = [NSNumber numberWithFloat:1.0];
    NSNumber *stopThree = [NSNumber numberWithFloat:1.0];
    
    NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, stopThree, nil];
    CAGradientLayer *headerLayer = [CAGradientLayer layer];
    headerLayer.colors = colors;
    headerLayer.locations = locations;
    
    return headerLayer;
    
}

@end
