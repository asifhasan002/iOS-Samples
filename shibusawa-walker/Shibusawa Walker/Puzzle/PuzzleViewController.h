//
//  ViewController.h
//  JigsawPuzzle
//
//  Created by XOR Geek 03 on 12/28/16.
//  Copyright © 2016 XOR Geek 03. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>
#import "Default.h"

@interface PuzzleViewController : UIViewController<UIGestureRecognizerDelegate,AVAudioPlayerDelegate>{
   
//Height and width of image blocks
    NSInteger blockHeightValue_;
    NSInteger blockWidthValue_;

//These values used for creating block curves
    NSInteger deepnessH_;
    NSInteger deepnessV_;
    
//X Y position of per block when touch begins
    CGFloat firstX_;
    CGFloat firstY_;

//get imageview tag when touch begins
    NSInteger touchedImgViewTag_;
    
//These arrays used for creating the block shapes and coordinates
    NSMutableArray *pieceTypeValueArray_;
    NSMutableArray *pieceRotationValuesArray_;
    NSMutableArray *pieceCoordinateRectArray_;
    NSMutableArray *pieceBezierPathsMutArray_;
    NSMutableArray *pieceBezierPathsWithoutHolesMutArray_;
    NSMutableArray *pieceImagesArray;


//sound path for playing a sound
    NSURL *soundUrl;

//check if previous coordinates available or not
    bool previousCoordinateAvailable;
   
    CGFloat lastRotation_;
}

@property (strong, nonatomic) IBOutlet AVAudioPlayer *audioPlayer;
@property (strong, nonatomic) IBOutlet UILabel *congratLbl,*congratTextLbl,*topLbl;
@property (strong, nonatomic) IBOutlet UIImageView *topImageView;

//Image to split into pieces
@property (strong, nonatomic) IBOutlet UIImage *originalImage_;

@end

