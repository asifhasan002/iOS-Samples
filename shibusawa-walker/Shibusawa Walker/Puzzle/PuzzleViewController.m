//
//  ViewController.m
//  JigsawPuzzle
//
//  Created by XOR Geek 03 on 12/28/16.
//  Copyright © 2016 XOR Geek 03. All rights reserved.
//

#import "PuzzleViewController.h"

@interface PuzzleViewController ()

@end

@implementation PuzzleViewController{
    
    //check if puzzle complete by this parameter
    int CompletedImagecount;
    
    int index;
}

@synthesize audioPlayer,congratLbl,congratTextLbl,topImageView,topLbl,originalImage_;

- (void)viewDidLoad {
    [super viewDidLoad];
   
    index = 0;
    
    previousCoordinateAvailable = false;
    
    CompletedImagecount = 0;
    
    [topImageView setFrame:CGRectMake(10,69,topImageView.frame.size.width,topImageView.frame.size.height)];
    topImageView.image = originalImage_;
    
    [topLbl setFrame:CGRectMake(topLbl.frame.origin.x,69,topLbl.frame.size.width,topLbl.frame.size.height)];
    
    CGRect rect = CGRectMake(0,0,[[UIScreen mainScreen] bounds].size.width,[[UIScreen mainScreen] bounds].size.width);
    UIGraphicsBeginImageContext( rect.size );
    [originalImage_ drawInRect:rect];
    UIImage *picture1 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData *imageData = UIImagePNGRepresentation(picture1);
    originalImage_=[UIImage imageWithData:imageData];
    
    
    blockHeightValue_ = [[UIScreen mainScreen] bounds].size.width/ROW;
    
    blockWidthValue_ = [[UIScreen mainScreen] bounds].size.width/COLUMN;
    
    deepnessH_ = -(blockHeightValue_ / 4);
    
    deepnessV_ = -(blockWidthValue_ / 4);
    
    //set Up image Piece Coordinates
    [self setUpPeaceCoordinatesTypesAndRotationValuesArrays];
   
    //create curves of image Pieces
    [self setUpPeaceBezierPaths];
    
    //set Up Back view
    [self setUpBackPuzzlePeaceImages];
    
    //create image Pieces
    [self setUpPuzzlePeaceImages];
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //split image Pieces
    [self moveAllPieces];
    
}

#pragma mark -
#pragma mark set up elements

- (void)setUpPeaceCoordinatesTypesAndRotationValuesArrays
{
    
    //--- rotations  (currently commented out so that at the beginning would be generated picture, where each peace is in its correct place)
    NSArray *mRotationTypeArray = [NSArray arrayWithObjects:
                                   [NSNumber numberWithFloat:M_PI/2],
                                   [NSNumber numberWithFloat:M_PI],
                                   [NSNumber numberWithFloat:M_PI + M_PI/2],
                                   [NSNumber numberWithFloat:M_PI*2],
                                   nil];
    //===
    
    pieceTypeValueArray_ = [NSMutableArray new];
    
    pieceCoordinateRectArray_ = [NSMutableArray new];
    
    pieceRotationValuesArray_ = [NSMutableArray new];
    
    //0: empty side /  1: outside  / -1: inside
    int mSide1 = 0;
    
    int mSide2 = 0;
    
    int mSide3 = 0;
    
    int mSide4 = 0;
    
    int mCounter = 0;
    
    int mCubeWidth = 0;
    
    int mCubeHeight = 0;
    
    int mXPoint = 0;
    
    int mYPoint = 0;
    
    NSMutableArray *previousValuesArray = [[[NSUserDefaults standardUserDefaults] arrayForKey:@"PREVOIUS_VALUES"] mutableCopy];
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"PREVOIUS_COORDINATES"];
    NSMutableArray *previousCoordinatesArray = [[NSKeyedUnarchiver unarchiveObjectWithData:data] mutableCopy];
    NSMutableArray *previousRotationArray = [[[NSUserDefaults standardUserDefaults] arrayForKey:@"PREVOIUS_ROTATIONS"] mutableCopy];
    
    
if(!previousCoordinateAvailable){
    
    for(int i = 0; i < ROW; i++)
    {
        for(int j = 0; j < COLUMN; j++)
        {
            
            if(j != 0)
            {
                mSide1 = ([[[pieceTypeValueArray_ objectAtIndex:mCounter-1] objectAtIndex:2] intValue] == 1)?-1:1;
            }
            
            if(i != 0)
            {
                mSide4 = ([[[pieceTypeValueArray_ objectAtIndex:mCounter-COLUMN] objectAtIndex:1] intValue] == 1)?-1:1;
            }
            
            
            mSide2 = ((arc4random() % 2) == 1)?1:-1;
            
            mSide3 = ((arc4random() % 2) == 1)?1:-1;
            
            
            if(i == 0)
            {
                mSide4 = 0;
            }
            
            if(j == 0)
            {
                mSide1 = 0;
            }
            
            
            if(i == ROW-1)
            {
                mSide2 = 0;
            }
            
            if(j == COLUMN-1)
            {
                mSide3 = 0;
            }
            
            //===
      
            
            //--- calculate block width and height
            mCubeWidth = blockWidthValue_;
            
            mCubeHeight = blockHeightValue_;
            
            if(mSide1 == 1)
            {
                mCubeWidth -= deepnessV_;
            }
            
            if(mSide3 == 1)
            {
                mCubeWidth -= deepnessV_;
            }
            
            if(mSide2 == 1)
            {
                mCubeHeight -= deepnessH_;
            }
            
            if(mSide4 == 1)
            {
                mCubeHeight -= deepnessH_;
            }
            
            //--- piece side types
            [pieceTypeValueArray_ addObject:[NSArray arrayWithObjects:
                                             [NSString stringWithFormat:@"%i", mSide1],
                                             [NSString stringWithFormat:@"%i", mSide2],
                                             [NSString stringWithFormat:@"%i", mSide3],
                                             [NSString stringWithFormat:@"%i", mSide4],
                                             nil]];
            
            
            //===
            
            
            //--- frames for cropping and imageviews
            mXPoint = MAX(mCubeWidth, MIN(arc4random() % MAX(1,(int)(self.view.frame.size.width - mCubeWidth*2)) + mCubeWidth, self.view.frame.size.width - mCubeWidth*2));
            
            mYPoint = MAX(mCubeHeight, MIN(arc4random() % MAX(1,(int)(self.view.frame.size.height - mCubeHeight*2)) + mCubeHeight, self.view.frame.size.height - mCubeHeight*2));
            
            float YPOSITiON = 64.0+topImageView.frame.size.height+10;
            
            [pieceCoordinateRectArray_ addObject:[NSArray arrayWithObjects:
                                                  [NSValue valueWithCGRect:CGRectMake(j*blockWidthValue_,i*blockHeightValue_,mCubeWidth,mCubeHeight)],
                                                  [NSValue valueWithCGRect:CGRectMake((j*blockWidthValue_-(mSide1==1?-deepnessV_:0)),YPOSITiON+i*blockHeightValue_-(mSide4==1?-deepnessH_:0), mCubeWidth, mCubeHeight)], nil]];
            
            
            //===
            
            // Rotation
            [pieceRotationValuesArray_ addObject:[NSNumber numberWithFloat:0]];
            
            mCounter++;
        }
    }
}

//if previous Coordinates available
else{
    pieceTypeValueArray_ = previousValuesArray;
    pieceCoordinateRectArray_ = previousCoordinatesArray;
    pieceRotationValuesArray_ = previousRotationArray;
}

//save the arrays in userdefaults
    if(previousCoordinatesArray == nil){
        
        [[NSUserDefaults standardUserDefaults] setObject:pieceTypeValueArray_ forKey:@"PREVOIUS_VALUES"];
        NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:pieceCoordinateRectArray_];
        [currentDefaults setObject:data forKey:@"PREVOIUS_COORDINATES"];
        [[NSUserDefaults standardUserDefaults] setObject:pieceRotationValuesArray_ forKey:@"PREVOIUS_ROTATIONS"];
        
        NSLog(@"PREVOIUS_COORDINATES PREVOIUS_COORDINATES PREVOIUS_COORDINATES");
    }
}


- (void)setUpPeaceBezierPaths
{
    
    //---
    pieceBezierPathsMutArray_ = [NSMutableArray new];
    
    pieceBezierPathsWithoutHolesMutArray_ = [NSMutableArray new];
    //===
    
    
    float mYSideStartPos = 0;
    
    float mXSideStartPos = 0;
    
    float mCustomDeepness = 0;
    
    float mCurveHalfVLength = blockWidthValue_ / 10;
    
    float mCurveHalfHLength = blockHeightValue_ / 10;
    
    float mCurveStartXPos = blockWidthValue_ / 2 - mCurveHalfVLength;
    
    float mCurveStartYPos = blockHeightValue_ / 2 - mCurveHalfHLength;
    
    float mTotalHeight = 0;
    
    float mTotalWidth = 0;
    
    
    
    for(int i = 0; i < [pieceTypeValueArray_ count]; i++)
    {
        mXSideStartPos = ([[[pieceTypeValueArray_ objectAtIndex:i] objectAtIndex:0] intValue] == 1)?-deepnessV_:0;
        
        mYSideStartPos = ([[[pieceTypeValueArray_ objectAtIndex:i] objectAtIndex:3] intValue] == 1)?-deepnessH_:0;
        
        
        mTotalHeight = mYSideStartPos + mCurveStartYPos*2 + mCurveHalfHLength * 2;
        
        mTotalWidth = mXSideStartPos + mCurveStartXPos*2 + mCurveHalfVLength * 2;
        
        
        //--- bezierPath begins
        UIBezierPath* mPieceBezier = [UIBezierPath bezierPath];
        
        [mPieceBezier moveToPoint: CGPointMake(mXSideStartPos, mYSideStartPos)];
        //===
        
        
        //--- bezier for touches begins
        UIBezierPath* mTouchPieceBezier = [UIBezierPath bezierPath];
        
        [mTouchPieceBezier moveToPoint: CGPointMake(mXSideStartPos, mYSideStartPos)];
        //===
        
        
        //--- left side
        [mPieceBezier addLineToPoint: CGPointMake(mXSideStartPos, mYSideStartPos + mCurveStartYPos)];
        
        if(![[[pieceTypeValueArray_ objectAtIndex:i] objectAtIndex:0] isEqualToString:@"0"])
        {
            mCustomDeepness = deepnessV_ * [[[pieceTypeValueArray_ objectAtIndex:i] objectAtIndex:0] intValue];
            
            [mPieceBezier addCurveToPoint: CGPointMake(mXSideStartPos + mCustomDeepness, mYSideStartPos + mCurveStartYPos+mCurveHalfHLength) controlPoint1: CGPointMake(mXSideStartPos, mYSideStartPos + mCurveStartYPos) controlPoint2: CGPointMake(mXSideStartPos + mCustomDeepness, mYSideStartPos + mCurveStartYPos + mCurveHalfHLength - mCurveStartYPos)];//25
            
            [mPieceBezier addCurveToPoint: CGPointMake(mXSideStartPos, mYSideStartPos + mCurveStartYPos + mCurveHalfHLength*2) controlPoint1: CGPointMake(mXSideStartPos + mCustomDeepness, mYSideStartPos + mCurveStartYPos + mCurveHalfHLength + mCurveStartYPos) controlPoint2: CGPointMake(mXSideStartPos, mYSideStartPos+mCurveStartYPos + mCurveHalfHLength*2)]; //156
        }
        
        [mPieceBezier addLineToPoint: CGPointMake(mXSideStartPos, mTotalHeight)];
        
        
        
        [mTouchPieceBezier addLineToPoint: CGPointMake(mXSideStartPos, mYSideStartPos + mCurveStartYPos)];
        
        if([[[pieceTypeValueArray_ objectAtIndex:i] objectAtIndex:0] isEqualToString:@"1"])
        {
            mCustomDeepness = deepnessV_;
            
            [mTouchPieceBezier addCurveToPoint: CGPointMake(mXSideStartPos + mCustomDeepness, mYSideStartPos + mCurveStartYPos+mCurveHalfHLength) controlPoint1: CGPointMake(mXSideStartPos, mYSideStartPos + mCurveStartYPos) controlPoint2: CGPointMake(mXSideStartPos + mCustomDeepness, mYSideStartPos + mCurveStartYPos + mCurveHalfHLength - mCurveStartYPos)];//25
            
            [mTouchPieceBezier addCurveToPoint: CGPointMake(mXSideStartPos, mYSideStartPos + mCurveStartYPos + mCurveHalfHLength*2) controlPoint1: CGPointMake(mXSideStartPos + mCustomDeepness, mYSideStartPos + mCurveStartYPos + mCurveHalfHLength + mCurveStartYPos) controlPoint2: CGPointMake(mXSideStartPos, mYSideStartPos+mCurveStartYPos + mCurveHalfHLength*2)]; //156
        }
        
        [mTouchPieceBezier addLineToPoint: CGPointMake(mXSideStartPos, mTotalHeight)];
        //===
        
        
        
        
        //--- bottom side
        [mPieceBezier addLineToPoint: CGPointMake(mXSideStartPos+ mCurveStartXPos, mTotalHeight)];
        
        if(![[[pieceTypeValueArray_ objectAtIndex:i] objectAtIndex:1] isEqualToString:@"0"])
        {
            mCustomDeepness = deepnessH_ * [[[pieceTypeValueArray_ objectAtIndex:i] objectAtIndex:1] intValue];
            
            [mPieceBezier addCurveToPoint: CGPointMake(mXSideStartPos + mCurveStartXPos + mCurveHalfVLength, mTotalHeight - mCustomDeepness) controlPoint1: CGPointMake(mXSideStartPos + mCurveStartXPos, mTotalHeight) controlPoint2: CGPointMake(mXSideStartPos + mCurveHalfVLength, mTotalHeight - mCustomDeepness)];
            
            [mPieceBezier addCurveToPoint: CGPointMake(mXSideStartPos + mCurveStartXPos + mCurveHalfVLength+mCurveHalfVLength, mTotalHeight) controlPoint1: CGPointMake(mTotalWidth - mCurveHalfVLength, mTotalHeight - mCustomDeepness) controlPoint2: CGPointMake(mXSideStartPos + mCurveStartXPos + mCurveHalfVLength + mCurveHalfVLength, mTotalHeight)];
        }
        
        [mPieceBezier addLineToPoint: CGPointMake(mTotalWidth, mTotalHeight)];
        
        
        [mTouchPieceBezier addLineToPoint: CGPointMake(mXSideStartPos+ mCurveStartXPos, mTotalHeight)];
        
        if([[[pieceTypeValueArray_ objectAtIndex:i] objectAtIndex:1] isEqualToString:@"1"])
        {
            mCustomDeepness = deepnessH_;
            
            [mTouchPieceBezier addCurveToPoint: CGPointMake(mXSideStartPos + mCurveStartXPos + mCurveHalfVLength, mTotalHeight - mCustomDeepness) controlPoint1: CGPointMake(mXSideStartPos + mCurveStartXPos, mTotalHeight) controlPoint2: CGPointMake(mXSideStartPos + mCurveHalfVLength, mTotalHeight - mCustomDeepness)];
            
            [mTouchPieceBezier addCurveToPoint: CGPointMake(mXSideStartPos + mCurveStartXPos + mCurveHalfVLength+mCurveHalfVLength, mTotalHeight) controlPoint1: CGPointMake(mTotalWidth - mCurveHalfVLength, mTotalHeight - mCustomDeepness) controlPoint2: CGPointMake(mXSideStartPos + mCurveStartXPos + mCurveHalfVLength + mCurveHalfVLength, mTotalHeight)];
        }
        
        [mTouchPieceBezier addLineToPoint: CGPointMake(mTotalWidth, mTotalHeight)];
        //===
        
        
        //--- right side
        [mPieceBezier addLineToPoint: CGPointMake(mTotalWidth, mTotalHeight - mCurveStartYPos)];
        
        if(![[[pieceTypeValueArray_ objectAtIndex:i] objectAtIndex:2] isEqualToString:@"0"])
        {
            mCustomDeepness = deepnessV_ * [[[pieceTypeValueArray_ objectAtIndex:i] objectAtIndex:2] intValue];
            
            [mPieceBezier addCurveToPoint: CGPointMake(mTotalWidth - mCustomDeepness, mYSideStartPos + mCurveStartYPos + mCurveHalfHLength) controlPoint1: CGPointMake(mTotalWidth, mYSideStartPos + mCurveStartYPos + mCurveHalfHLength * 2) controlPoint2: CGPointMake(mTotalWidth - mCustomDeepness, mTotalHeight - mCurveHalfHLength)];
            
            [mPieceBezier addCurveToPoint: CGPointMake(mTotalWidth, mYSideStartPos + mCurveStartYPos) controlPoint1: CGPointMake(mTotalWidth - mCustomDeepness, mYSideStartPos + mCurveHalfHLength) controlPoint2: CGPointMake(mTotalWidth, mCurveStartYPos + mYSideStartPos)];
        }
        
        [mPieceBezier addLineToPoint: CGPointMake(mTotalWidth, mYSideStartPos)];
        
        
        [mTouchPieceBezier addLineToPoint: CGPointMake(mTotalWidth, mTotalHeight - mCurveStartYPos)];
        
        if([[[pieceTypeValueArray_ objectAtIndex:i] objectAtIndex:2] isEqualToString:@"1"])
        {
            mCustomDeepness = deepnessV_;
            
            [mTouchPieceBezier addCurveToPoint: CGPointMake(mTotalWidth - mCustomDeepness, mYSideStartPos + mCurveStartYPos + mCurveHalfHLength) controlPoint1: CGPointMake(mTotalWidth, mYSideStartPos + mCurveStartYPos + mCurveHalfHLength * 2) controlPoint2: CGPointMake(mTotalWidth - mCustomDeepness, mTotalHeight - mCurveHalfHLength)];
            
            [mTouchPieceBezier addCurveToPoint: CGPointMake(mTotalWidth, mYSideStartPos + mCurveStartYPos) controlPoint1: CGPointMake(mTotalWidth - mCustomDeepness, mYSideStartPos + mCurveHalfHLength) controlPoint2: CGPointMake(mTotalWidth, mCurveStartYPos + mYSideStartPos)];
        }
        
        [mTouchPieceBezier addLineToPoint: CGPointMake(mTotalWidth, mYSideStartPos)];
        //===
        
        
        //--- top side
        [mPieceBezier addLineToPoint: CGPointMake(mTotalWidth - mCurveStartXPos, mYSideStartPos)];
        
        if(![[[pieceTypeValueArray_ objectAtIndex:i] objectAtIndex:3] isEqualToString:@"0"])
        {
            mCustomDeepness = deepnessH_ * [[[pieceTypeValueArray_ objectAtIndex:i] objectAtIndex:3] intValue];
            
            [mPieceBezier addCurveToPoint: CGPointMake(mTotalWidth - mCurveStartXPos - mCurveHalfVLength, mYSideStartPos + mCustomDeepness) controlPoint1: CGPointMake(mTotalWidth - mCurveStartXPos, mYSideStartPos) controlPoint2: CGPointMake(mTotalWidth - mCurveHalfVLength, mYSideStartPos + mCustomDeepness)];
            
            [mPieceBezier addCurveToPoint: CGPointMake(mXSideStartPos + mCurveStartXPos, mYSideStartPos) controlPoint1: CGPointMake(mXSideStartPos + mCurveHalfVLength, mYSideStartPos + mCustomDeepness) controlPoint2: CGPointMake(mXSideStartPos + mCurveStartXPos, mYSideStartPos)];
        }
        
        [mPieceBezier addLineToPoint: CGPointMake(mXSideStartPos, mYSideStartPos)];
        
        
        [mTouchPieceBezier addLineToPoint: CGPointMake(mTotalWidth - mCurveStartXPos, mYSideStartPos)];
        
        if([[[pieceTypeValueArray_ objectAtIndex:i] objectAtIndex:3] isEqualToString:@"1"])
        {
            mCustomDeepness = deepnessH_;
            
            [mTouchPieceBezier addCurveToPoint: CGPointMake(mTotalWidth - mCurveStartXPos - mCurveHalfVLength, mYSideStartPos + mCustomDeepness) controlPoint1: CGPointMake(mTotalWidth - mCurveStartXPos, mYSideStartPos) controlPoint2: CGPointMake(mTotalWidth - mCurveHalfVLength, mYSideStartPos + mCustomDeepness)];
            
            [mTouchPieceBezier addCurveToPoint: CGPointMake(mXSideStartPos + mCurveStartXPos, mYSideStartPos) controlPoint1: CGPointMake(mXSideStartPos + mCurveHalfVLength, mYSideStartPos + mCustomDeepness) controlPoint2: CGPointMake(mXSideStartPos + mCurveStartXPos, mYSideStartPos)];
        }
        
        [mTouchPieceBezier addLineToPoint: CGPointMake(mXSideStartPos, mYSideStartPos)];
        //===
        
        
        //---
        [pieceBezierPathsMutArray_ addObject:mPieceBezier];
        
        [pieceBezierPathsWithoutHolesMutArray_ addObject:mTouchPieceBezier];
        //===
    }
}



//set up back view of the puzzle
- (void)setUpBackPuzzlePeaceImages
{
    float mXAddableVal = 0;
    
    float mYAddableVal = 0;
    
    for(int i = 0; i < [pieceBezierPathsMutArray_ count]; i++)
    {
        CGRect mCropFrame = [[[pieceCoordinateRectArray_ objectAtIndex:i] objectAtIndex:0] CGRectValue];
        
        CGRect mImageFrame = [[[pieceCoordinateRectArray_ objectAtIndex:i] objectAtIndex:1] CGRectValue];
        
        //--- puzzle peace image.
        UIImageView *mPeace = [UIImageView new];
        
        [mPeace setFrame:mImageFrame];
        
        [mPeace setTag:i+BACKTAGVALUE];
        
        [mPeace setUserInteractionEnabled:YES];
        
        [mPeace setContentMode:UIViewContentModeTopLeft];
        //===
        
        
        //--- addable value
        mXAddableVal = ([[[pieceTypeValueArray_ objectAtIndex:i] objectAtIndex:0] intValue] == 1)?deepnessV_:0;
        
        mYAddableVal = ([[[pieceTypeValueArray_ objectAtIndex:i] objectAtIndex:3] intValue] == 1)?deepnessH_:0;
        
        mCropFrame.origin.x += mXAddableVal;
        
        mCropFrame.origin.y += mYAddableVal;
        //===
        
        
        //--- crop and clip and add to self view
        [mPeace setImage:[self cropImage:nil
                                withRect:mCropFrame]];
        
        [self setClippingPath:[pieceBezierPathsMutArray_ objectAtIndex:i]:mPeace];
        
        [[self view] addSubview:mPeace];
        
        [mPeace setTransform:CGAffineTransformMakeRotation([[pieceRotationValuesArray_ objectAtIndex:i] floatValue])];
        //===
        
        
        //--- border line
        CAShapeLayer *mBorderPathLayer = [CAShapeLayer layer];
        
        [mBorderPathLayer setPath:[[pieceBezierPathsMutArray_ objectAtIndex:i] CGPath]];
        
        [mBorderPathLayer setFillColor:[UIColor lightGrayColor].CGColor];
        
        [mBorderPathLayer setStrokeColor:[UIColor blackColor].CGColor];
        
        [mBorderPathLayer setLineWidth:0.3];
        
        [mBorderPathLayer setFrame:CGRectZero];
        
        [[mPeace layer] addSublayer:mBorderPathLayer];
        //===
        
        
        //--- secret border line for touch recognition
        CAShapeLayer *mSecretBorder = [CAShapeLayer layer];
        
        [mSecretBorder setPath:[[pieceBezierPathsWithoutHolesMutArray_ objectAtIndex:i] CGPath]];
        
        [mSecretBorder setFillColor:[UIColor clearColor].CGColor];
        
        [mSecretBorder setStrokeColor:[UIColor blackColor].CGColor];
        
        [mSecretBorder setLineWidth:0];
        
        [mSecretBorder setFrame:CGRectZero];
        
        [[mPeace layer] addSublayer:mSecretBorder];
        //===
        
        mPeace.userInteractionEnabled = NO;
        
    }
}



- (void)setUpPuzzlePeaceImages
{
    
    float mXAddableVal = 0;
    
    float mYAddableVal = 0;
    
    pieceImagesArray = [NSMutableArray new];
    
    for(int i = 0; i < [pieceBezierPathsMutArray_ count]; i++)
    {
        CGRect mCropFrame = [[[pieceCoordinateRectArray_ objectAtIndex:i] objectAtIndex:0] CGRectValue];
        
        CGRect mImageFrame = [[[pieceCoordinateRectArray_ objectAtIndex:i] objectAtIndex:1] CGRectValue];
        
        //--- puzzle peace image
        UIImageView *mPeace = [UIImageView new];
        
        [mPeace setFrame:mImageFrame];
        
        [mPeace setTag:i+TAGVALUE];
        
        [mPeace setUserInteractionEnabled:YES];
        
        [mPeace setContentMode:UIViewContentModeTopLeft];
        //===
        
        
        //--- addable value
        mXAddableVal = ([[[pieceTypeValueArray_ objectAtIndex:i] objectAtIndex:0] intValue] == 1)?deepnessV_:0;
        
        mYAddableVal = ([[[pieceTypeValueArray_ objectAtIndex:i] objectAtIndex:3] intValue] == 1)?deepnessH_:0;
        
        mCropFrame.origin.x += mXAddableVal;
        
        mCropFrame.origin.y += mYAddableVal;
        //===
        
        
        //--- crop and clip and add to self view
        [mPeace setImage:[self cropImage:originalImage_ withRect:mCropFrame]];
        
        [self setClippingPath:[pieceBezierPathsMutArray_ objectAtIndex:i]:mPeace];
        
        [[self view] addSubview:mPeace];
        
        [mPeace setTransform:CGAffineTransformMakeRotation([[pieceRotationValuesArray_ objectAtIndex:i] floatValue])];
        //===
        
        
        //--- border line
        CAShapeLayer *mBorderPathLayer = [CAShapeLayer layer];
        
        [mBorderPathLayer setPath:[[pieceBezierPathsMutArray_ objectAtIndex:i] CGPath]];
        
        [mBorderPathLayer setFillColor:[UIColor clearColor].CGColor];
        
        [mBorderPathLayer setStrokeColor:[UIColor blackColor].CGColor];
        
        [mBorderPathLayer setLineWidth:0.3];
        
        [mBorderPathLayer setFrame:CGRectZero];
        
        [[mPeace layer] addSublayer:mBorderPathLayer];
        //===
        
        
        //--- secret border line for touch recognition
        CAShapeLayer *mSecretBorder = [CAShapeLayer layer];
        
        [mSecretBorder setPath:[[pieceBezierPathsWithoutHolesMutArray_ objectAtIndex:i] CGPath]];
        
        [mSecretBorder setFillColor:[UIColor clearColor].CGColor];
        
        [mSecretBorder setStrokeColor:[UIColor blackColor].CGColor];
        
        [mSecretBorder setLineWidth:0];
        
        [mSecretBorder setFrame:CGRectZero];
        
        [[mPeace layer] addSublayer:mSecretBorder];
        //===
        
        
        //--- gestures
        UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
        
        [panRecognizer setMinimumNumberOfTouches:1];
        
        [panRecognizer setMaximumNumberOfTouches:1];
        
        [panRecognizer setDelegate:self];
        
        [mPeace addGestureRecognizer:panRecognizer];
        
        
        //---save image pieces to array
        UIImage *imG = [self imageFromView:mPeace];
        NSData *imgData = UIImagePNGRepresentation(imG);
        [pieceImagesArray addObject:imgData];
    
    }
}


#pragma mark -
#pragma mark help functions

- (void) setClippingPath:(UIBezierPath *)clippingPath : (UIImageView *)imgView;
{
    if (![[imgView layer] mask])
    {
        [[imgView layer] setMask:[CAShapeLayer layer]];
    }
    
    [(CAShapeLayer*) [[imgView layer] mask] setPath:[clippingPath CGPath]];
}


- (UIImage *) cropImage:(UIImage*)originalImage withRect:(CGRect)rect
{
    return [UIImage imageWithCGImage:CGImageCreateWithImageInRect([originalImage CGImage], rect)];
}

#pragma mark -
#pragma mark gesture functions

- (void)move:(id)sender
{
    int state;
    float Xpos,Ypos;

    if(touchedImgViewTag_ == 0 || touchedImgViewTag_ == 99)
    {
        return;
    }

    UIImageView *mImgView = (UIImageView *)[[self view] viewWithTag:touchedImgViewTag_];
    CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:self.view];

    Xpos = firstX_+translatedPoint.x;
    Ypos = firstY_+translatedPoint.y;
    translatedPoint = CGPointMake(Xpos, Ypos);
    [mImgView setCenter:translatedPoint];

    //move state end completed
    if ([sender state] == UIGestureRecognizerStateEnded){
        if((Xpos+mImgView.frame.size.width/2)>[[UIScreen mainScreen] bounds].size.width){
            Xpos = Xpos - mImgView.frame.size.width/4;
        }
        
        if(Xpos<mImgView.frame.size.width/2){
            Xpos = mImgView.frame.size.width/4;
        }
        
        if((Ypos+mImgView.frame.size.height/2)>[[UIScreen mainScreen] bounds].size.height){
            Ypos = Ypos - mImgView.frame.size.height/4;
        }
        
        if(Ypos<mImgView.frame.size.height/2+64.0){
            Ypos = mImgView.frame.size.height/4+64.0;
        }
        
        translatedPoint = CGPointMake(Xpos, Ypos);
        [mImgView setCenter:translatedPoint];
        
    }


    if(AUTO_MATCH)
        state = UIGestureRecognizerStateChanged;

    else
        state = UIGestureRecognizerStateEnded;


    if ([sender state] == state){


    for(int i=BACKTAGVALUE; i<(BACKTAGVALUE+(ROW*COLUMN)); i++){

        UIImageView *ImgView2 = (UIImageView *)[[self view] viewWithTag:i];

        CGPoint translatedPoint2 = CGPointMake(ImgView2.frame.origin.x+ImgView2.frame.size.width/2,ImgView2.frame.origin.y+ImgView2.frame.size.height/2);

        if((mImgView.tag -TAGVALUE) == (i-BACKTAGVALUE)){
        if(CGRectContainsPoint(ImgView2.frame, translatedPoint)){
            [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^ {
                [mImgView setCenter:translatedPoint2];
                mImgView.tag = DISABLETAGVALUE+i;
                mImgView.userInteractionEnabled = NO;
            }
            completion:^(BOOL finished) {
                CompletedImagecount++;
                soundUrl = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/complete.wav", [[NSBundle mainBundle] resourcePath]]];
                NSError *error;
                audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:&error];
                audioPlayer.delegate = self;
                [audioPlayer play];
                
                //when game completed
                if(CompletedImagecount == [pieceTypeValueArray_ count]){

                    //    NSString *congrats= NSLocalizedString(@"Congrats", nil);
                    //    NSString *cameraFrame= NSLocalizedString(@"CameraFrame", nil);

                    NSString *congrats = @"Congratulation\nDone";
                    NSString *cameraFrame= @"New Camera Frame Appear";
                    congratLbl.text = congrats;
                    //dynamic text>>
                    congratTextLbl.text = cameraFrame;
                    NSLog(@"count == %lu ",(unsigned long)[pieceTypeValueArray_ count]);
                }

            }];
        }
        }}

    }
}





- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;//![gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(touchedImgViewTag_ == 0)
    {
        return;
    }
    
    if(!(touchedImgViewTag_>=BACKTAGVALUE)){
    
    UIImageView *mImgView = (UIImageView *)[[self view] viewWithTag:touchedImgViewTag_];
    
    if(!mImgView || ![mImgView isKindOfClass:[UIImageView class]])
    {
        return;
    }
    
    
    CGFloat mRotation = [[pieceRotationValuesArray_ objectAtIndex:mImgView.tag-TAGVALUE] floatValue];
    
    [UIView beginAnimations:nil context:nil];
    
    [UIView setAnimationDuration:0.25];
    
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    [UIView commitAnimations];
    
    [pieceRotationValuesArray_ replaceObjectAtIndex:mImgView.tag-TAGVALUE withObject:[NSNumber numberWithFloat:mRotation]];
        
    }
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    touchedImgViewTag_ = 0;
    
    UITouch *touch = [[event allTouches] anyObject];
    
    CGPoint location = [touch locationInView:self.view];
    
    
    //--- get imageview
    UIImageView *mImgView = nil;
    
    touchedImgViewTag_ = 0;
    
    for(int i = [[[self view] subviews] count]-1; i > -1 ; i--)
    {
        mImgView = (UIImageView *)[[[self view] subviews] objectAtIndex:i];
        
        location = [touch locationInView:mImgView];
        
        
        if(!(mImgView.tag>=BACKTAGVALUE)){
        
        if(CGPathContainsPoint([(CAShapeLayer*) [[[mImgView layer] sublayers] objectAtIndex:1] path], nil, location, NO))
        {
            touchedImgViewTag_ = mImgView.tag;
            
            [[self view] bringSubviewToFront:mImgView];
            
            firstX_ = mImgView.center.x;
            
            firstY_ = mImgView.center.y;
            
            break;
        }
        }
    }
}


#pragma mark -
#pragma mark other functions

//split all the image pieces
-(void)moveAllPieces{
    
    __block NSMutableArray *randomArray = [[NSMutableArray alloc]init];
    
    for(int i=0; i<ROW*COLUMN; i++){
        [randomArray addObject:[NSNumber numberWithInt:i]];
    }
    
    for (int i = 0; i < [randomArray count]; i++) {
        NSInteger remainingCount = [randomArray count] - i;
        NSInteger exchangeIndex = i + arc4random_uniform((u_int32_t )remainingCount);
        [randomArray exchangeObjectAtIndex:i withObjectAtIndex:exchangeIndex];
    }
    
    
    //Down side animation
    __block float DownY = [[UIScreen mainScreen] bounds].size.height/1.12;
    __block float DownX = blockHeightValue_/1.5;
    
    [UIView animateWithDuration:0.5f delay:0.5f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        for(int i=0;i<ROW*COLUMN;i++){
            
            if(i!=0 && i%2 == 0){
                DownX = DownX+([[UIScreen mainScreen] bounds].size.width/16);
            }
            
            if(i!=0 && i%4 == 0){
                DownY = [[UIScreen mainScreen] bounds].size.height/1.12;
            }
            
            CGPoint translatedPoint = CGPointMake(DownX,DownY);
            UIImageView *mImgView = (UIImageView *)[[self view] viewWithTag:TAGVALUE+[[randomArray objectAtIndex:i] intValue]];
            [mImgView setCenter:translatedPoint];
            
            DownY = DownY+5;
            
        }
    } completion:nil];
}



//get shaped images
- (UIImage *)imageFromView:(UIImageView *)view {
    CALayer *layer = view.layer;
    UIGraphicsBeginImageContext([layer frame].size);
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return outputImage;
}


-(IBAction)gotoNextView:(id)sender{
    
//    ImagePieceViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"ImagePieceViewController.h"];
//    view.pieceImagesArray = pieceImagesArray;
//    [self.navigationController pushViewController:view animated:YES];
}


@end
