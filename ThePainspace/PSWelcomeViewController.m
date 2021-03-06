//
//  PSWelcomeViewController.m
//  ThePainspace
//
//  Created by James Ireland on 24/11/2018.
//  Copyright © 2018 The Painspace. All rights reserved.
//

#import "PSWelcomeViewController.h"

#import "PSDirector.h"
#import "PSFont.h"
#import "PSStyle.h"
#import "PSUserDefaults.h"
#import "PSMessageScheduler.h"

@interface PSWelcomeViewController ()

@property (nonatomic, readonly) UIImageView *backgroundImage;
@property (nonatomic, readonly) UILabel *headingLabel;
@property (nonatomic, readonly) UILabel *bodyLabel;
@property (nonatomic, readonly) UIButton *continueButton;

@end

@implementation PSWelcomeViewController

- (void)loadView
{
    UIView *mainView = [[UIView alloc] init];
    self.view = mainView;
    
    _backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DefaultBackground"]];
    _backgroundImage.contentMode = UIViewContentModeScaleAspectFill;
    [mainView addSubview:_backgroundImage];

    _headingLabel = [UILabel new];
    _headingLabel.font = [PSFont preferredFontForTextStyle:UIFontTextStyleTitle1];
    _headingLabel.textColor = [PSStyle lightTextColor];
    _headingLabel.textAlignment = NSTextAlignmentCenter;
    _headingLabel.text = NSLocalizedString(@"WELCOME_HEADING", nil);
    [_headingLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
    [mainView addSubview:_headingLabel];
    
    _bodyLabel = [UILabel new];
    _bodyLabel.font = [PSFont preferredFontForTextStyle:UIFontTextStyleBody];
    _bodyLabel.textColor = [PSStyle darkTextColor];
    _bodyLabel.textAlignment = NSTextAlignmentCenter;
    _bodyLabel.numberOfLines = 0;
    _bodyLabel.text = NSLocalizedString(@"WELCOME_BODY", nil);
    [mainView addSubview:_bodyLabel];
    
    _continueButton = [UIButton new];
    [_continueButton setTitle:NSLocalizedString(@"WELCOME_CONTINUE", nil) forState:UIControlStateNormal];
    [_continueButton addTarget:self action:@selector(continueButtonSelected) forControlEvents:UIControlEventTouchUpInside];
    _continueButton.titleLabel.font = [PSFont preferredFontForTextStyle:UIFontTextStyleBody];
    [mainView addSubview:_continueButton];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_backgroundImage, _headingLabel, _bodyLabel, _continueButton);
    for (UIView *view in [views allValues]) [view setTranslatesAutoresizingMaskIntoConstraints:NO];

    [mainView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_backgroundImage]|" options:0 metrics:nil views:views]];
    [mainView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_backgroundImage]|" options:0 metrics:nil views:views]];

    [mainView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_headingLabel]-|" options:0 metrics:nil views:views]];
    [mainView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_bodyLabel]-|" options:0 metrics:nil views:views]];
    [mainView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_continueButton]-|" options:0 metrics:nil views:views]];
    [mainView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_headingLabel]-36-[_bodyLabel]-36-[_continueButton]" options:0 metrics:nil views:views]];
    
    [mainView addConstraint:[_headingLabel.topAnchor constraintEqualToAnchor:mainView.safeAreaLayoutGuide.topAnchor constant:36.0]];
    [mainView addConstraint:[_continueButton.bottomAnchor constraintEqualToAnchor:mainView.safeAreaLayoutGuide.bottomAnchor constant:-20.0]];
}

- (void)continueButtonSelected
{
    // *center stores a local reference to the UNUserNotificationCenter
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    
    // assign alert types to options
    UNAuthorizationOptions options = UNAuthorizationOptionAlert + UNAuthorizationOptionSound + UNAuthorizationOptionBadge;
    
    // assign options to notification
    [center requestAuthorizationWithOptions:options
                          completionHandler:^(BOOL granted, NSError * _Nullable error) {
                              if (granted) {
                                  dispatch_async(dispatch_get_main_queue(), ^(void){
                                      [PSUserDefaults setMessagesScheduleEpoch:[NSDate date]];
                                      [[PSDirector instance] continueAppSequence];
                                  });
                              } else {
                                  NSLog(@"Something went wrong");
                              }
                          }];
    
    
}

@end
