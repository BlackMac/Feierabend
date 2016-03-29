//
//  ComplicationController.m
//  Feierabend Extension
//
//  Created by Stefan Lange-Hegermann on 28.03.16.
//  Copyright © 2016 Stefan Lange-Hegermann. All rights reserved.
//

#import "ComplicationController.h"
#import "SLHArrivalTimeManager.h"

@interface ComplicationController ()

@end

@implementation ComplicationController

#pragma mark - Timeline Configuration

- (void)getSupportedTimeTravelDirectionsForComplication:(CLKComplication *)complication withHandler:(void(^)(CLKComplicationTimeTravelDirections directions))handler {
    handler(CLKComplicationTimeTravelDirectionForward|CLKComplicationTimeTravelDirectionBackward);
}

- (void)getTimelineStartDateForComplication:(CLKComplication *)complication withHandler:(void(^)(NSDate * __nullable date))handler {
    handler(nil);
}

- (void)getTimelineEndDateForComplication:(CLKComplication *)complication withHandler:(void(^)(NSDate * __nullable date))handler {
    handler(nil);
}

- (void)getPrivacyBehaviorForComplication:(CLKComplication *)complication withHandler:(void(^)(CLKComplicationPrivacyBehavior privacyBehavior))handler {
    handler(CLKComplicationPrivacyBehaviorShowOnLockScreen);
}

#pragma mark - Timeline Population

- (void)getCurrentTimelineEntryForComplication:(CLKComplication *)complication withHandler:(void(^)(CLKComplicationTimelineEntry * __nullable))handler {
    if (complication.family == CLKComplicationFamilyUtilitarianSmall) {
        
        CLKComplicationTemplateUtilitarianSmallFlat *clt = [[CLKComplicationTemplateUtilitarianSmallFlat alloc] init];
        clt.textProvider = [CLKRelativeDateTextProvider textProviderWithDate:[SLHArrivalTimeManager sharedArrivalTimeManager].leaveDate style:CLKRelativeDateStyleNatural units:NSCalendarUnitMinute|NSCalendarUnitHour];
        clt.imageProvider = [CLKImageProvider imageProviderWithOnePieceImage:[UIImage imageNamed:@"sundial-complication.png"]];
        CLKComplicationTimelineEntry *timelineEntry = [CLKComplicationTimelineEntry entryWithDate:[NSDate date] complicationTemplate:clt timelineAnimationGroup:NULL];
        handler(timelineEntry);
        return;
    }
    handler(nil);
}

- (void)getTimelineEntriesForComplication:(CLKComplication *)complication beforeDate:(NSDate *)date limit:(NSUInteger)limit withHandler:(void(^)(NSArray<CLKComplicationTimelineEntry *> * __nullable entries))handler {
    // Call the handler with the timeline entries prior to the given date
    handler(nil);
}

- (void)getTimelineEntriesForComplication:(CLKComplication *)complication afterDate:(NSDate *)date limit:(NSUInteger)limit withHandler:(void(^)(NSArray<CLKComplicationTimelineEntry *> * __nullable entries))handler {
    // Call the handler with the timeline entries after to the given date
    handler(nil);
}

#pragma mark Update Scheduling

- (void)getNextRequestedUpdateDateWithHandler:(void(^)(NSDate * __nullable updateDate))handler {
    handler([NSDate date]);
    // Call the handler with the date when you would next like to be given the opportunity to update your complication content
}

#pragma mark - Placeholder Templates

- (void)getPlaceholderTemplateForComplication:(CLKComplication *)complication withHandler:(void(^)(CLKComplicationTemplate * __nullable complicationTemplate))handler {
    if (complication.family == CLKComplicationFamilyCircularSmall) {
        NSLog(@"CS - placeholder");
        CLKComplicationTemplateCircularSmallRingText *clt = [[CLKComplicationTemplateCircularSmallRingText alloc] init];
        clt.textProvider = [CLKSimpleTextProvider textProviderWithText:@"--"];
        clt.fillFraction =0.6;
        clt.ringStyle = CLKComplicationRingStyleClosed;
        handler(clt);
        return;
    }
    
    // This method will be called once per supported complication, and the results will be cached
    handler(nil);
}

@end
