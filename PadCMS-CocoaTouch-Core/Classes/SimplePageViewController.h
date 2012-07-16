//
//  SimplePageViewController.h
//  PadCMS-CocoaTouch-Core
//
//  Created by Alexey Igoshev on 7/9/12.
//  Copyright (c) 2012 Adyax. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractBasePageViewController.h"

@interface SimplePageViewController : AbstractBasePageViewController
{
	PageElementViewController* _backgroundViewController;
	PageElementViewController* _bodyViewController;
	
}
@property (nonatomic, retain) PageElementViewController* backgroundViewController;
@property (nonatomic, retain) PageElementViewController* bodyViewController;


-(void)loadBackground;
@end
