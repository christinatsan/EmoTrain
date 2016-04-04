//
//  RecognitionView.m
//  EmoTrain
//
//  Created by Christina Tsangouri on 3/29/16.
//  Copyright © 2016 Christina Tsangouri. All rights reserved.
//

#import "RecognitionView.h"

@interface RecognitionView ()

@end

@implementation RecognitionView


NSArray *emoImage;
UIImage *image;

Boolean correctAnswer = false;
Boolean falseAnswer = false;

NSArray *emoImages = [NSArray arrayWithObjects:@"happyImages",@"surpriseImages",@"sadImages",@"fearImages",@"neutralImages",@"disgustImages",@"angryImages", nil];

NSArray *happyImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"happy1.jpg"],[UIImage imageNamed:@"happy2.jpg"], [UIImage imageNamed:@"happy3.jpg"],[UIImage imageNamed:@"happy4.jpg"],nil];

NSArray *angryImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"angry1.jpg"],[UIImage imageNamed:@"angry2.jpg"], [UIImage imageNamed:@"angry3.jpg"], [UIImage imageNamed:@"angry4.jpg"], nil];

NSArray *disgustImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"disgust1.jpg"],[UIImage imageNamed:@"disgust2.jpg"], [UIImage imageNamed:@"disgust3.jpg"], [UIImage imageNamed:@"disgust4.jpg"], nil];

NSArray *fearImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"fear1.jpg"],[UIImage imageNamed:@"fear2.jpg"], [UIImage imageNamed:@"fear3.jpg"], [UIImage imageNamed:@"fear4.jpg"],nil];

NSArray *neutralImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"neutral1.jpg"],[UIImage imageNamed:@"neutral2.jpg"], [UIImage imageNamed:@"neutral3.jpg"], [UIImage imageNamed:@"neutral4.jpg"], nil];

NSArray *sadImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"sad1.jpg"],[UIImage imageNamed:@"sad2.jpg"],[UIImage imageNamed:@"sad3.jpg"], [UIImage imageNamed:@"sad4.jpg"], nil];

NSArray *surpriseImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"surprise1.jpg"], [UIImage imageNamed:@"surprise2.jpg"], [UIImage imageNamed:@"surprise3.jpg"], [UIImage imageNamed:@"surprise4.jpg"],nil];


NSArray *emoCategories = [NSArray arrayWithObjects:[NSArray arrayWithArray:happyImages],[NSArray arrayWithArray:sadImages], [NSArray arrayWithArray:angryImages], [NSArray arrayWithArray:disgustImages], [NSArray arrayWithArray:fearImages], [NSArray arrayWithArray:neutralImages], [NSArray arrayWithArray:sadImages], [NSArray arrayWithArray:surpriseImages], nil];

int randomEmo = arc4random() % 4;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self.recBackView setImage:[UIImage imageNamed:@"recbackground.jpeg"]];
    
    
    //[self gameTimer];
    [self startGame];
    
    
    
    

    
    
}


- (void) startGame {
    
   emoImage = emoCategories[randomEmo];
   image = emoImage[randomEmo];
    [self.recImageView setImage:image];
    
    
    
    
    
}

/*- (NSTimer*) gameTimer{
    return [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(emoTimer:) userInfo:nil repeats:NO];
}

- (void) emoTimer:(NSTimer*)timer{
    
    [self startGame];
}*/

- (IBAction)happyPressed:(id)sender {
    
    if([emoImage isEqualToArray:happyImages]){
        correctAnswer = true;
        self.resultText.text = @"Good Job!";
    }
    else{
        falseAnswer = true;
        self.resultText.text = @"Sorry!";
    }
    
    [self startGame];
    
    
}

- (IBAction)sadPressed:(id)sender {
    
    if([emoImage isEqualToArray:sadImages]){
        correctAnswer = true;
        self.resultText.text = @"Good Job!";
    }
    else{
        falseAnswer = true;
        self.resultText.text = @"Sorry!";
    }
    
    [self startGame];
    
}
- (IBAction)angryPressed:(id)sender {
    
    if([emoImage isEqualToArray:angryImages]){
        correctAnswer = true;
        self.resultText.text = @"Good Job!";
    }
    else{
        falseAnswer = true;
        self.resultText.text = @"Sorry!";
    }
    
    [self startGame];
}


- (IBAction)neutralPressed:(id)sender {
    
    if([emoImage isEqualToArray:neutralImages]){
        correctAnswer= true;
        self.resultText.text = @"Good Job!";
    }
    else{
        falseAnswer = true;
        self.resultText.text = @"Sorry!";
    }
    
    [self startGame];
}

- (IBAction)surprisePressed:(id)sender {
    
    if([emoImage isEqualToArray:surpriseImages]){
        correctAnswer = true;
        self.resultText.text = @"Good Job!";
    }
    else{
        falseAnswer = true;
        self.resultText.text=@"Sorry!";
    }
    
    [self startGame];
}

- (IBAction)disgustPressed:(id)sender {
    
    if([emoImage isEqualToArray:disgustImages]){
        correctAnswer = true;
        self.resultText.text= @"Good Job!";
    }
    else{
        falseAnswer = true;
        self.resultText.text = @"Sorry";
    }
    
    [self startGame];
}


- (IBAction)fearPressed:(id)sender {
    
    if([emoImage isEqualToArray:fearImages]){
        correctAnswer = true;
        self.resultText.text = @"Good Job!";
    }
    else{
        falseAnswer = true;
        self.resultText.text= @"Sorry!";
    }
    
    [self startGame];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
