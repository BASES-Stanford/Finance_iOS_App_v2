//
//  ViewController.h
//  BASESFinanceV2
//
//  Created by Ryan Matsumoto on 12/13/14.
//  Copyright (c) 2014 BASES. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>

#import "GTMOAuth2ViewControllerTouch.h"
#import "GTLDrive.h"

#import <AssetsLibrary/AssetsLibrary.h>

@interface ViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate> {
    IBOutlet UIScrollView *scroller;
}

-(NSString *)name;
-(void)setName:(NSString *)name;

-(NSString *)email;
-(void)setEmail:(NSString *)email;

-(NSString *)team;
-(void)setTeam:(NSString *)team;

-(NSString *)requestType;
-(void)setRequestType:(NSString *)requestType;

-(NSString *)amountRequested;
-(void)setAmountRequested:(NSString *)amountRequested;

-(NSString *)vendor;
-(void)setVendor:(NSString *)vendor;

-(NSString *)explanation;
-(void)setExplanation:(NSString *)explanation;

-(NSString*)receiptName;
-(void)setReceiptName:(NSString *)receiptName;

-(NSString*)receiptLink;
-(void)setReceiptLink:(NSString*)receiptLink;

@property (nonatomic, retain) GTLServiceDrive *driveService;


@end

