//
//  ViewController.m
//  GuessingGameObjC
//
//  Created by Tony's Mac on 10/21/14.
//  Copyright (c) 2014 DeAnza. All rights reserved.
//

#import "ViewController.h"
#import <AudioToolbox/AudioToolbox.h>

@interface ViewController ()
@property (strong, nonatomic) UIAlertController * winAlertController;

@end

@implementation ViewController
{
    NSInteger guesses;
    NSInteger numberToGuess;
    BOOL gameOver;
    SystemSoundID soundEffect;
    int timeTick;
    NSTimer *timer;
    int gameMode;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    guesses = 1;
    numberToGuess = 0;
    gameOver = NO;
    numberToGuess = [self generateNumber];
    NSLog(@"number to guess: %li ", (long)numberToGuess);
    [self showOutput:@"Easy Mode Begin!\n"];
    [self showOutput:@"I'm thinking of a number ...\n"];
    self.showAnsBtn.hidden = YES;
    self.timeLbl.hidden = YES;
    timeTick = 60;
    gameMode = 0;
    
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"tada" ofType:@"wav"];
    NSURL *soundURL = [NSURL fileURLWithPath:soundPath];
    AudioServicesCreateSystemSoundID(CFBridgingRetain(soundURL), &soundEffect);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) showOutput:(NSString*) outText{
    self.gameOutput.text = [self.gameOutput.text stringByAppendingString:outText];
    //NSLog(@"gameOutput: %@", self.gameOutput.text);
}

-(NSInteger) generateNumber{
    
    int randNum = arc4random() % 100 + 1;
    NSLog(@"random number: %i ", randNum);
    return randNum;
}

-(void) clearInput{
    self.userInput.text = @"";
}

- (IBAction)start:(id)sender {
    [self makeNewGame];
    timeTick = 60;
    self.timeLbl.text = [[NSString alloc] initWithFormat:@"%d", timeTick];
}

- (IBAction)userGuess:(id)sender {
    
    NSString *possibleGuess = self.userInput.text;
    NSInteger possibleGuessInt = [possibleGuess integerValue];
    NSLog(@"possibleGuessInt: %li", (long)possibleGuessInt);
    NSInteger guess = possibleGuessInt;
    
    NSString *userNumber = [self.userInput.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([userNumber length] == 0 && gameOver == NO) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Make sure you enter a number!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    }
    else if(guess < 0 || guess > 100) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Make sure you enter a valid number!(1-100)" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    }

//    if (gameOver == YES) {
//        NSString *newGame = self.userInput.text;
//        if ([newGame  isEqual: @"Y"] || [newGame  isEqual: @"y"]) {
//            gameOver = NO;
//            self.gameOutput.text = @"";
//            [self clearInput];
//            numberToGuess = [self generateNumber];
//            [self showOutput:@"I'm thinking of a number ...\n"];
//        }else{
//            [self showOutput:@"Invalid input!\n"];
//            [self clearInput];
//        }
//        
//    }

    if (guess >= 0 && guess <= 100 && gameOver == NO && [userNumber length] != 0){
        if (guess > numberToGuess) {
            [self showOutput:[NSString stringWithFormat:@"%ld ,You guessed too high! \n",(long)guess]];
            ++guesses;
            
            if (guesses >= 6) {
                self.showAnsBtn.hidden = NO;
            }
            
        }else if (guess < numberToGuess) {
            [self showOutput:[NSString stringWithFormat:@"%ld ,You guessed too low! \n",(long)guess]];
            ++guesses;
            
            if (guesses >= 6) {
                self.showAnsBtn.hidden = NO;
            }
            
        }else {
            [self showOutput:[NSString stringWithFormat:@"%ld ,You win! \n",(long)guess]];
            [self showOutput:[NSString stringWithFormat:@"Total guesses: %ld \n",(long)guesses]];
            gameOver = YES;
            guesses = 1;
        
            [self animationBegin];  //Begin wining animation
            AudioServicesPlaySystemSound(soundEffect);  //No sound for iOS 8
            
            [self presentViewController: self.winAlertController animated:YES completion:^{
                nil;
            }];
            
        }
        [self clearInput];
    }else if(guess < 0 || guess > 100){
        [self showOutput:@"Please input a valid number!\n"];
        [self clearInput];
    }
    
    [self dismissKeyboard];
}


- (UIAlertController *) winAlertController{
    if (!_winAlertController) {
        self.winAlertController = [UIAlertController alertControllerWithTitle:@"You Win!" message:@"Play again?" preferredStyle:
                                   UIAlertControllerStyleActionSheet];
        
        [self.winAlertController addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            //Yes
            [self makeNewGame];
            self.showAnsBtn.hidden = YES;
            
        }]];
        
        [self.winAlertController addAction:[UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            //No
            self.gameOutput.text = @"";
            [self showOutput:@"Press Start to Begin!\n"];
            self.showAnsBtn.hidden = YES;
            
        }]];
    }
        return _winAlertController;
}

-(void) makeNewGame {
    gameOver = NO;
    self.gameOutput.text = @"";
    [self clearInput];
    numberToGuess = [self generateNumber];
    [self showOutput:@"I'm thinking of a number ...\n"];
}

- (IBAction)clearHistory:(id)sender {
    self.gameOutput.text = @"";
}

- (IBAction)showAns:(id)sender {
    [self showOutput:[NSString stringWithFormat:@"The answer is: %ld \n",(long)numberToGuess]];
}

- (IBAction)changeMode:(id)sender {
    
    if (self.modeSegment.selectedSegmentIndex == 0) {
        // Easy Mode
        self.timeLbl.hidden = YES;
        gameMode = 0;
        self.gameOutput.text = @"";
        [self showOutput:@"Easy Mode Begin!\n"];
        gameOver = NO;
        [self clearInput];
        numberToGuess = [self generateNumber];


    }
    if (self.modeSegment.selectedSegmentIndex == 1) {
        // Hard Mode
        gameMode = 1;
        self.gameOutput.text = @"";
        [self showOutput:@"Hard Mode Begin!\n"];
        self.timeLbl.hidden = NO;
        
        [timer invalidate];
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(tick) userInfo:nil repeats:YES];
        
    }
}

- (void)animationBegin
{
    NSArray *starImageArray = [[NSArray alloc]initWithObjects:
                               [UIImage imageNamed:@"1star0.png"],
                               [UIImage imageNamed:@"1star1.png"],
                               [UIImage imageNamed:@"1star2.png"],
                               [UIImage imageNamed:@"1star3.png"],
                               [UIImage imageNamed:@"1star4.png"],
                               [UIImage imageNamed:@"1star5.png"],
                               [UIImage imageNamed:@"1star6.png"],
                               [UIImage imageNamed:@"1star7.png"],nil];
   
    
    self.backgroundImageView.animationImages = starImageArray;
    self.backgroundImageView.animationRepeatCount = 12;
    self.backgroundImageView.animationDuration = 0.35;
    
    self.backgroundImageView.image = starImageArray[0];
    
    if (!self.backgroundImageView.isAnimating) {
        [self.backgroundImageView startAnimating];
        [self.backgroundImageView setImage:[self.backgroundImageView.animationImages lastObject]];
    }
}

-(void)tick {
    if(timeTick == 0){
        [timer invalidate];
        timeTick = 60;
        self.timeLbl.text = [[NSString alloc] initWithFormat:@"%d", timeTick];
        [self showOutput:@"Game Over!\nPress Start to Try again!\n"];
        gameOver = YES;
    }else if(gameOver == NO && gameMode == 1){
        timeTick--;
        NSString *timeString = [[NSString alloc] initWithFormat:@"%d",timeTick];
        self.timeLbl.text = timeString;
    }else{
        timeTick = 60;
        self.timeLbl.text = [[NSString alloc] initWithFormat:@"%d", timeTick];
    }
}

-(void)dismissKeyboard {
    [self.userInput resignFirstResponder];
}

@end
