//
//  TaskCellTableViewCell.h
//  DoItSmartly
//
//  Created by Farn-Yu Khong on 6/21/15.
//  Copyright (c) 2015 Interestix Corp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaskCellTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *taskLabel;
@property (weak, nonatomic) IBOutlet NSNumber *action;
@property (weak, nonatomic) IBOutlet NSString *toPerson;
@property (weak, nonatomic) IBOutlet NSString *toMessage;


@end
