//
//  EnteredRestaurantCallback.m
//  Sense360Starter
//
//  Created by dan bright on 6/4/15.
//  Copyright (c) 2015 Sense360. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EnteredRestaurantCallback.h"
#import "NotificationSender.h"
@import SenseSdk;

@interface EnteredRestaurantCallback ()
@end

@implementation EnteredRestaurantCallback
- (void)recipeFired:(RecipeFiredArgs*) args {
    //Your user has entered a restaurant!//
    NSLog(@"Recipe %@ fired at %@.", args.recipe.name, args.timestamp);
    
    NSString *transitionDesc;
    if(args.recipe.trigger.transitionType == TransitionTypeEnter) {
        transitionDesc = @"Enter";
    } else {
        transitionDesc = @"Exit";
    }
    
    if(args.triggersFired.count > 0) {
        TriggerFiredArgs *trigger = (TriggerFiredArgs*) args.triggersFired[0];
        
        NSObject<NSCoding, Place> *place = (NSObject<NSCoding, Place>*)trigger.places[0];
        
        if(place.type == PlaceTypeCustomGeofence) {
            
            CustomGeofence *geofence = (CustomGeofence*)place;
            NSString *notificationBody = [[NSString alloc] initWithFormat: @"%@ %@", transitionDesc, geofence.customIdentifier];
            [NotificationSender send:notificationBody];
            
        } else if(place.type == PlaceTypePersonal) {
            
            PersonalizedPlace *personalizedPlace = (PersonalizedPlace*)place;
            NSString *personalizedPlaceType = [PersonalizedPlace getDescriptionOfPersonalizedPlaceType:(int)personalizedPlace.type];
            NSString *notificationBody = [[NSString alloc] initWithFormat: @"%@ %@", transitionDesc,personalizedPlaceType];
            [NotificationSender send:notificationBody];
            
        } else if(place.type == PlaceTypePoi) {
            
            PoiPlace *poiPlace = (PoiPlace*)place;
            NSString *notificationBody = [[NSString alloc] initWithFormat: @"%@ %@", transitionDesc, poiPlace.description];
            [NotificationSender send:notificationBody];
            
        }
    }
}
@end