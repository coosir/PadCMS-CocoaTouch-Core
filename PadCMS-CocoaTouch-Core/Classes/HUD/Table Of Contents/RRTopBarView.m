//
//  TopBarView.m
//  PadCMS-CocoaTouch-Core
//
//  Created by Maxim Pervushin on 7/27/12.
//  Copyright (c) 2012 Adyax. All rights reserved.
//

#import "RRTopBarView.h"

#import "PCConfig.h"

#define BarBackgroundImage @"panel_button.png"
#define BarLogoImage @"logo.png"
#define BarHomeButtonImage @"button_home.png"
#define BarSummaryButtonImage @"button_summary.png"
#define BarSubscriptionsButtonImage @"button_subscriptions.png"
#define BarShareButtonImage @"button_partager.png"
#define BarHelpButtonImage @"button_answ.png"

#define BarButtonOffset 0

@interface RRTopBarView ()
{
    UIImageView *_backgroundImageView;
    UIButton *_backButton;
    UIButton *_summaryButton;
    UIImageView *_logoImageView;
    UITextField *_searchTextField;
    UIButton *_subscriptionsButton;
    UIButton *_shareButton;
    UIButton *_helpButton;
}

- (void)backButtonTapped:(UIButton *)button;
- (void)summaryButtonTapped:(UIButton *)button;
- (void)subscriptionsButtonTapped:(UIButton *)button;
- (void)shareButtonTapped:(UIButton *)button;
- (void)helpButtonTapped:(UIButton *)button;

@end

@implementation RRTopBarView
@synthesize delegate;

- (void)dealloc
{
    [_backgroundImageView release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self != nil) {
        
        CGSize boundsSize = self.bounds.size;
        
        _backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//        _backgroundImageView.image = [UIImage imageNamed:BarBackgroundImage];
        _backgroundImageView.backgroundColor = [UIColor blackColor];
        [self addSubview:_backgroundImageView];
        
        _backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, boundsSize.height, boundsSize.height)];
        [_backButton setImage:[UIImage imageNamed:BarHomeButtonImage] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(backButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_backButton];
        
        _summaryButton = [[UIButton alloc] initWithFrame:CGRectMake(boundsSize.height + BarButtonOffset, 0, boundsSize.height, boundsSize.height)];
        [_summaryButton setImage:[UIImage imageNamed:BarSummaryButtonImage] forState:UIControlStateNormal];
        [_summaryButton addTarget:self action:@selector(summaryButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_summaryButton];
        
        _logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake((boundsSize.height + BarButtonOffset) * 2, 0, (boundsSize.width - 100) / 2 - (boundsSize.height + BarButtonOffset) * 2, boundsSize.height)];
        _logoImageView.image = [UIImage imageNamed:BarLogoImage];
        _logoImageView.contentMode = UIViewContentModeLeft;
        [self addSubview:_logoImageView];
        
        BOOL searchEnabled = [PCConfig isSearchDisabled] ? NO : YES;
        if (searchEnabled) {
            _searchTextField = [[UITextField alloc] initWithFrame:CGRectMake((boundsSize.height + BarButtonOffset) * 2 + (boundsSize.width - 100) / 2 - (boundsSize.height + BarButtonOffset) * 2,
                                                                             (boundsSize.height - 31) / 2 ,
                                                                             (boundsSize.width - 100) / 2 - (boundsSize.height + BarButtonOffset) * 2,
                                                                             31)];
            _searchTextField.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
            _searchTextField.returnKeyType = UIReturnKeySearch;
            _searchTextField.borderStyle = UITextBorderStyleRoundedRect;
            _searchTextField.delegate = self;
            [self addSubview:_searchTextField];
        }
        
        _subscriptionsButton = [[UIButton alloc] initWithFrame:CGRectMake(boundsSize.width - boundsSize.height * 2 - BarButtonOffset - 100, 0, 100, boundsSize.height)];
        _subscriptionsButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        
        // TODO: make localizable
        [_subscriptionsButton setTitle:@"Abonnement" forState:UIControlStateNormal];
        _subscriptionsButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        
        [_subscriptionsButton setImage:[UIImage imageNamed:BarSubscriptionsButtonImage] forState:UIControlStateNormal];
        [_subscriptionsButton addTarget:self action:@selector(subscriptionsButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_subscriptionsButton];
        
        _shareButton = [[UIButton alloc] initWithFrame:CGRectMake(boundsSize.width - boundsSize.height * 2 - BarButtonOffset, 0, boundsSize.height, boundsSize.height)];
        _shareButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [_shareButton setImage:[UIImage imageNamed:BarShareButtonImage] forState:UIControlStateNormal];
        [_shareButton addTarget:self action:@selector(shareButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_shareButton];
        
        _helpButton = [[UIButton alloc] initWithFrame:CGRectMake(boundsSize.width - boundsSize.height, 0, boundsSize.height, boundsSize.height)];
        _helpButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [_helpButton setImage:[UIImage imageNamed:BarHelpButtonImage] forState:UIControlStateNormal];
        [_helpButton addTarget:self action:@selector(helpButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_helpButton];
    }
    
    return self;
}

- (void)backButtonTapped:(UIButton *)button
{
    NSLog(@"backButtonTapped:");
    
    if ([self.delegate respondsToSelector:@selector(topBarView:backButtonTapped:)]) {
        [self.delegate topBarView:self backButtonTapped:button];
    }
}

- (void)summaryButtonTapped:(UIButton *)button
{
    NSLog(@"summaryButtonTapped:");
    
    if ([self.delegate respondsToSelector:@selector(topBarView:summaryButtonTapped:)]) {
        [self.delegate topBarView:self summaryButtonTapped:button];
    }
}

- (void)subscriptionsButtonTapped:(UIButton *)button
{
    NSLog(@"subscriptionsButtonTapped:");
    
    if ([self.delegate respondsToSelector:@selector(topBarView:subscriptionsButtonTapped:)]) {
        [self.delegate topBarView:self subscriptionsButtonTapped:button];
    }
}

- (void)shareButtonTapped:(UIButton *)button
{
    NSLog(@"shareButtonTapped:");
    
    if ([self.delegate respondsToSelector:@selector(topBarView:shareButtonTapped:)]) {
        [self.delegate topBarView:self shareButtonTapped:button];
    }
}

- (void)helpButtonTapped:(UIButton *)button
{
    NSLog(@"helpButtonTapped:");
    
    if ([self.delegate respondsToSelector:@selector(topBarView:helpButtonTapped:)]) {
        [self.delegate topBarView:self helpButtonTapped:button];
    }
}

#pragma mark - public methods

- (void)setSummaryButtonHidden:(BOOL)hidden animated:(BOOL)animated
{
    void (^block)(void) = ^(void) {
        _summaryButton.alpha = hidden ? 0 : 1;
    };
    
    if (animated) {
        [UIView animateWithDuration:[UIApplication sharedApplication].statusBarOrientationAnimationDuration
                         animations:block];
    } else {
        block();
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    if ([self.delegate respondsToSelector:@selector(topBarView:searchText:)]) {
        [self.delegate topBarView:self searchText:_searchTextField.text];
    }

    return YES;
}

@end
