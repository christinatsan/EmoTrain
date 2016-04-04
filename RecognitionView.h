//
//  RecognitionView.h
//  EmoTrain
//
//  Created by Christina Tsangouri on 3/29/16.
//  Copyright © 2016 Christina Tsangouri. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecognitionView : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *recBackView;
@property (weak, nonatomic) IBOutlet UIImageView *recImageView;
@property (weak, nonatomic) IBOutlet UITextField *guessText;

@property (weak, nonatomic) IBOutlet UIButton *happyButton;
@property (weak, nonatomic) IBOutlet UIButton *sadButton;
@property (weak, nonatomic) IBOutlet UIButton *angryButton;
@property (weak, nonatomic) IBOutlet UIButton *neutralButton;
@property (weak, nonatomic) IBOutlet UIButton *surpriseButton;
@property (weak, nonatomic) IBOutlet UIButton *disgustButton;
@property (weak, nonatomic) IBOutlet UIButton *fearButton;


@property (weak, nonatomic) IBOutlet UITextField *resultText;


@end
