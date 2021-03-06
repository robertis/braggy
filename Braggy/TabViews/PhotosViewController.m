//
//  PhotosViewController.m
//  Braggy
//
//  Created by Tongbram, Robertis on 7/24/14.
//  Copyright (c) 2014 Tongbram, Robertis. All rights reserved.
//

#import "PhotosViewController.h"

@interface PhotosViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)applyOne:(id)sender;

- (IBAction)applyTwo:(id)sender;

- (IBAction)changeExposure:(id)sender;

- (IBAction)changeShadowsAndHighlights:(id)sender;
- (IBAction)adjustValue:(id)sender;

- (IBAction)changeValue:(id)sender;
- (IBAction)applyEffect:(id)sender;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UILabel *svalue;

@property (strong, nonatomic) NSMutableArray *editors;
@property (strong, nonatomic) NSMutableArray *editoryKeys;
@end

@implementation PhotosViewController

BOOL toggle;
float inputVal;
int effectType;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    UIImage *image = [UIImage imageNamed: @"test1.png"];
    [self.imageView setImage:image];
    _editors = [@[@"EXPOSURE",
                    @"WHITE BALANCE",
                    @"HIGHLIGHTS",
                    @"SHADOWS",
                    @"TEMPERATURE",
                    @"VIBRANCE",
                    @"SATURATION",
                    @"CLARITY",
                    @"CONTRAST"] mutableCopy];
    _editoryKeys = [@[@"CIExposureAdjust",
                  @"CIWhitePointAdjust",
                  @"CIHighlightShadowAdjust",
                  @"CIHighlightShadowAdjust",
                  @"CITemperatureAndTint",
                  @"CIVibrance",
                  @"CIColorControls",
                  @"CIColorControls",
                  @"CIColorControls"] mutableCopy];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:
(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView
    numberOfItemsInSection:(NSInteger)section
{
    return 6;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotosCollectionViewCell *myCell = [collectionView
                                    dequeueReusableCellWithReuseIdentifier:@"AdjustCellId"
                                    forIndexPath:indexPath];
    
    
    myCell.imageView.image = [UIImage imageNamed: @"test1.png"];
    myCell.title.text = _editors[indexPath.item];
    
    return myCell;
}

#pragma mark -
#pragma mark UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    effectType = indexPath.item;
    NSLog(@"selected editor = %@",_editors[indexPath.item]);
    NSLog(@"effect type = %d",effectType);
}

//#pragma mark - UIImagePickerControllerDelegate

// This method is called when an image has been chosen from the library or taken from the camera.
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    UIImage *editedImage = (UIImage *) [info objectForKey:
                                        UIImagePickerControllerEditedImage];
    
    UIImage *selectedImage = nil;
    if(editedImage){
        selectedImage = editedImage;
        
    }
    else{
        selectedImage = image;
        
    }
    
    //selectedImage = image;
    CIImage *rawImageData;
    rawImageData =[[CIImage alloc] initWithImage:selectedImage];
    
    CIFilter *filter = [CIFilter filterWithName:@"CISepiaTone"];
    [filter setDefaults];
    [filter setValue:rawImageData forKey:@"inputImage"];
    [filter setValue:[NSNumber numberWithFloat:25.00]
              forKey:@"inputIntensity"];
    
    
    
    CIImage *filteredImageData = [filter valueForKey:@"outputImage"];
    
    UIImage *filteredImage = [UIImage imageWithCIImage:filteredImageData];
    self.imageView.image = filteredImage;
    
    
    
    
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



- (IBAction)applyOne:(id)sender {
    NSLog(@"apply 1 clicked");
    /*
    UIImage *selectedImage = [UIImage imageNamed: @"test1.png"];
    CIImage *rawImageData;
    rawImageData =[[CIImage alloc] initWithImage:selectedImage];
    
    CIFilter *filter = [CIFilter filterWithName:@"CISepiaTone"];
    [filter setDefaults];
    [filter setValue:rawImageData forKey:@"inputImage"];
    [filter setValue:[NSNumber numberWithFloat:25.00]
              forKey:@"inputIntensity"];
    
    
    
    CIImage *filteredImageData = [filter valueForKey:@"outputImage"];
    
    UIImage *filteredImage = [UIImage imageWithCIImage:filteredImageData];
    
    [self.imageView setImage:filteredImage];
     */
    [self addPhotoEffectChrome];
    NSLog(@"apply 1 done");

}

-(void) addPhotoEffectChrome {
    //CIPhotoEffectChrome
    NSLog(@"inside addPhotoEffectChrome");
    //UIImage *selectedImage = [UIImage imageNamed: @"test1.png"];
    //[self.imageView setImage:selectedImage];
    
    float ev = inputVal;
    NSLog(@"shadow value in float = %f", ev);
    EAGLContext *myEAGLContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    NSDictionary *options = @{ kCIContextWorkingColorSpace : [NSNull null] };
    
    UIImage *selectedImage = [UIImage imageNamed: @"test1.png"];
    NSData *selImageData = [[NSData alloc] initWithData:UIImageJPEGRepresentation((selectedImage), 0.5)];
    NSLog(@"SIZE OF IMAGE BEFORE : %ld ", (unsigned long)selImageData.length);
    
    [self.imageView setImage:selectedImage];
    UIImageOrientation originalOrientation = self.imageView.image.imageOrientation;
    CIImage *rawImageData = [[CIImage alloc] initWithCGImage:[self.imageView.image CGImage]];
    NSString *photoEffect;
    if(ev < 2){
        //--
        photoEffect = @"CIPhotoEffectChrome";
    }
    else if(ev < 3){
        photoEffect = @"CIPhotoEffectFade";
    }
    else if(ev < 4){
        //--
        photoEffect = @"CIPhotoEffectInstant";
    }
    else if(ev < 5){
        photoEffect = @"CIPhotoEffectMono";
    }
    else if(ev < 6){
        //--
        photoEffect = @"CIPhotoEffectNoir";
    }
    else if(ev < 7){
        //--
        photoEffect = @"CIPhotoEffectProcess";
    }
    else if(ev < 8){
        photoEffect = @"CIPhotoEffectTonal";
    }
    else if(ev < 9){
        //--
        photoEffect = @"CIPhotoEffectTransfer";
    }
    else{
        photoEffect = @"CIPhotoEffectTransfer";
    }
    //CIPhotoEffectTransfer
    
    NSLog(@"Photo effect = %@",photoEffect);
    
    CIFilter *filter = [CIFilter filterWithName:photoEffect];
    [filter setDefaults];
    [filter setValue:rawImageData forKey:@"inputImage"];
    //[filter setValue:[NSNumber numberWithFloat:ev]
         //     forKey:@"inputLevels"];
    
    CIImage *outputImage = [filter valueForKey:@"outputImage"];
    
    CIContext *context = [CIContext contextWithEAGLContext:myEAGLContext options:options];
    CGImageRef imgRef = [context createCGImage:outputImage fromRect:outputImage.extent];
    UIImage* img = [[UIImage alloc] initWithCGImage:imgRef scale:1.0 orientation:originalOrientation];
    CGImageRelease(imgRef);
    
    NSData *imageData = [[NSData alloc] initWithData:UIImageJPEGRepresentation((img), 0.5)];
    NSLog(@"SIZE OF IMAGE AFTER : %ld ", (unsigned long)imageData.length);
    
    [self.imageView setImage:img];
}

- (IBAction)applyTwo:(id)sender {
    NSLog(@"apply 2 clicked");
    //UIImage *selectedImage = [UIImage imageNamed: @"test1.png"];
    //[self.imageView setImage:selectedImage];
    
    float ev = inputVal;
    NSLog(@"shadow value in float = %f", ev);
    EAGLContext *myEAGLContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    NSDictionary *options = @{ kCIContextWorkingColorSpace : [NSNull null] };
    
    UIImage *selectedImage = [UIImage imageNamed: @"test1.png"];
    [self.imageView setImage:selectedImage];
    UIImageOrientation originalOrientation = self.imageView.image.imageOrientation;
    CIImage *rawImageData = [[CIImage alloc] initWithCGImage:[self.imageView.image CGImage]];
    
    CIFilter *filter = [CIFilter filterWithName:@"CIColorPosterize"];
    [filter setDefaults];
    [filter setValue:rawImageData forKey:@"inputImage"];
    [filter setValue:[NSNumber numberWithFloat:ev]
              forKey:@"inputLevels"];
    
    CIImage *outputImage = [filter valueForKey:@"outputImage"];
    
    CIContext *context = [CIContext contextWithEAGLContext:myEAGLContext options:options];
    CGImageRef imgRef = [context createCGImage:outputImage fromRect:outputImage.extent];
    UIImage* img = [[UIImage alloc] initWithCGImage:imgRef scale:1.0 orientation:originalOrientation];
    CGImageRelease(imgRef);
    
    [self.imageView setImage:img];
    

}

- (IBAction)changeExposure:(id)sender {
    
    /*
    NSString *expVal = self.evText.text;
    if(expVal == nil){
        expVal = @"0.5";
    }
    NSLog(@"exposure value = %@", expVal);
    float ev = [expVal floatValue];
    */
    float ev = inputVal;
    NSLog(@"exposure value in float = %f", ev);
    
    UIImage *selectedImage = [UIImage imageNamed: @"test1.png"];
    [self.imageView setImage:selectedImage];
    CIImage *rawImageData;
    rawImageData =[[CIImage alloc] initWithImage:selectedImage];
    
    CIFilter *filter = [CIFilter filterWithName:@"CIExposureAdjust"];
    [filter setDefaults];
    [filter setValue:rawImageData forKey:@"inputImage"];
    [filter setValue:[NSNumber numberWithFloat:ev]
              forKey:@"inputEV"];
    
    
    
    
    CIImage *filteredImageData = [filter valueForKey:@"outputImage"];
    
    UIImage *filteredImage = [UIImage imageWithCIImage:filteredImageData];
    
    [self.imageView setImage:filteredImage];
    NSLog(@"exposure done");
}

- (IBAction)changeShadowsAndHighlights:(id)sender {
    
    float ev = inputVal;
    NSLog(@"shadow value in float = %f", ev);
    EAGLContext *myEAGLContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    NSDictionary *options = @{ kCIContextWorkingColorSpace : [NSNull null] };
    

    
    UIImage *selectedImage = [UIImage imageNamed: @"test1.png"];
    [self.imageView setImage:selectedImage];
    UIImageOrientation originalOrientation = self.imageView.image.imageOrientation;
    CIImage *rawImageData = [[CIImage alloc] initWithCGImage:[self.imageView.image CGImage]];
    
    //CIImage *rawImageData;
    //rawImageData =[[CIImage alloc] initWithImage:selectedImage];
    
    CIFilter *filter = [CIFilter filterWithName:@"CIHighlightShadowAdjust"];
    [filter setDefaults];
    [filter setValue:rawImageData forKey:@"inputImage"];
    [filter setValue:[NSNumber numberWithFloat:1.0]
              forKey:@"inputHighlightAmount"];
    [filter setValue:[NSNumber numberWithFloat:ev]
              forKey:@"inputShadowAmount"];
    
    
    
    
    CIImage *outputImage = [filter valueForKey:@"outputImage"];
    
    //CIContext* context = [CIContext contextWithOptions:nil];
    CIContext *context = [CIContext contextWithEAGLContext:myEAGLContext options:options];
    CGImageRef imgRef = [context createCGImage:outputImage fromRect:outputImage.extent];
    UIImage* img = [[UIImage alloc] initWithCGImage:imgRef scale:1.0 orientation:originalOrientation];
    CGImageRelease(imgRef);
    //UIImage *filteredImage = [UIImage imageWithCIImage:filteredImageData];
    
    [self.imageView setImage:img];

    
}

- (IBAction)adjustValue:(id)sender {
    
    UISlider *slider = (UISlider *)sender;
    float val = slider.value;
    inputVal = val;
    self.svalue.text = [NSString stringWithFormat:@"%f",val];
}

- (IBAction)changeValue:(id)sender {
    UIStepper *stepper = (UIStepper *) sender;
    inputVal = (float)[stepper value];
    
    double value = [stepper value];
    [self.svalue setText:[NSString stringWithFormat:@"%d", (int)value]];
}

- (IBAction)applyEffect:(id)sender {
    
   
    [self applyExposureWith:effectType andValue:inputVal];
}

- (void)applyExposureWith:(int)type andValue:(float)value
{
    NSLog(@"input value = %f",value);
    NSLog(@"effect type = %d",type);
    
    float ev = inputVal;
    NSLog(@"shadow value in float = %f", ev);
    EAGLContext *myEAGLContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    NSDictionary *options = @{ kCIContextWorkingColorSpace : [NSNull null] };
    
    UIImage *selectedImage = [UIImage imageNamed: @"test1.png"];
    [self.imageView setImage:selectedImage];
    UIImageOrientation originalOrientation = self.imageView.image.imageOrientation;
    CIImage *rawImageData = [[CIImage alloc] initWithCGImage:[self.imageView.image CGImage]];
    
    CIFilter *filter = [CIFilter filterWithName:@"CIColorPosterize"];
    [filter setDefaults];
    [filter setValue:rawImageData forKey:@"inputImage"];
    [filter setValue:[NSNumber numberWithFloat:ev]
              forKey:@"inputLevels"];
    
    CIImage *outputImage = [filter valueForKey:@"outputImage"];
    
    CIContext *context = [CIContext contextWithEAGLContext:myEAGLContext options:options];
    CGImageRef imgRef = [context createCGImage:outputImage fromRect:outputImage.extent];
    UIImage* img = [[UIImage alloc] initWithCGImage:imgRef scale:1.0 orientation:originalOrientation];
    CGImageRelease(imgRef);
    
    [self.imageView setImage:img];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}
@end
