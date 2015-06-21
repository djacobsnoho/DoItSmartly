//
//  TaskCellTableViewCell.m
//  DoItSmartly
//
//  Created by Farn-Yu Khong on 6/21/15.
//  Copyright (c) 2015 Interestix Corp. All rights reserved.
//

#import "TaskCellTableViewCell.h"
#import "ASIFormDataRequest.h"
#import "ASIHTTPRequest.h"

@interface TaskCellTableViewCell()


@end

@implementation TaskCellTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (IBAction)simulateTouchUpInside:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Simulate"
                                                    message:self.taskLabel.text
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
    
    /*NSString *post = @"Name=George&Message=val2&Phone=213-537-5681&Email=g@zkni.co";
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://www.hookstream.com/contactG.php"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    */
    
    if ([self.action isEqualToNumber:@(6)] || [self.action isEqualToNumber:@(5)]) {
        NSString *urlString = @"http://www.hookstream.com/contactG.php";
        NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        [request addPostValue:self.toPerson forKey:@"Name"];
        [request addPostValue:self.toMessage forKey:@"Message"];
        [request addPostValue:@"213-537-5681" forKey:@"Phone"];
        [request addPostValue:@"g@zkni.co" forKey:@"Email"];
        
        [request setCompletionBlock:^{
            NSLog(@"%@", request.responseString);
        }];
        
        [request setFailedBlock:^{
            
            NSLog(@"%@", request.error);
        }];
        
        [request startAsynchronous];
    }
    else {
        NSString *urlString = @"http://www.hookstream.com/contactG.php";
        NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        [request addPostValue:@"George" forKey:@"Name"];
        [request addPostValue:self.taskLabel.text forKey:@"Message"];
        [request addPostValue:@"213-537-5681" forKey:@"Phone"];
        [request addPostValue:@"g@zkni.co" forKey:@"Email"];
        
        [request setCompletionBlock:^{
            NSLog(@"%@", request.responseString);
        }];
        
        [request setFailedBlock:^{
            
            NSLog(@"%@", request.error);
        }];
        
        [request startAsynchronous];
    }
}

@end
