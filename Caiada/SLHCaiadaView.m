//
//  SLHCaiadaView.m
//  
//
//  Created by Stefan Lange-Hegermann on 01.05.15.
//
//

#import "SLHCaiadaView.h"

@implementation SLHCaiadaView {
    CAShapeLayer *shapeLayer;
    CAShapeLayer *emptyLayer;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.*/
-(void)setElapsed:(double)elapsed {
    if (elapsed != _elapsed) {
        _elapsed = elapsed;
        [self setNeedsDisplay];
    }
}

- (void)awakeFromNib {
    self.clearsContextBeforeDrawing = NO;
    self.elapsed = 0;
    shapeLayer = [[CAShapeLayer alloc] init];
    emptyLayer = [[CAShapeLayer alloc] init];
    [self.layer addSublayer:shapeLayer];
    [self.layer addSublayer:emptyLayer];
}

- (void)drawRect:(CGRect)rect {
    CGPoint center = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:center
                                                              radius:CGRectGetMidX(rect)-40
                                                          startAngle:-0.5*M_PI
                                                            endAngle:1.5*M_PI
                                                           clockwise:true];
    shapeLayer.path = circlePath.CGPath;
    shapeLayer.strokeColor = [[UIColor colorWithRed:0.14 green:0.5 blue:0.67 alpha:1] CGColor];
    shapeLayer.fillColor = [[UIColor clearColor] CGColor];
    shapeLayer.lineWidth = 2.0;
    shapeLayer.strokeStart = 0;
    shapeLayer.strokeEnd = self.elapsed;
    
    emptyLayer.path = circlePath.CGPath;
    emptyLayer.strokeColor = [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.1] CGColor];
    emptyLayer.fillColor = [[UIColor clearColor] CGColor];
    emptyLayer.lineWidth = 2.0;
    emptyLayer.strokeStart = self.elapsed;
    emptyLayer.strokeEnd = 1;
    

}


@end
