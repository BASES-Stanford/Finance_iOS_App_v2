//
//  ViewController.m
//  BASESFinanceV2
//
//  Created by Ryan Matsumoto on 12/13/14.
//  Copyright (c) 2014 BASES. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () {
    NSArray *_teamPickerData;
    NSArray *_requestTypePickerData;
    CGPoint svos;
}
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UIPickerView *teamPicker;
@property (weak, nonatomic) IBOutlet UIPickerView *requestTypePicker;
@property (weak, nonatomic) IBOutlet UITextField *amountRequestedTextField;
@property (weak, nonatomic) IBOutlet UITextField *vendorTextField;
@property (weak, nonatomic) IBOutlet UITextField *explanationTextField;
@property (weak, nonatomic) IBOutlet UITextField *receiptNameTextField;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property(nonatomic) NSString *name;
@property(nonatomic) NSString *email;
@property(nonatomic) NSString *team;
@property(nonatomic) NSString *requestType;
@property(nonatomic) NSString *amountRequested;
@property(nonatomic) NSString *vendor;
@property(nonatomic) NSString *explanation;
@property(nonatomic) NSString *receiptName;
@property(nonatomic) NSString *receiptLink;

@end

static NSString *const kKeychainItemName = @"Google Drive- BASES Finance";
static NSString *const kClientID = @"334252154818-b71rhhnealb8vq27m2da7t02sgi7ff05.apps.googleusercontent.com";
static NSString *const kClientSecret = @"Ayphui8bMMr9_L26BFoJrmyT";

@implementation ViewController
@synthesize driveService;

- (void)viewDidLoad {
    [super viewDidLoad];
    _name = @"";
    _email = @"";
    _team = @"BASES Challenge";
    _requestType = @"Reimbursement";
    _amountRequested = @"";
    _vendor = @"";
    _explanation = @"";
    _receiptName = @"";
    _receiptLink = @"";
    
    [self.nameTextField setDelegate: self];
    [self.emailTextField setDelegate:self];
    [self.amountRequestedTextField setDelegate:self];
    [self.vendorTextField setDelegate:self];
    [self.explanationTextField setDelegate:self];
    [self.receiptNameTextField setDelegate:self];
    
    // Initialize Team Picker Data
    _teamPickerData = @[@"BASES Challenge", @"Branding", @"Business Development", @"Core", @"ETL", @"External Relations", @"Finance", @"Frosh Battalion", @"Hackspace", @"Operations", @"Presidents", @"Professional Development"];
    self.teamPicker.dataSource = self;
    self.teamPicker.delegate = self;
    
    // Initialize Request Type Picker Data
    _requestTypePickerData = @[@"Reimbursement", @"Invoice Payment", @"Honorarium Payment", @"Advance Payment"];
    self.requestTypePicker.dataSource = self;
    self.requestTypePicker.delegate = self;
     
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.nameTextField setReturnKeyType:UIReturnKeyDone];
    [self.emailTextField setReturnKeyType:UIReturnKeyDone];
    [self.amountRequestedTextField setReturnKeyType:UIReturnKeyDone];
    [self.vendorTextField setReturnKeyType:UIReturnKeyDone];
    [self.explanationTextField setReturnKeyType:UIReturnKeyDone];
    [self.receiptNameTextField setReturnKeyType:UIReturnKeyDone];
    
    // Adding border to image view
    [self.imageView.layer setBorderColor:[[UIColor blackColor] CGColor]];
    [self.imageView.layer setBorderWidth:2.0];
    
    // Google Drive Things
    
    // Initialize the drive service & load existing credentials from the keychain if available
    self.driveService = [[GTLServiceDrive alloc] init];
    self.driveService.authorizer = [GTMOAuth2ViewControllerTouch authForGoogleFromKeychainForName:kKeychainItemName
                                                                                         clientID:kClientID
                                                                                     clientSecret:kClientSecret];
    ALAssetsLibrary *lib = [[ALAssetsLibrary alloc] init];
    
    // Code that forces app to request access to photos from home screen (to avoid conflict between alert and Auth view)
    [lib enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        NSLog(@"%i",[group numberOfAssets]);
    } failureBlock:^(NSError *error) {
        if (error.code == ALAssetsLibraryAccessUserDeniedError) {
            NSLog(@"user denied access, code: %i",error.code);
        }else{
            NSLog(@"Other error code: %i",error.code);
        }
    }];

}


- (void) viewDidLayoutSubviews {
    [scroller setScrollEnabled:YES];
    [scroller setContentSize:CGSizeMake(self.view.frame.size.width, 1250)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Allows scrolling so keyboard does not hide textfield
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    svos = scroller.contentOffset;
    CGPoint pt;
    CGRect rc = [textField bounds];
    rc = [textField convertRect:rc toView:scroller];
    pt = rc.origin;
    pt.x = 0;
    pt.y -= 60;
    [scroller setContentOffset:pt animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.nameTextField) {
        [scroller setContentOffset:svos animated:YES];
        [self.nameTextField resignFirstResponder];
    }
    else if (textField == self.emailTextField) {
        [scroller setContentOffset:svos animated:YES];
        [self.emailTextField resignFirstResponder];
    }
    else if (textField == self.amountRequestedTextField) {
        [scroller setContentOffset:svos animated:YES];
        [self.amountRequestedTextField resignFirstResponder];
    }
    else if (textField == self.vendorTextField) {
        [scroller setContentOffset:svos animated:YES];
        [self.vendorTextField resignFirstResponder];
    }
    else if (textField == self.explanationTextField) {
        [scroller setContentOffset:svos animated:YES];
        [self.explanationTextField resignFirstResponder];
    }
    else if (textField == self.receiptNameTextField) {
        [self.receiptNameTextField resignFirstResponder];
    }
    return YES;
}


// The number of columns of data
- (int)numberOfComponentsInPickerView:(UIPickerView *)teamPicker
{
    return 1;
}

// The number of rows of data
- (int)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView == _teamPicker)
        return _teamPickerData.count;
    else
        return _requestTypePickerData.count;
}


// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView == _teamPicker)
        return _teamPickerData[row];
    else
        return _requestTypePickerData[row];
}

// Capture the team picker view selection
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    // This method is triggered whenever the user makes a change to the picker selection.
    // The parameter named row and component represents what was selected.
    if (pickerView == _teamPicker)
        _team = [self pickerView:_teamPicker titleForRow:[pickerView selectedRowInComponent:0] forComponent:0];
    else
        _requestType = [self pickerView:_requestTypePicker titleForRow:[pickerView selectedRowInComponent:0] forComponent:0];
}


- (IBAction)editName:(UITextField *)sender {
    _name = sender.text;
}

- (IBAction)editEmail:(UITextField *)sender {
    _email = sender.text;
}

- (IBAction)editAmountRequested:(UITextField *)sender {
    _amountRequested = sender.text;
}

- (IBAction)editVendor:(UITextField *)sender {
    _vendor = sender.text;
}

- (IBAction)editExplanation:(UITextField *)sender {
    _explanation = sender.text;
}

- (IBAction)editReceiptName:(UITextField *)sender {
    _receiptName = sender.text;
}


- (IBAction)takePhotoOfReceipt:(id)sender {
    [self showCamera:TRUE];
}

- (IBAction)chooseReceiptImage:(id)sender {
    [self showCamera:FALSE];
}

- (void)showCamera:(bool)takePhoto
{
    if ([_receiptName isEqualToString:@""]) {
        [self showAlert:@"Missing Receipt Name!" message:@"Please name your receipt before uploading a photo."];
        return;
    }
    
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    
    if (takePhoto && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else
    {
        // In case we're running the iPhone simulator, fall back on the photo library instead.
        cameraUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        {
            [self showAlert:@"Error" message:@"Sorry, iPad Simulator not supported!"];
            return;
        }
    };
    cameraUI.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
    cameraUI.allowsEditing = YES;
    cameraUI.delegate = self;
    [self presentViewController:cameraUI animated:YES completion:nil];
    [cameraUI setNavigationBarHidden:FALSE];
    if (![self isAuthorized])
    {
        // Not yet authorized, request authorization and push the login UI onto the navigation stack.
        [cameraUI pushViewController:[self createAuthController] animated:YES];
    }
    
}


// Handle selection of an image
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:YES completion:nil];
    self.imageView.image = image;
    [scroller setContentOffset:CGPointMake(0, 800) animated:YES];
}

// Handle cancel from image picker/camera.
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

// Helper to check if user is authorized
- (BOOL)isAuthorized
{
    return [((GTMOAuth2Authentication *)self.driveService.authorizer) canAuthorize];
}

// Creates the auth controller for authorizing access to Google Drive.
- (GTMOAuth2ViewControllerTouch *)createAuthController
{
    GTMOAuth2ViewControllerTouch *authController;
    authController = [[GTMOAuth2ViewControllerTouch alloc] initWithScope:kGTLAuthScopeDrive
                                                                clientID:kClientID
                                                            clientSecret:kClientSecret
                                                        keychainItemName:kKeychainItemName
                                                                delegate:self
                                                        finishedSelector:@selector(viewController:finishedWithAuth:error:)];
    return authController;
}

// Handle completion of the authorization process, and updates the Drive service
// with the new credentials.
- (void)viewController:(GTMOAuth2ViewControllerTouch *)viewController
      finishedWithAuth:(GTMOAuth2Authentication *)authResult
                 error:(NSError *)error
{
    if (error != nil)
    {
        [self showAlert:@"Authentication Error" message:error.localizedDescription];
        self.driveService.authorizer = nil;
    }
    else
    {
        self.driveService.authorizer = authResult;
    }
}

// Uploads a photo to Google Drive
- (void)uploadPhoto:(UIImage*)image
{
    UIAlertView *waitIndicator = [self showWaitIndicator:@"Uploading to Google Drive"];
    GTLDriveFile *file = [GTLDriveFile object];
    file.title = _receiptName;
    file.descriptionProperty = @"Uploaded from the BASES Finance iOS app";
    file.mimeType = @"image/png";
    
    // Find BASES Finance Receipt Images Folder
    GTLQueryDrive *folderQuery = [GTLQueryDrive queryForFilesList];
    
    // Getting month/year for folder purposes
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger month = [components month];
    NSInteger year = [components year];
    NSString* folderMonthYear = [NSString stringWithFormat:@"%ld_%ld_BASES", (long)month, (long)year];
    NSLog(@"Folder name is %@", folderMonthYear);
    
    NSString *queryString = [NSString stringWithFormat: @"mimeType='application/vnd.google-apps.folder' and trashed=false and title='%@'", folderMonthYear];
    folderQuery.q = queryString;
    [self.driveService executeQuery:folderQuery completionHandler:^(GTLServiceTicket *ticket,
                                                                    GTLDriveFileList *files,
                                                                    NSError *error) {
        if (error == nil) {
            if (files.items) {
                // Set up parent folder (BASES Finance Receipt Images)
                NSLog(@"Folders found: %@", files.items[0]);
                GTLDriveParentReference *parentRef = [GTLDriveParentReference object];
                GTLDriveFile *ourFolder = files.items[0];
                parentRef.identifier = ourFolder.identifier;
                NSLog(@"Parent identifier: %@", parentRef.identifier);
                file.parents = [NSArray arrayWithObject:parentRef];
                
                // Create a query to send the image to Google Drive folder
                NSData *data = UIImagePNGRepresentation((UIImage *)image);
                GTLUploadParameters *uploadParameters = [GTLUploadParameters uploadParametersWithData:data MIMEType:file.mimeType];
                GTLQueryDrive *query = [GTLQueryDrive queryForFilesInsertWithObject:file
                                                                   uploadParameters:uploadParameters];
                
                
                [self.driveService executeQuery:query
                              completionHandler:^(GTLServiceTicket *ticket,
                                                  GTLDriveFile *insertedFile, NSError *error) {
                                  [waitIndicator dismissWithClickedButtonIndex:0 animated:YES];
                                  if (error == nil)
                                  {
                                      NSLog(@"Web ID: %@", insertedFile.webContentLink);
                                      _receiptLink = insertedFile.webContentLink;
                                      NSString *post = [NSString stringWithFormat:@"entry_740477170=%@&entry_1398558619=%@&entry_1997415447=%@&entry_13227355=%@&entry_1672183793=%@&entry_1917726610=%@&entry_1900007577=%@&entry_898081017=%@", _name, _email, _team, _requestType, _amountRequested, _vendor, _explanation, _receiptLink];
                                      NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
                                      NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
                                      NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
                                      [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://docs.google.com/forms/d/1dGlFf8WHeIo7sGqeLUGitQUi6dh_GcYI6horMI_oS0I/formResponse"]]];
                                      [request setHTTPMethod:@"POST"];
                                      [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
                                      [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
                                      [request setHTTPBody:postData];
                                      NSURLConnection *conn = [[NSURLConnection alloc]initWithRequest:request delegate:self];
                                      if(conn) {
                                        [self showAlert:@"Google Drive" message:@"Request Submitted!"];
                                      } else {
                                          [self showAlert:@"Google Spreadsheets!" message:@"Google spreadsheets HTTP request error. Please contact Ryan Matsumoto."];
                                      }

                                  }
                                  else
                                  {
                                      NSLog(@"An error occurred: %@", error);
                                      [self showAlert:@"Google Drive" message:@"Sorry, an error occurred!"];
                                  }
                              }];
                
            } else
                [self showAlert:@"Google Drive" message:@"Google Drive folder not found!"];
            
        } else {
            [self showAlert:@"Google Drive" message:@"Sorry, an error occurred!"];
        }
    }];
    
    
}


// Helper for showing a wait indicator in a popup
- (UIAlertView*)showWaitIndicator:(NSString *)title
{
    UIAlertView *progressAlert;
    progressAlert = [[UIAlertView alloc] initWithTitle:title
                                               message:@"Please wait..."
                                              delegate:nil
                                     cancelButtonTitle:nil
                                     otherButtonTitles:nil];
    [progressAlert show];
    
    UIActivityIndicatorView *activityView;
    activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activityView.center = CGPointMake(progressAlert.bounds.size.width / 2,
                                      progressAlert.bounds.size.height - 45);
    
    [progressAlert addSubview:activityView];
    [activityView startAnimating];
    return progressAlert;
}

// Helper for showing an alert
- (void)showAlert:(NSString *)title message:(NSString *)message
{
    UIAlertView *alert;
    alert = [[UIAlertView alloc] initWithTitle: title
                                       message: message
                                      delegate: nil
                             cancelButtonTitle: @"OK"
                             otherButtonTitles: nil];
    [alert show];
}


// Uploading photo via Google Drive API and form fields to spreadsheet via HTTP
- (IBAction)submitAll:(UIButton *)sender {
    float amountRequestedFloatValue = [_amountRequested floatValue];
    if ([_name isEqualToString:@""] || [_email isEqualToString:@""] || [_team isEqualToString:@""] || [_requestType isEqualToString:@""] || [_amountRequested isEqualToString:@""] ||  [_vendor isEqualToString:@""] || [_explanation isEqualToString:@""] || [_receiptName isEqualToString:@""]) {
        [self showAlert:@"BASES Finance" message:@"Please fill out all fields!"];
    }
    else if(amountRequestedFloatValue <= 0) {
        [self showAlert:@"BASES Finance" message:@"Amount requested must exceed $0!"];
    }
    else if(self.imageView.image == nil) {
        [self showAlert:@"BASES Finance" message:@"Please upload a receipt image!"];
    }
    else {
        [self uploadPhoto:self.imageView.image];
    }
}

- (IBAction)reloadReimbursement:(UIButton *)sender {
    self.amountRequestedTextField.text = @"";
    self.vendorTextField.text = @"";
    self.explanationTextField.text = @"";
    self.receiptNameTextField.text = @"";
    self.imageView.image = nil;
    _amountRequested = @"";
    _vendor = @"";
    _explanation = @"";
    _receiptName = @"";
    _receiptLink = @"";
    [self.requestTypePicker selectRow:0 inComponent:0 animated:NO];
    [scroller setContentOffset:
     CGPointMake(0, -scroller.contentInset.top) animated:YES];
}




@end
