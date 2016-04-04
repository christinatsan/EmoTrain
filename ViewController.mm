//
//  ViewController.m
//  EmoTrain
//
//  Created by Christina Tsangouri on 3/8/16.
//  Copyright © 2016 Christina Tsangouri. All rights reserved.
//

#import "ViewController.h"
#import <opencv2/imgproc/imgproc_c.h>
#import <dlib/image_io.h>



@interface ViewController ()

-(cv::CascadeClassifier*)loadClassifier;

@end

@implementation ViewController

cv::CascadeClassifier *faceCascade;
Boolean faceDetected = false;
UIImage *faceImage;
cv::Mat originalMat;
cv::Mat grayMat;
cv::Mat tempMat;
cv::Mat faceMat;
cv::Rect roi;
NSString *happy;
NSString *sad;
NSString *fear;
NSString *neutral;
NSString *surprise;
NSString *angry;
NSString *disgust;
NSDictionary *emotions;
NSString *mainEmotion;

-(cv::CascadeClassifier*)loadClassifier
{
    NSString* haar = [[NSBundle mainBundle] pathForResource:@"haarcascade_frontalface" ofType:@"xml"];
    cv::CascadeClassifier* cascade = new cv::CascadeClassifier();
    cascade->load([haar UTF8String]);
    return cascade;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.camera = [[CvVideoCamera alloc] initWithParentView:_camView];
    self.camera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionBack;
    self.camera.defaultAVCaptureSessionPreset = AVCaptureSessionPreset352x288;
    self.camera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
    self.camera.defaultFPS = 15;
    self.camera.grayscaleMode = NO;
    self.camera.delegate = self;
    
    faceCascade = [self loadClassifier];
    
    
    [self createTimer];
    [self camTimer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Protocol CvVideoCameraDelegate

- (void)processImage:(cv::Mat&)image
{
    // Do some OpenCV stuff with the image
    cv::Mat grayMat;
    cv::Mat face;
    cv::Mat rgbMat;
    grayMat = cv::Mat(image.rows, image.cols, CV_8UC3);
    cvtColor(image, grayMat, CV_BGRA2GRAY);
    rgbMat = cv::Mat(image.rows, image.cols, CV_8UC3);
    cvtColor(image, rgbMat, CV_BGRA2RGB);
    
    int height = grayMat.rows;
    double faceSize = (double) height * 0.25;
    cv::Size sSize;
    sSize.height = faceSize;
    sSize.width = faceSize;
    std::vector<cv::Rect> faces;
    
    faceCascade->detectMultiScale(grayMat,faces,1.1,4,2, sSize);
    if(faces.size() > 0)
    {
        faceDetected = true;
        NSLog(@"face detected!");
        cv::rectangle(image, faces[0].tl(), faces[0].br(),cv::Scalar(84.36,170,0), 2, CV_AA);
        
        cv::Mat(rgbMat, faces[0]).copyTo(face);
        
        faceImage = [self UIImageFromCVMat:face];
        
        //[self getLandmarks];
        
    }
    
    if(faces.size() == 0)
        faceDetected = false;
    
    grayMat.release();
    originalMat.release();
    rgbMat.release();
    
}

- (NSTimer*) createTimer {
    return [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(faceTimer:) userInfo:nil repeats:YES];
}

- (void) faceTimer:(NSTimer*)timer {
    // Start loop
    
    if(faceDetected == true)
        [self postImage];
    if(faceDetected == false)
    {
        self.resultText.text = @"";
        //also add a blank image or make imageview blank
    }
    
}

- (NSTimer*) camTimer {
    return [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(cam:) userInfo:nil repeats:NO];
    
}

- (void) cam:(NSTimer*)timer{
    [self.camera start];
    
}


-(void) postImage {
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW,0),^{
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        if (faceImage!=Nil){
            NSData *imageData = UIImageJPEGRepresentation(faceImage, 0.5);
            [manager POST:@"http://emo.vistawearables.com/bookmarks" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                [formData appendPartWithFileData:imageData name:@"bookmark[photo]" fileName:@"photo.jpg" mimeType:@"image/jpeg"];
            } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"Success: %@", responseObject);
                // [self getResponse];
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self getResponse];
                NSLog(@"Error: %@", error);
                
            }];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSLog(@"get here");
            
        });
        
});
    
}

-(void) getResponse {
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW,0),^{
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [manager GET:@"http://emo.vistawearables.com/bookmarks.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            
            emotions = (NSDictionary *)responseObject;
            happy = emotions[@"happy"];
            surprise = emotions[@"surprise"];
            sad = emotions[@"sad"];
            fear = emotions[@"fear"];
            neutral = emotions[@"neutral"];
            disgust = emotions[@"disgust"];
            angry = emotions[@"angry"];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"after get main %@",happy);
            [self findHighest];
            self.resultText.text = mainEmotion;
            if([mainEmotion isEqual: @"happy"]){
                [self.resultView setImage:[UIImage imageNamed:@"happy.png"]];
            }
            if([mainEmotion  isEqual: @"surprise"]){
                [self.resultView setImage:[UIImage imageNamed:@"surprise.png"]];
            }
            if([mainEmotion isEqual: @"fear"]){
                [self.resultView setImage:[UIImage imageNamed:@"fear.png"]];
            }
            if([mainEmotion isEqual: @"sad"]){
                [self.resultView setImage:[UIImage imageNamed:@"sad.png"]];
            }
            if([mainEmotion isEqual: @"neutral"]){
                [self.resultView setImage:[UIImage imageNamed:@"neutral.png"]];
            }
            if([mainEmotion isEqual: @"angry"]){
                [self.resultView setImage:[UIImage imageNamed:@"angry.png"]];
            }
            if([mainEmotion isEqual: @"disgust"]){
                [self.resultView setImage:[UIImage imageNamed:@"disgust.png"]];
            }
        });
        
    });
}

- (void) findHighest {
    
    
    NSArray *emoString = [NSArray arrayWithObjects:@"happy",@"surprise",@"sad",@"fear",@"neutral",@"disgust",@"angry",nil];
    
    float happyInt = [happy floatValue];
    float surpriseInt = [surprise floatValue];
    float sadInt = [sad floatValue];
    float fearInt = [fear floatValue];
    float neutralInt = [neutral floatValue];
    float disgustInt = [disgust floatValue];
    float angryInt = [angry floatValue];
    
    float emo[7] = {happyInt,surpriseInt,sadInt,fearInt,neutralInt,disgustInt,angryInt};
    
    double largest = 0;
    
    for(int i=0;i<=6;i++){
        if(emo[i]>largest)
            largest = emo[i];
        
    }
    
    for(int i=0;i<=6;i++){
        if(emo[i] == largest)
            mainEmotion = emoString[i];
    }
}

- (void) getLandmarks {
    
    
    
}

- (cv::Mat)cvMatFromUIImage:(UIImage *)image
{
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    CGFloat cols = image.size.width;
    CGFloat rows = image.size.height;
    
    cv::Mat cvMat(rows, cols, CV_8UC4); // 8 bits per component, 4 channels (color channels + alpha)
    
    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to  data
                                                    cols,                       // Width of bitmap
                                                    rows,                       // Height of bitmap
                                                    8,                          // Bits per component
                                                    cvMat.step[0],              // Bytes per row
                                                    colorSpace,                 // Colorspace
                                                    kCGImageAlphaNoneSkipLast |
                                                    kCGBitmapByteOrderDefault); // Bitmap info flags
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
    CGContextRelease(contextRef);
    
    return cvMat;
}

-(UIImage *)UIImageFromCVMat:(cv::Mat)cvMat
{
    NSData *data = [NSData dataWithBytes:cvMat.data length:cvMat.elemSize()*cvMat.total()];
    CGColorSpaceRef colorSpace;
    
    if (cvMat.elemSize() == 1) {
        colorSpace = CGColorSpaceCreateDeviceGray();
    } else {
        colorSpace = CGColorSpaceCreateDeviceRGB();
    }
    
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    
    // Creating CGImage from cv::Mat
    CGImageRef imageRef = CGImageCreate(cvMat.cols,                                 //width
                                        cvMat.rows,                                 //height
                                        8,                                          //bits per component
                                        8 * cvMat.elemSize(),                       //bits per pixel
                                        cvMat.step[0],                            //bytesPerRow
                                        colorSpace,                                 //colorspace
                                        kCGImageAlphaNone|kCGBitmapByteOrderDefault,// bitmap info
                                        provider,                                   //CGDataProviderRef
                                        NULL,                                       //decode
                                        false,                                      //should interpolate
                                        kCGRenderingIntentDefault                   //intent
                                        );
    
    
    // Getting UIImage from CGImage
    UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    
    return finalImage;
}

@end
