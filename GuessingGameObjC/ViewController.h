//
//  ViewController.h
//  GuessingGameObjC
//
//  Created by Tony's Mac on 10/21/14.
//  Copyright (c) 2014 DeAnza. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UITextField *userInput;
@property (strong, nonatomic) IBOutlet UILabel *gameOutput;
@property (strong, nonatomic) IBOutlet UIButton *startButton;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (strong, nonatomic) IBOutlet UIButton *showAnsBtn;
@property (strong, nonatomic) IBOutlet UISegmentedControl *modeSegment;
@property (strong, nonatomic) IBOutlet UILabel *timeLbl;

- (IBAction)start:(id)sender; 
- (IBAction)userGuess:(id)sender;
- (IBAction)clearHistory:(id)sender;
- (IBAction)showAns:(id)sender;
- (IBAction)changeMode:(id)sender;



@end

