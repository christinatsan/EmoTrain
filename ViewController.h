//
//  ViewController.h
//  EmoTrain
//
//  Created by Christina Tsangouri on 3/8/16.
//  Copyright © 2016 Christina Tsangouri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <opencv2/videoio/cap_ios.h>


@interface ViewController : UIViewController <CvVideoCameraDelegate>
{
    CvVideoCamera *camera;
    
}

@property (nonatomic,retain) CvVideoCamera *camera;

@property (weak, nonatomic) IBOutlet UIImageView *camView;
@property (weak, nonatomic) IBOutlet UITextView *resultText;
@property (weak, nonatomic) IBOutlet UIImageView *resultView;

@end

