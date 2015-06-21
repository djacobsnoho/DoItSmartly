//
//  NotificationSender.m
//  Sense360Starter
//
//  Created by dan bright on 6/5/15.
//  Copyright (c) 2015 Sense360. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NotificationSender.h"

@interface NotificationSender ()
@end

@implementation NotificationSender
+ (void)send:(NSString*) text {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notification Alert"
                                                    message:@"Check your notification tray"
                                                   delegate:self
                                          cancelButtonTitle:@"Ok"
                                          otherButtonTitles:nil];
    [alert show];
    
    UILocalNotification *notification = [UILocalNotification alloc];
    notification.alertBody = text;
    notification.soundName = UILocalNotificationDefaultSoundName;

    UIUserNotificationSettings* notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}
@end
