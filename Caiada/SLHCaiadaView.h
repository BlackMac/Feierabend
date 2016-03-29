//
//  SLHCaiadaView.h
//  
//
//  Created by Stefan Lange-Hegermann on 01.05.15.
//
//

#import <UIKit/UIKit.h>

@interface SLHCaiadaView : UIView

@property (nonatomic) double elapsed;
@property (nonatomic) UIColor *circleBackgroundColor;
@property (nonatomic) UIColor *circleProgressColor;
@property (nonatomic) CGFloat lineWidth;
@property (nonatomic, readonly) UIImage *image;
@end
