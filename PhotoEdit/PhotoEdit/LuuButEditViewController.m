//
//  LuuButEditViewController.m
//  PhotoEdit
//
//  Created by TuanTN8 on 3/27/17.
//  Copyright © 2017 Storm. All rights reserved.
//

#import "LuuButEditViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import <AssetsLibrary/AssetsLibrary.h>

#import "LuuButBackgroundView.h"
#import "LuuButView.h"
#import "LuuButImageView.h"
#import "LuuButTextView.h"

#import "LuuButPreviewViewController.h"

#import "LuuButUtils.h"
#import "SSZipArchive.h"
#import "NSString+Additions.h"
#import "UIAlertView+Blocks.h"
#import "CustomActionSheet.h"
#import "FontColorPickerView.h"

typedef enum {
    kControlTypeMain = 0,
    kControlTypeText = 1,
} kControlType;

@interface LuuButEditViewController () <LuuButBackgroundViewDelegate,LuuButViewDelegate,UIGestureRecognizerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    LuuButView *selectedLuuButView;
    
    CGSize beforeSize;
    CGSize luubutBackgroundSize;
    
    BOOL isSetupData;
}

@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *loadingView;
@property (nonatomic, weak) IBOutlet UIView *contentView;
@property (nonatomic, weak) IBOutlet LuuButBackgroundView *backgroundView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *backgroundViewWidth, *backgroundViewHeight;

@property (nonatomic, strong) UIButton *btnSaveLuuBut, *btnPreviewLuuBut, *btnAddFriendLuuBut, *btnMenu;
@property (nonatomic, strong) UIButton *btnOwner;
@property (nonatomic, strong) UIImageView *imgvOwnerAvatar;

@property (nonatomic, weak) IBOutlet UIToolbar *mainToolBar;
@property (nonatomic, strong) UIButton *btnChangeStyle, *btnAddImage, *btnAddSticker, *btnAddText, *btnUndo, *btnRedo;

@property (nonatomic, weak) IBOutlet UIToolbar *textToolBar;
@property (nonatomic, strong) UIButton *btnBoldText, *btnItalicText, *btnUnderlineText, *btnChangeTextFont, *btnChangeTextContent, *btnChangeTextColor;

@property (nonatomic, strong) NSString *sTemplatePath;

@property (nonatomic, strong) NSMutableArray *arrListObjectAdded;
@property (nonatomic, strong) NSString *sTemplateFolderPath;

@end

@implementation LuuButEditViewController

- (id)initWithTemplateAtPath:(NSString *)templatePath
{
    self = [super initWithNibName:@"LuuButEditViewController" bundle:nil];
    if (self) {
        _sTemplatePath = templatePath;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupUI];
    [self setShowLoadingView:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (!isSetupData) {
        [self setupData];
    }
}

- (void)viewDidLayoutSubviews
{
    if (!CGSizeEqualToSize(beforeSize, self.view.bounds.size))
    {
        beforeSize = self.view.bounds.size;
        [self configBackgroundFrame];
    }
    [super viewDidLayoutSubviews];
}

#pragma mark - Action

- (void)touchSaveLuuBut:(id)sender
{
    
}

- (void)touchPreviewLuuBut:(id)sender
{
    LuuButPreviewViewController *vc = [[LuuButPreviewViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)touchAddFriendToEditLuuBut:(id)sender
{
    
}

- (void)touchGotoLuuButOwner:(id)sender
{
    
}

- (void)touchMenu:(id)sender
{
    
}

#pragma mark - EditLuuButView

- (void)addNewLuuButView:(LuuButView *)newLuuButView
{
    newLuuButView.delegate = self;
    
    [newLuuButView setCenter:newLuuButView.center];
    [newLuuButView setBounds:newLuuButView.bounds];
    [newLuuButView setRotate:0];
    newLuuButView.hidden = YES;
    [newLuuButView initialState];
    
    newLuuButView.hidden = NO;
    [self.backgroundView addSubview:newLuuButView];
    [self.backgroundView bringSubviewToFront:newLuuButView];
    
    if ([newLuuButView isKindOfClass:[LuuButTextView class]]) {
        LuuButTextView *textView = (LuuButTextView *)newLuuButView;
        [textView adjustTextView];
    }
    
    newLuuButView.editing = NO;
    [self setSelectedLuuButView];
    
    [self.arrListObjectAdded addObject:newLuuButView];
    [self doSaveState];
}

- (void)setUnselectedLuuButView
{
    if (selectedLuuButView) {
        selectedLuuButView.editing = NO;
    }
}

- (void)setSelectedLuuButView
{
    [self setUnselectedLuuButView];
    
    LuuButView *newSelectedLuubutView = [self.arrListObjectAdded lastObject];
    if (!newSelectedLuubutView) return;
    
    selectedLuuButView = newSelectedLuubutView;
    selectedLuuButView.editing = YES;
    
    [self changeControlType:[selectedLuuButView isKindOfClass:[LuuButTextView class]]?kControlTypeText:kControlTypeMain];
}

- (void)removeSeletectedLuuButView
{
    selectedLuuButView.editing = NO;
    selectedLuuButView = nil;
    
    [self changeControlType:kControlTypeMain];
}

- (void)didBeginEditLuuButView:(LuuButView *)luubutView
{
    NSInteger imageIndex = [self.arrListObjectAdded indexOfObject:luubutView];
    if (imageIndex == NSNotFound) return;
    
    [self.backgroundView bringSubviewToFront:luubutView];
    
    [self.arrListObjectAdded removeObjectAtIndex:imageIndex];
    [self.arrListObjectAdded addObject:luubutView];
    
    [self setSelectedLuuButView];
}

- (void)didEndEditLuuButView:(LuuButView *)luubutView
{
    [self doSaveState];
}

- (void)tapPhotoContentView:(UIGestureRecognizer *)gestureRecognizer
{
    [self changeControlType:kControlTypeMain];
    [self.arrListObjectAdded setValue:@(NO) forKeyPath:@"editing"];
    selectedLuuButView = nil;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return touch.view == gestureRecognizer.view;
}

- (void)didSelectRemoveLuuButView:(LuuButView *)luubutView
{
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:@"Are you sure you want to delete this?" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    
    __weak typeof(self) weakSelf = self;
    av.willDismissBlock = ^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == alertView.firstOtherButtonIndex) {
            [weakSelf removeLuuButView:luubutView];
        }
    };
    
    [av show];
}

- (void)removeLuuButView:(LuuButView *)luubutView
{
    NSInteger imageIndex = [self.arrListObjectAdded indexOfObject:luubutView];
    if (imageIndex != NSNotFound)
    {
        [luubutView remove];
        [self doSaveState];
        [self setSelectedLuuButView];
    }
}

#pragma mark - Undo/Redo

- (void)touchUndo:(id)sender
{
    [self.arrListObjectAdded makeObjectsPerformSelector:@selector(doUndo)];
    [self setEnableUndoRedo];
}

- (void)touchRedo:(id)sender
{
    [self.arrListObjectAdded makeObjectsPerformSelector:@selector(doRedo)];
    [self setEnableUndoRedo];
}

- (void)doSaveState
{
    [self.arrListObjectAdded makeObjectsPerformSelector:@selector(doSaveState)];
    [self setEnableUndoRedo];
}

- (void)setEnableUndoRedo
{
    BOOL enableUndo = NO;
    NSArray *canUndo = [self.arrListObjectAdded valueForKeyPath:@"canUndo"];
    for (NSNumber *value in canUndo) {
        if ([value boolValue]) {
            enableUndo = YES;
            break;
        }
    }
    
    BOOL enableRedo = NO;
    NSArray *canRedo = [self.arrListObjectAdded valueForKeyPath:@"canRedo"];
    for (NSNumber *value in canRedo) {
        if ([value boolValue]) {
            enableRedo = YES;
            break;
        }
    }
    
    [self setEnableUndo:enableUndo enableRedo:enableRedo];
}

#pragma mark - ChangeStyle

- (void)touchChangeStyle:(id)sender
{
    
}

#pragma mark - AddImage

- (void)touchAddImage:(id)sender
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.mediaTypes = @[(NSString *)kUTTypeImage];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = NO;
    
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        NSURL *refURL = [info valueForKey:UIImagePickerControllerReferenceURL];
        
        [[[ALAssetsLibrary alloc] init] assetForURL:refURL resultBlock:^(ALAsset *asset) {
            ALAssetRepresentation *sssetRepresentation = [asset defaultRepresentation];
            
            NSString *imagePath = [self.sTemplateFolderPath stringByAppendingPathComponent:[sssetRepresentation filename]];
            
            UIImage *img = [UIImage imageWithCGImage:[sssetRepresentation fullResolutionImage]];
            NSData * binaryImageData = UIImagePNGRepresentation(img);
            
            if ([binaryImageData writeToFile:imagePath atomically:YES]) {
                [self addNewImage:imagePath];
            }
            else {
                NSLog(@"Get Image Fail!");
            }
        } failureBlock:^(NSError *error) {
            NSLog(@"Get Image Fail!");
        }];
    }];
}

- (void)touchChangeImage:(id)sender
{
    
}

#pragma mark - AddSticker

- (void)touchAddSticker:(id)sender
{
    int r = arc4random_uniform(99);
    NSString *stickerName = [NSString stringWithFormat:@"0%d",r%3];
    NSString *stickerPath = [[NSBundle mainBundle] pathForResource:stickerName ofType:@"png"];
    
    [self addNewImage:stickerPath];
}

- (void)addNewImage:(NSString *)imagePath
{
    UIImage *sticker = [UIImage imageWithContentsOfFile:imagePath];
    CGSize stickerSize = sticker.size;
    
    CGSize bounds = CGSizeMake(self.backgroundViewWidth.constant, self.backgroundViewHeight.constant);
    CGSize imageViewSize = [self getImageSize:stickerSize];
    
    CGRect newImageViewFrame = CGRectMake((bounds.width - imageViewSize.width)/2.0, (bounds.height - imageViewSize.height)/2.0, imageViewSize.width, imageViewSize.height);
    
    LuuButImageView *newImageView = [[LuuButImageView alloc] initWithFrame:newImageViewFrame];
    [newImageView setImagePath:imagePath];
    
    [newImageView setSizeRatio:stickerSize.width/stickerSize.height];
    [newImageView setSuperviewBoundsSize:bounds];
    
    [self addNewLuuButView:newImageView];
}

#pragma mark - AddText

- (void)touchAddText:(id)sender
{
    __weak typeof(self) weakSelf = self;
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Add Text" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    UITextField *tfContent = [alertView textFieldAtIndex:0];
    tfContent.placeholder = @"Text content...";
    
    alertView.willDismissBlock = ^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex != [alertView cancelButtonIndex]) {
            NSString *sTextContent = [[[alertView textFieldAtIndex:0] text] stringByTrimmingTrailingAndLeadingWhitespaceAndNewlineCharacters];
            [weakSelf addTextViewWithText:sTextContent];
        }
    };
    
    alertView.shouldEnableFirstOtherButtonBlock = ^BOOL(UIAlertView *alertView) {
        NSString *sTmpContent = [[[alertView textFieldAtIndex:0] text] stringByTrimmingTrailingAndLeadingWhitespaceAndNewlineCharacters];
        return (sTmpContent.length > 0);
    };
    
    [alertView show];
}

- (void)addTextViewWithText:(NSString *)sText
{
    CGSize bounds = CGSizeMake(self.backgroundViewWidth.constant, self.backgroundViewHeight.constant);
    CGSize textSize = CGSizeMake(bounds.width - 2*viewGlobalInset, bounds.height/2.0);
    
    CGRect newTextViewFrame = CGRectMake((bounds.width - textSize.width)/2.0, (bounds.height - textSize.height)/2.0, textSize.width, textSize.height);
    
    LuuButTextView *newTextView = [[LuuButTextView alloc] initWithFrame:newTextViewFrame];
    [newTextView setText:sText];
    [newTextView setFontName:@"UTM Caviar"];
    
    [newTextView setSuperviewBoundsSize:bounds];
    
    [self addNewLuuButView:newTextView];
}

#pragma mark - EditLuuButTextView

- (void)touchBoldTex:(id)sender
{
    if (!selectedLuuButView || ![selectedLuuButView isKindOfClass:[LuuButTextView class]]) return;
    
    LuuButTextView *textLuuButView = (LuuButTextView *)selectedLuuButView;
    textLuuButView.bold = !textLuuButView.bold;
    
    [self doSaveState];
}

- (void)touchItalicText:(id)sender
{
    if (!selectedLuuButView || ![selectedLuuButView isKindOfClass:[LuuButTextView class]]) return;
    
    LuuButTextView *textLuuButView = (LuuButTextView *)selectedLuuButView;
    textLuuButView.italic = !textLuuButView.italic;
    
    [self doSaveState];
}

- (void)touchUnderlineText:(id)sender
{
    if (!selectedLuuButView || ![selectedLuuButView isKindOfClass:[LuuButTextView class]]) return;
    
    LuuButTextView *textLuuButView = (LuuButTextView *)selectedLuuButView;
    textLuuButView.underline = !textLuuButView.underline;
    
    [self doSaveState];
}

- (void)touchChangeFontText:(id)sender
{
    if (!selectedLuuButView || ![selectedLuuButView isKindOfClass:[LuuButTextView class]]) return;
    
    __weak typeof(self) weakSelf = self;
    __weak LuuButTextView *weakLuuButTextView = (LuuButTextView *)selectedLuuButView;
    
    FontColorPickerView *pickerView = [[FontColorPickerView alloc] init];
    [pickerView showWithCurrentFontName:weakLuuButTextView.fontName demoText:weakLuuButTextView.text block:^(NSString *fontName) {
        [weakLuuButTextView setFontName:fontName];
        [weakSelf doSaveState];
    }];
}

- (void)touchChangeContentText:(id)sender
{
    if (!selectedLuuButView || ![selectedLuuButView isKindOfClass:[LuuButTextView class]]) return;
    
    __weak typeof(self) weakSelf = self;
    __weak LuuButTextView *weakTextLuuButView = (LuuButTextView *)selectedLuuButView;
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Edit Text" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    UITextField *tfContent = [alertView textFieldAtIndex:0];
    tfContent.placeholder = @"Edit content...";
    tfContent.text = weakTextLuuButView.text;
    
    alertView.willDismissBlock = ^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex != [alertView cancelButtonIndex]) {
            NSString *sTextContent = [[alertView textFieldAtIndex:0] text];
            [weakTextLuuButView setText:sTextContent];
            [weakSelf doSaveState];
        }
    };
    
    alertView.shouldEnableFirstOtherButtonBlock = ^BOOL(UIAlertView *alertView) {
        NSString *sTmpContent = [[[alertView textFieldAtIndex:0] text] stringByTrimmingTrailingAndLeadingWhitespaceAndNewlineCharacters];
        return (sTmpContent.length > 0 && ![sTmpContent isEqualToString:weakTextLuuButView.text]);
    };
    
    [alertView show];
}

- (void)touchChangeColorText:(id)sender
{
    if (!selectedLuuButView || ![selectedLuuButView isKindOfClass:[LuuButTextView class]]) return;
    
    __weak typeof(self) weakSelf = self;
    __weak LuuButTextView *weakLuuButTextView = (LuuButTextView *)selectedLuuButView;
    
    FontColorPickerView *pickerView = [[FontColorPickerView alloc] init];
    [pickerView showWithCurrentColor:weakLuuButTextView.color block:^(UIColor *color) {
        [weakLuuButTextView setColor:color];
        [weakSelf doSaveState];
    }];
}

#pragma mark - SetupData

- (NSMutableArray *)arrListObjectAdded
{
    if (!_arrListObjectAdded) {
        _arrListObjectAdded = [[NSMutableArray alloc] init];
    }
    return _arrListObjectAdded;
}

- (void)setupData
{
    isSetupData = YES;
    
    __weak typeof(self) weakSelf = self;
    
    CGSize contentViewSize = self.contentView.bounds.size;
    NSString *sTemplateFolderPath = [LuuButUtils templateContentFolderPath:[[self.sTemplatePath lastPathComponent] stringByDeletingPathExtension]];
    NSString *sTemplatePath = self.sTemplatePath;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BOOL isSuccess = [SSZipArchive unzipFileAtPath:sTemplatePath toDestination:sTemplateFolderPath];
        if (!isSuccess) {
            [self showError];
            return;
        }
        
        NSString *jsonPath = [sTemplateFolderPath stringByAppendingPathComponent:@"info.json"];
        if (![[NSFileManager defaultManager] fileExistsAtPath:jsonPath]) {
            [self showError];
            return;
        }
        
        NSError *error = nil;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:jsonPath] options:NSJSONReadingMutableContainers error:&error];
        if (error) {
            [self showError];
            return;
        }
        
        NSDictionary *templateCollection = json[@"templateCollection"];
        if (!templateCollection || ![templateCollection isKindOfClass:[NSDictionary class]]) {
            [self showError];
            return;
        }
        
        NSDictionary *background_info = templateCollection[@"background_info"];
        if (!background_info || ![background_info isKindOfClass:[NSDictionary class]]) {
            [self showError];
            return;
        }
        
        NSString *bg_img = [sTemplateFolderPath stringByAppendingPathComponent:background_info[@"name"]];
        if (!bg_img) {
            [self showError];
            return;
        }
        
        UIImage *backgroundImage = [UIImage imageWithContentsOfFile:bg_img];
        CGSize backgroundSize = CGSizeMake([background_info[@"width"] floatValue], [background_info[@"height"] floatValue]);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            typeof(self) strongSelf = weakSelf;
            if (strongSelf) {
                [strongSelf configBackgroundStyleWithBackgroundImage:backgroundImage size:backgroundSize];
            }
        });
        
        CGSize backgroundContentSize = [LuuButUtils getPreviewSizeWithVideoSize:backgroundSize boundsSize:contentViewSize];
        NSMutableArray *listLuuButView = [NSMutableArray new];
        
        NSArray *objects_info = templateCollection[@"objects_info"];
        if (objects_info && [objects_info isKindOfClass:[NSArray class]])
        {
            for (NSDictionary *object in objects_info)
            {
                NSString *type = object[@"type"];
                if (!type) continue;
                
                float minSize = 2.0*viewControlSize;
                
                float width = [object[@"width"] floatValue];
                float ratioWidth = width/backgroundSize.width;
                width = backgroundContentSize.width*ratioWidth;
                if (width < minSize) width = minSize;
                
                float height = [object[@"height"] floatValue];
                float ratioHeight = height/backgroundSize.height;
                height = backgroundContentSize.height*ratioHeight;
                if (height < minSize) height = minSize;
                
                float x = [object[@"x"] floatValue];
                float ratioX = x/backgroundSize.width;
                x = backgroundContentSize.width*ratioX - viewGlobalInset;
                
                float y = [object[@"y"] floatValue];
                float rationY = y/backgroundSize.height;
                y = backgroundContentSize.height*rationY - viewGlobalInset;
                
                CGRect viewFrame = CGRectMake(x - viewGlobalInset, y - viewGlobalInset,
                                              width + 2*viewGlobalInset, height + 2*viewGlobalInset);
                
                if ([type isEqualToString:@"image"])
                {
                    NSString *img = object[@"img"];
                    if (!img) continue;
                    
                    img = [sTemplateFolderPath stringByAppendingPathComponent:img];
                    
                    LuuButImageView *newImageView = [[LuuButImageView alloc] initWithFrame:viewFrame];
                    [newImageView setImagePath:img];
                    
                    [newImageView setSizeRatio:width/height];
                    [newImageView setSuperviewBoundsSize:backgroundContentSize];
                    
                    [listLuuButView addObject:newImageView];
                }
                else if ([type isEqualToString:@"text"]) {
                    NSString *content = object[@"content"];
                    if (!content) continue;
                    
                    NSString *fontName = object[@"font_name"];
                    BOOL bold = [object[@"bold"] boolValue];
                    BOOL italic = [object[@"italic"] boolValue];
                    BOOL underline = [object[@"underline"] boolValue];
                    
                    UIFont *font = [UIFont fontWithName:fontName size:10.0];
                    if (!font.fontDescriptor) fontName = @"UTM Caviar";

                    NSString *color = object[@"text_color"];
                    if (!color) color = @"#000000";
                    
                    LuuButTextView *newTextView = [[LuuButTextView alloc] initWithFrame:viewFrame];
                    [newTextView setText:content];
                    [newTextView setFontName:fontName];
                    [newTextView setColor:[LuuButUtils colorFromHexString:color]];
                     
                    [newTextView setBold:bold italic:italic underline:underline];
                    [newTextView setSuperviewBoundsSize:backgroundContentSize];
                    
                    [listLuuButView addObject:newTextView];
                }
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            typeof(self) strongSelf = weakSelf;
            if (strongSelf) {
                [strongSelf configContentWithListLuuButView:listLuuButView templateFolderPath:sTemplateFolderPath];
            }
        });
    });
}

- (void)configBackgroundStyleWithBackgroundImage:(UIImage *)backgroundImage size:(CGSize)size
{
    [self.backgroundView setImage:backgroundImage];
    
    luubutBackgroundSize = size;
    [self configBackgroundFrame];
}

- (void)configContentWithListLuuButView:(NSArray *)listLuuButView templateFolderPath:(NSString *)templateFolderPath
{
    self.sTemplateFolderPath = templateFolderPath;
    
    for (LuuButView *luubutView in listLuuButView) {
        [self addNewLuuButView:luubutView];
    }
    
    [self.arrListObjectAdded makeObjectsPerformSelector:@selector(doRemoveAllSaveState)];
    [self.arrListObjectAdded makeObjectsPerformSelector:@selector(initialState)];
    
    [self removeSeletectedLuuButView];
    
    [self setEnableUndoRedo];
    [self setShowLoadingView:NO];
}

- (void)showError
{
    NSLog(@"Error Data");
}

#pragma mark - ConfigBackgroundFrame

- (void)configBackgroundFrame
{
    if (CGSizeEqualToSize(luubutBackgroundSize, CGSizeZero)) return;

    CGSize backgroundContentSize = [LuuButUtils getPreviewSizeWithVideoSize:luubutBackgroundSize boundsSize:self.contentView.bounds.size];
    if (backgroundContentSize.width == self.backgroundViewWidth.constant && backgroundContentSize.height == self.backgroundViewHeight.constant) return;
    
    [self.backgroundViewWidth setConstant:backgroundContentSize.width];
    [self.backgroundViewHeight setConstant:backgroundContentSize.height];
}

- (void)backgroundDidChangeBounds:(CGSize)newBounds
{
    for (LuuButView *luubutView in self.arrListObjectAdded)
    {
        if (CGSizeEqualToSize(newBounds, luubutView.superviewBoundsSize)) continue;
        
        [luubutView setSuperviewBoundsSize:newBounds];
        
        CGPoint center = CGPointZero;
        center.x = newBounds.width*luubutView.centerPointRatio.width;
        center.y = newBounds.height*luubutView.centerPointRatio.height;
        [luubutView setCenter:center];
        
        CGSize bounds = CGSizeZero;
        bounds.width = newBounds.width*luubutView.boundsRatio.width + 2*viewGlobalInset;
        bounds.height = newBounds.height*luubutView.boundsRatio.height + 2*viewGlobalInset;
        [luubutView setBounds:(CGRect){CGPointZero, bounds}];
    }
}

#pragma mark - SetupUI

- (void)setupUI
{
    self.navigationItem.rightBarButtonItems = @[[self barButton:self.btnPreviewLuuBut],[self barButton:self.btnSaveLuuBut],[self barButton:self.btnAddFriendLuuBut]];
    
    self.view.backgroundColor = [UIColor darkGrayColor];
    self.loadingView.backgroundColor = [UIColor darkGrayColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    UITapGestureRecognizer *tapContent = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPhotoContentView:)];
    tapContent.delegate = self;
    [self.backgroundView addGestureRecognizer:tapContent];
    self.backgroundView.delegate = self;
    
    [self setupToolbar];
    
    [self changeControlType:kControlTypeMain];
}

- (void)setupToolbar
{
    UIBarButtonItem *flexibleItem = [self flexibleItem];
    
    self.mainToolBar.barTintColor = [UIColor whiteColor];
    self.mainToolBar.translucent = NO;
    
    [self.mainToolBar setItems:@[[self barButton:self.btnChangeStyle],flexibleItem,
                                 [self barButton:self.btnAddImage],flexibleItem,
                                 [self barButton:self.btnAddSticker],flexibleItem,
                                 [self barButton:self.btnAddText],flexibleItem,
                                 [self barButton:self.btnUndo],flexibleItem,
                                 [self barButton:self.btnRedo]]];
    
    self.textToolBar.barTintColor = [UIColor whiteColor];
    self.textToolBar.translucent = NO;
    
    [self.textToolBar setItems:@[[self barButton:self.btnBoldText],flexibleItem,
                                 [self barButton:self.btnItalicText],flexibleItem,
                                 [self barButton:self.btnUnderlineText],flexibleItem,
                                 [self barButton:self.btnChangeTextFont],flexibleItem,
                                 [self barButton:self.btnChangeTextContent],flexibleItem,
                                 [self barButton:self.btnChangeTextColor]]];
}

- (UIButton *)btnSaveLuuBut
{
    if (!_btnSaveLuuBut) {
        _btnSaveLuuBut = [self createBarButton:@"btn_luubut_save.png" position:UIControlContentHorizontalAlignmentCenter target:self selector:@selector(touchSaveLuuBut:)];
    }
    return _btnSaveLuuBut;
}

- (UIButton *)btnPreviewLuuBut
{
    if (!_btnPreviewLuuBut) {
        _btnPreviewLuuBut = [self createBarButton:@"btn_luubut_preview.png" position:UIControlContentHorizontalAlignmentCenter target:self selector:@selector(touchPreviewLuuBut:)];
    }
    return _btnPreviewLuuBut;
}

- (UIButton *)btnAddFriendLuuBut
{
    if (!_btnAddFriendLuuBut) {
        _btnAddFriendLuuBut = [self createBarButton:@"btn_luubut_addfriend.png" position:UIControlContentHorizontalAlignmentCenter target:self selector:@selector(touchAddFriendToEditLuuBut:)];
    }
    return _btnAddFriendLuuBut;
}

- (UIButton *)btnMenu
{
    if (!_btnMenu) {
        _btnMenu = [self createBarButton:@"btn_luubut_menu.png" position:UIControlContentHorizontalAlignmentCenter target:self selector:@selector(touchMenu:)];
    }
    return _btnMenu;
}

- (UIImageView *)imgvOwnerAvatar
{
    if (!_imgvOwnerAvatar) {
        _imgvOwnerAvatar = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 16.0, 16.0)];
        _imgvOwnerAvatar.layer.cornerRadius = CGRectGetWidth(_imgvOwnerAvatar.frame)/2.0;
        _imgvOwnerAvatar.clipsToBounds = YES;
        _imgvOwnerAvatar.contentMode = UIViewContentModeScaleAspectFit;
        _imgvOwnerAvatar.userInteractionEnabled = NO;
        _imgvOwnerAvatar.backgroundColor = [UIColor redColor];
    }
    return _imgvOwnerAvatar;
}

- (UIButton *)btnOwner
{
    if (!_btnOwner)
    {
        _btnOwner = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnOwner addTarget:self action:@selector(touchGotoLuuButOwner:) forControlEvents:UIControlEventTouchUpInside];
        
        _btnOwner.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _btnOwner.multipleTouchEnabled = YES;
        _btnOwner.exclusiveTouch = YES;
        _btnOwner.backgroundColor = [UIColor clearColor];
        
        [_btnOwner setFrame:CGRectMake(0.0, 0.0, 30.0, 40.0)];
        [_btnOwner addSubview:self.imgvOwnerAvatar];
        self.imgvOwnerAvatar.center = _btnOwner.center;
    }
    return _btnOwner;
}

- (UIButton *)btnChangeStyle
{
    if (!_btnChangeStyle) {
        _btnChangeStyle = [self createBarButton:@"btn_change_style.png" position:UIControlContentHorizontalAlignmentCenter target:self selector:@selector(touchChangeStyle:)];
    }
    return _btnChangeStyle;
}

- (UIButton *)btnAddImage
{
    if (!_btnAddImage) {
        _btnAddImage = [self createBarButton:@"btn_add_image.png" position:UIControlContentHorizontalAlignmentCenter target:self selector:@selector(touchAddImage:)];
    }
    return _btnAddImage;
}

- (UIButton *)btnAddSticker
{
    if (!_btnAddSticker) {
        _btnAddSticker = [self createBarButton:@"btn_add_sticker.png" position:UIControlContentHorizontalAlignmentCenter target:self selector:@selector(touchAddSticker:)];
    }
    return _btnAddSticker;
}

- (UIButton *)btnAddText
{
    if (!_btnAddText) {
        _btnAddText = [self createBarButton:@"btn_add_text.png" position:UIControlContentHorizontalAlignmentCenter target:self selector:@selector(touchAddText:)];
    }
    return _btnAddText;
}

- (UIButton *)btnUndo
{
    if (!_btnUndo) {
        _btnUndo = [self createBarButton:@"btn_undo.png" position:UIControlContentHorizontalAlignmentCenter target:self selector:@selector(touchUndo:)];
    }
    return _btnUndo;
}

- (UIButton *)btnRedo
{
    if (!_btnRedo) {
        _btnRedo = [self createBarButton:@"btn_redo.png" position:UIControlContentHorizontalAlignmentCenter target:self selector:@selector(touchRedo:)];
    }
    return _btnRedo;
}

- (UIButton *)btnBoldText
{
    if (!_btnBoldText) {
        _btnBoldText = [self createBarButton:@"btn_change_bold_text.png" position:UIControlContentHorizontalAlignmentCenter target:self selector:@selector(touchBoldTex:)];
    }
    return _btnBoldText;
}

- (UIButton *)btnItalicText
{
    if (!_btnItalicText) {
        _btnItalicText = [self createBarButton:@"btn_change_italic_text.png" position:UIControlContentHorizontalAlignmentCenter target:self selector:@selector(touchItalicText:)];
    }
    return _btnItalicText;
}

- (UIButton *)btnUnderlineText
{
    if (!_btnUnderlineText) {
        _btnUnderlineText = [self createBarButton:@"btn_change_underline_text.png" position:UIControlContentHorizontalAlignmentCenter target:self selector:@selector(touchUnderlineText:)];
    }
    return _btnUnderlineText;
}

- (UIButton *)btnChangeTextFont
{
    if (!_btnChangeTextFont) {
        _btnChangeTextFont = [self createBarButton:@"btn_change_font_text.png" position:UIControlContentHorizontalAlignmentCenter target:self selector:@selector(touchChangeFontText:)];
    }
    return _btnChangeTextFont;
}

- (UIButton *)btnChangeTextContent
{
    if (!_btnChangeTextContent) {
        _btnChangeTextContent = [self createBarButton:@"btn_change_content_text.png" position:UIControlContentHorizontalAlignmentCenter target:self selector:@selector(touchChangeContentText:)];
    }
    return _btnChangeTextContent;
}

- (UIButton *)btnChangeTextColor
{
    if (!_btnChangeTextColor) {
        _btnChangeTextColor = [self createBarButton:@"btn_change_color_text.png" position:UIControlContentHorizontalAlignmentCenter target:self selector:@selector(touchChangeColorText:)];
    }
    return _btnChangeTextColor;
}

#pragma mark - Utils

- (void)setEnableUndo:(BOOL)canUndo enableRedo:(BOOL)canRedo
{
    self.btnUndo.enabled = canUndo;
    self.btnRedo.enabled = canRedo;
}

- (void)setShowLoadingView:(BOOL)show
{
    if (show) {
        [self.loadingView startAnimating];
        self.loadingView.hidden = NO;
        [self.view bringSubviewToFront:self.loadingView];
    }
    else {
        [self.loadingView stopAnimating];
        self.loadingView.hidden = YES;
        [self.view sendSubviewToBack:self.loadingView];
    }
}

- (void)changeControlType:(kControlType)controlType
{
    self.mainToolBar.hidden = YES;
    self.textToolBar.hidden = YES;
    
    if (controlType == kControlTypeMain) {
        self.mainToolBar.hidden = NO;
    }
    else {
        self.textToolBar.hidden = NO;
    }
}

- (CGSize)getImageSize:(CGSize)imageSize
{
    CGSize containerSize = self.backgroundView.bounds.size;
    
    float videoRatio = [LuuButUtils roundNumber:imageSize.height/imageSize.width];
    float minLength = 3*viewControlSize - 2*viewGlobalInset;
    
    float width = 0.0;
    float height = 0.0;
    
    if (videoRatio > 1.0) {
        width = minLength;
        height = width*videoRatio;
        
        if (height > containerSize.height) {
            height = containerSize.height;
            width = height/videoRatio;
        }
    }
    else {
        height = minLength;
        width = height/videoRatio;
        
        if (width > containerSize.width) {
            width = containerSize.width;
            height = width*videoRatio;
        }
    }
    
    return CGSizeMake(width + 2*viewGlobalInset, height + 2*viewGlobalInset);
}

- (UIButton *)createBarButton:(NSString *)imageName position:(UIControlContentHorizontalAlignment)position target:(id)target selector:(SEL)selector
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];

    button.contentHorizontalAlignment = position;
    button.multipleTouchEnabled = YES;
    button.exclusiveTouch = YES;
    button.backgroundColor = [UIColor clearColor];
    
    UIImage *normalImage = [UIImage imageNamed:imageName];
    UIImage *highlightedImage = [self tranlucentImage:normalImage withAlpha:0.6];
    float imageWidth = normalImage.size.width;
    
    button.imageView.contentMode = UIViewContentModeCenter;
    [button setImage:normalImage forState:UIControlStateNormal];
    [button setImage:highlightedImage forState:UIControlStateHighlighted];
    [button setImage:highlightedImage forState:UIControlStateDisabled];
    [button setFrame:CGRectMake(0.0, 0.0, imageWidth, 40.0)];
    
    return button;
}

- (UIBarButtonItem *)flexibleItem
{
    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
}

- (UIBarButtonItem *)barButton:(UIView *)customView
{
    return [[UIBarButtonItem alloc] initWithCustomView:customView];
}

- (UIImage *)tranlucentImage:(UIImage *)originalImage withAlpha:(CGFloat)alpha
{
    UIGraphicsBeginImageContextWithOptions(originalImage.size, NO, originalImage.scale);
    [originalImage drawAtPoint:CGPointZero blendMode:kCGBlendModeNormal alpha:alpha];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
