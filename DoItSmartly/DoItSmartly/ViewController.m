//
//  ViewController.m
//  DoItSmartly
//
//  Created by Farn-Yu Khong on 6/20/15.
//  Copyright (c) 2015 Interestix Corp. All rights reserved.
//

#import "ViewController.h"
#import "EnteredRestaurantCallback.h"
#import "TaskCellTableViewCell.h"

@import SenseSdk;

@interface ViewController () <UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDataSource, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@property (strong) NSArray *arrayPlace;
@property (strong) NSArray *arrayTransition;
@property (strong) NSArray *arrayAction;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *scheduleButton;

@property (strong, nonatomic) NSMutableArray *tasks;
@property (strong, nonatomic) NSMutableArray *selectedActions;
@property (strong, nonatomic) NSMutableArray *selectedToPersons;
@property (strong, nonatomic) NSMutableArray *selectedToMessages;

@property (strong, nonatomic) NSString *selectedPlace;
@property (strong, nonatomic) NSString *selectedAction;
@property (strong, nonatomic) NSNumber *selectedActionNumber;

@property (strong, nonatomic) NSString *selectedTransition;


@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
  
  self.pickerView.dataSource = self;
  self.pickerView.delegate = self;

  self.arrayPlace = @[@"home",
                   @"work",
                   @"gym",
                   @"restaurant",
                   @"mall",
                   @"zone A",
                   @"zone B",
                   @"zone C"
                   ];
  
  self.arrayTransition = @[@"entering",
                           @"leaving",
                           @"inside",
                           @"outside"
                           ];
  
  self.arrayAction = @[@"light on",
                   @"heater on",
                   @"cool air on",
                   @"alarm on",
                   @"alarm off",
                   @"text",
                   @"email"
                   ];
  
  self.tasks = [NSMutableArray array];
  self.selectedActions = [NSMutableArray array];
  self.selectedToPersons = [NSMutableArray array];
  self.selectedToMessages = [NSMutableArray array];
  
  self.tableView.dataSource = self;
//  UINib *nib = [UINib nibWithNibName:@"TaskCellTableViewCell" bundle:nil];
//  [self.tableView register:nib forCellReuseIdentifier:@"TaskCellTableViewCell"];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
  //if (pickerView == self.pickerView)
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
  //NSLog(@"Component_1: %d",pickerView.tag);
  if (component == 0)
    return [self.arrayTransition count];
  else if (component == 2)
    return [self.arrayAction count];
  else
    return [self.arrayPlace count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
  //NSLog(@"Component_2: %d",pickerView.tag);
  if(component == 0)
    return [self.arrayTransition objectAtIndex:row];
  else if (component == 2)
    return [self.arrayAction objectAtIndex:row];
  else
    return [self.arrayPlace objectAtIndex:row];
}

- (IBAction)scheduleTouchUpInside:(id)sender {
    
  
  NSUInteger row = [self.pickerView  selectedRowInComponent:0];
  NSString *transition = [self.arrayTransition objectAtIndex:row];
    self.selectedTransition = transition;
  
  row = [self.pickerView  selectedRowInComponent:1];
  NSString *location = [self.arrayPlace objectAtIndex:row];
    self.selectedPlace = location;

  row = [self.pickerView  selectedRowInComponent:2];
  NSString *action = [self.arrayAction objectAtIndex:row];
    self.selectedAction = action;
    self.selectedActionNumber = @(row);
    
    if (row == 5 || row == 6) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Customize Your Message" message:nil delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        alert.alertViewStyle=UIAlertViewStyleLoginAndPasswordInput;
        
        alert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
        UITextField * alertTextField1 = [alert textFieldAtIndex:0];
        alertTextField1.keyboardType = UIKeyboardTypeDefault;
        alertTextField1.placeholder = @"User";
        
        UITextField * alertTextField2 = [alert textFieldAtIndex:1];
        alertTextField2.keyboardType = UIKeyboardTypeDefault;
        alertTextField2.placeholder = @"Message";
        
        alert.delegate = self;
        
        [alert show];
    }
    else {
      [self.tasks addObject:[NSString stringWithFormat:@"When %@ %@, %@", transition, location, action]];

      [self.selectedActions addObject:@(row)];
      [self.selectedToPersons addObject:@"None"];
      [self.selectedToMessages addObject:@"None"];
      [self.tableView reloadData];
      
      // Set up the sense 360 based on the new task
      [SenseSdk enableSdkWithKey:@"app_key_goes_here"];
      
      SenseSdkErrorPointer *errorPtr = [SenseSdkErrorPointer create];
      // Fire when the user in certain POI
        
        int selectedPoiRow = [self.pickerView  selectedRowInComponent:1];
        
      PoiType poiType = [ViewController poiType:selectedPoiRow];
        
        
      Trigger *trigger = [FireTrigger whenEntersPoi:PoiTypeUnknown conditions: nil errorPtr:errorPtr];
      
      if(trigger != nil) {
        // Recipe defines what trigger, what time of day and how long to wait between consecutive triggers firing
        Recipe *recipe = [[Recipe alloc] initWithName: action
                                              trigger:trigger
                          // Do NOT restrict the firing to a particular time of day
                                           timeWindow: [TimeWindow allDay]
                          // Wait at least 1 hour between consecutive triggers firing.
                                             cooldown: [Cooldown createWithOncePer:1 frequency:CooldownTimeUnitHours errorPtr:nil]];
        
        // register the unique recipe and specify that when the trigger fires it should call our own "onTriggerFired" wihtin the EnteredRestaurantCallback class
        EnteredRestaurantCallback *callback = [EnteredRestaurantCallback alloc];
        [SenseSdk registerWithRecipe:recipe delegate:callback errorPtr:errorPtr];
      }
      //[self logErrors:errorPtr];
    }
}

+ (NSInteger)poiType:(NSInteger)row {
    if (row == 0) {
        return PersonalizedPlaceTypeHome;
    }
    else if (row == 1) {
        return PersonalizedPlaceTypeWork;
    }
    else if (row == 2) {
        return PoiTypeGym;
    }
    else if (row == 3) {
        return PoiTypeRestaurant;
    }
    else {
        return PoiTypeUnknown;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.tasks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 
  static NSString *CellIdentifier = @"TaskCellTableViewCell";
  
  TaskCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
//  if (cell == nil) {
//    cell = [[TaskCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//    [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
//  }
  
  cell.taskLabel.text = self.tasks[self.tasks.count - indexPath.row - 1];
  cell.action = self.selectedActions[self.tasks.count - indexPath.row - 1];
  cell.toPerson = self.selectedToPersons[self.tasks.count - indexPath.row - 1];
  cell.toMessage = self.selectedToMessages[self.tasks.count - indexPath.row - 1];
  
  return cell;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *toPerson = [alertView textFieldAtIndex:0].text;
    NSString *toMessage = [alertView textFieldAtIndex:1].text;


    [self.tasks addObject:[NSString stringWithFormat:@"When %@ %@, %@ to %@ '%@'", self.selectedTransition, self.selectedPlace, self.selectedAction, toPerson, toMessage]];
    
    [self.selectedActions addObject:self.selectedActionNumber];
    
    
    [self.selectedToPersons addObject:toPerson];
    [self.selectedToMessages addObject:toMessage];

    [self.tableView reloadData];
    
    // Set up the sense 360 based on the new task
    [SenseSdk enableSdkWithKey:@"app_key_goes_here"];
    
    SenseSdkErrorPointer *errorPtr = [SenseSdkErrorPointer create];
    // Fire when the user enters a restaurant
    Trigger *restaurantTrigger = [FireTrigger whenEntersPoi:PoiTypeRestaurant conditions: nil errorPtr:errorPtr];
    
    if(restaurantTrigger != nil) {
        // Recipe defines what trigger, what time of day and how long to wait between consecutive triggers firing
        Recipe *recipe = [[Recipe alloc] initWithName: @"ArrivedAtRestaurant"
                                              trigger:restaurantTrigger
                          // Do NOT restrict the firing to a particular time of day
                                           timeWindow: [TimeWindow allDay]
                          // Wait at least 1 hour between consecutive triggers firing.
                                             cooldown: [Cooldown createWithOncePer:1 frequency:CooldownTimeUnitHours errorPtr:nil]];
        
        // register the unique recipe and specify that when the trigger fires it should call our own "onTriggerFired" wihtin the EnteredRestaurantCallback class
        EnteredRestaurantCallback *callback = [EnteredRestaurantCallback alloc];
        [SenseSdk registerWithRecipe:recipe delegate:callback errorPtr:errorPtr];
    }
    
}

@end
