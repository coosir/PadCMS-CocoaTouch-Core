//
//  RRHudControllerTest.m
//  Pad CMS
//
//  Created by Maxim Pervushin on 8/22/12.
//  Copyright (c) PadCMS (http://www.padcms.net)
//
//
//  This software is governed by the CeCILL-C  license under French law and
//  abiding by the rules of distribution of free software.  You can  use,
//  modify and/ or redistribute the software under the terms of the CeCILL-C
//  license as circulated by CEA, CNRS and INRIA at the following URL
//  "http://www.cecill.info".
//
//  As a counterpart to the access to the source code and  rights to copy,
//  modify and redistribute granted by the license, users are provided only
//  with a limited warranty  and the software's author,  the holder of the
//  economic rights,  and the successive licensors  have only  limited
//  liability.
//
//  In this respect, the user's attention is drawn to the risks associated
//  with loading,  using,  modifying and/or developing or reproducing the
//  software by the user in light of its specific status of free software,
//  that may mean  that it is complicated to manipulate,  and  that  also
//  therefore means  that it is reserved for developers  and  experienced
//  professionals having in-depth computer knowledge. Users are therefore
//  encouraged to load and test the software's suitability as regards their
//  requirements in conditions enabling the security of their systems and/or
//  data to be ensured and,  more generally, to use and operate it in the
//  same conditions as regards security.
//
//  The fact that you are presently reading this means that you have had
//  knowledge of the CeCILL-C license and that you accept its terms.
//

#import <GHUnitIOS/GHUnit.h>
#import "OCMock.h"

#import "PCHudController.h"
#import "PCHudView+Test.h"
#import "PCRevisionMock.h"


#define VerticalTocDownloadedNotification @"endOfDownloadingTocNotification"
#define HorizontalTocDownloadedNotification @"PCHorizontalTocDidDownloadNotification"


@interface PCHudControllerTest : GHTestCase
{
    PCHudController *_hudController;
    PCTocView *_topTocView;
    PCTocView *_bottomTocView;
    id _revisionMock;
    id _hudControllerDelegateMock;
    UIView *_containerView;
}

@end


@implementation PCHudControllerTest

- (void)setUp
{
    _hudController = [[PCHudController alloc] init];
    _topTocView = [_hudController.hudView.topTocView retain];
    _bottomTocView = [_hudController.hudView.bottomTocView retain];
    _revisionMock = [[OCMockObject mockForClass:PCRevisionMock.class] retain];
    _hudController.revision = _revisionMock;
    _hudControllerDelegateMock = [OCMockObject niceMockForProtocol:@protocol(RRHudControllerDelegate)];
    _hudController.delegate = _hudControllerDelegateMock;
    _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1000, 1000)];
    [_containerView addSubview:_hudController.hudView];
    _hudController.hudView.frame = _containerView.bounds;
    _hudController.hudView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

- (void)tearDown
{
    [_hudController release];
    [_revisionMock release];
}

- (void)testHudControllerViewsExistence
{
    GHAssertNotNil(_hudController.hudView, nil);
    GHAssertNotNil(_hudController.hudView.topBarView, nil);
    GHAssertNotNil(_hudController.hudView.topTocView, nil);
    GHAssertNotNil(_hudController.hudView.bottomTocView, nil);
}

- (void)testViewsLayout
{
    CGFloat containerWidth = _containerView.bounds.size.width;

    GHAssertEquals(_hudController.hudView.topBarView.bounds.size.width, containerWidth, nil);
    GHAssertEquals(_hudController.hudView.topTocView.bounds.size.width, containerWidth, nil);
    GHAssertEquals(_hudController.hudView.bottomTocView.bounds.size.width, containerWidth, nil);
}

- (void)testViewsInitialStates
{
    /*
     Contract:
     1. Top bar view should be initially hidden;
     2. Top toc view should be initially hidden;
     3. Bottom toc view should be initially hidden.
     */
    
    GHAssertEquals(_hudController.hudView.topBarView.state, PCViewStateHidden, nil);
    GHAssertEquals(_hudController.hudView.topTocView.state, PCViewStateHidden, nil);
    GHAssertEquals(_hudController.hudView.bottomTocView.state, PCViewStateHidden, nil);
}

- (void)testBehaviorInPreviewMode
{
    PCTopBarView *topBarView = _hudController.hudView.topBarView;
    PCTocView *topTocView = _hudController.hudView.topTocView;
    PCTocView *bottomTocView = _hudController.hudView.bottomTocView;
    
    _hudController.previewMode = YES;
    
    // In preview mode hud controller should show/hide top bar and should not show top and bottom tocs if the vertical and/or horizontal tocs of the related revision is not loaded.
    BOOL no = NO;
    [[[_revisionMock stub] andReturnValue:OCMOCK_VALUE(no)] verticalTocLoaded];
    [[[_revisionMock stub] andReturnValue:OCMOCK_VALUE(no)] horizontalTocLoaded];
    
    [_hudController tap];
    GHAssertEquals(topBarView.state, PCViewStateVisible, nil);
    GHAssertEquals(topTocView.state, PCViewStateHidden, nil);
    GHAssertEquals(bottomTocView.state, PCViewStateHidden, nil);
    
    [_hudController tap];
    GHAssertEquals(topBarView.state, PCViewStateHidden, nil);
    GHAssertEquals(topTocView.state, PCViewStateHidden, nil);
    GHAssertEquals(bottomTocView.state, PCViewStateHidden, nil);

    // In preview mode hud controller should show/hide top bar and should not show top and bottom tocs if the vertical and horizontal tocs of the related revision is loaded.
    BOOL yes = YES;
    [[[_revisionMock stub] andReturnValue:OCMOCK_VALUE(yes)] verticalTocLoaded];
    [[[_revisionMock stub] andReturnValue:OCMOCK_VALUE(yes)] horizontalTocLoaded];
    
    [_hudController tap];
    GHAssertEquals(topBarView.state, PCViewStateVisible, nil);
    GHAssertEquals(topTocView.state, PCViewStateHidden, nil);
    GHAssertEquals(bottomTocView.state, PCViewStateHidden, nil);
    
    [_hudController tap];
    GHAssertEquals(topBarView.state, PCViewStateHidden, nil);
    GHAssertEquals(topTocView.state, PCViewStateHidden, nil);
    GHAssertEquals(bottomTocView.state, PCViewStateHidden, nil);
}

- (void)testTopTocViewBehavior
{
    PCTopBarView *topBarView = _hudController.hudView.topBarView;
    PCTocView *topTocView = _hudController.hudView.topTocView;
    
    _hudController.previewMode = NO;
    [topTocView transitToState:PCViewStateVisible animated:NO];

    GHAssertEquals(topBarView.state, PCViewStateHidden, nil);
    GHAssertEquals(topTocView.state, PCViewStateVisible, nil);
    
    [topTocView tapButton];

    GHAssertEquals(topBarView.state, PCViewStateVisible, nil);
    GHAssertEquals(topTocView.state, PCViewStateActive, nil);
    
    [topTocView tapButton];
    
    GHAssertEquals(topBarView.state, PCViewStateHidden, nil);
    GHAssertEquals(topTocView.state, PCViewStateVisible, nil);

    [topTocView tapButton];
    
    GHAssertEquals(topBarView.state, PCViewStateVisible, nil);
    GHAssertEquals(topTocView.state, PCViewStateActive, nil);

    [_hudController tap];
    
    GHAssertEquals(topBarView.state, PCViewStateHidden, nil);
    GHAssertEquals(topTocView.state, PCViewStateVisible, nil);
}

- (void)testBottomTocViewBehavior
{
    _hudController.hudView.topTocView = nil;
    _hudController.previewMode = NO;
    PCTopBarView *topBarView = _hudController.hudView.topBarView;
    PCTocView *bottomTocView = _hudController.hudView.bottomTocView;

    [topBarView transitToState:PCViewStateHidden animated:NO];
    [bottomTocView transitToState:PCViewStateHidden animated:NO];
    
    BOOL no = NO;
    [[[_revisionMock stub] andReturnValue:OCMOCK_VALUE(no)] verticalTocLoaded];
    [[[_revisionMock stub] andReturnValue:OCMOCK_VALUE(no)] horizontalTocLoaded];

    GHAssertEquals(topBarView.state, PCViewStateHidden, nil);
    GHAssertEquals(bottomTocView.state, PCViewStateHidden, nil);
    
    [_hudController tap];
    
    GHAssertEquals(topBarView.state, PCViewStateVisible, nil);
    GHAssertEquals(bottomTocView.state, PCViewStateHidden, nil);
    
    [_hudController tap];
    
    GHAssertEquals(topBarView.state, PCViewStateHidden, nil);
    GHAssertEquals(bottomTocView.state, PCViewStateHidden, nil);

    [_hudController tap];
    
    GHAssertEquals(topBarView.state, PCViewStateVisible, nil);
    GHAssertEquals(bottomTocView.state, PCViewStateHidden, nil);

    
    id revisionMock = [[OCMockObject niceMockForClass:PCRevisionMock.class] retain];
    _hudController.revision = revisionMock;
    
    BOOL yes = YES;
    [[[revisionMock stub] andReturnValue:OCMOCK_VALUE(yes)] verticalTocLoaded];
    [[[revisionMock stub] andReturnValue:OCMOCK_VALUE(yes)] horizontalTocLoaded];
    [[[revisionMock stub] andReturn:nil] verticalTocLoaded];
    [[[revisionMock stub] andReturn:nil] horizontalTocLoaded];

    [[NSNotificationCenter defaultCenter] postNotificationName:VerticalTocDownloadedNotification
                                                        object:nil];
    
    GHAssertEquals(topBarView.state, PCViewStateVisible, nil);
    GHAssertEquals(bottomTocView.state, PCViewStateVisible, nil);
    
    [_hudController tap];
    
    GHAssertEquals(topBarView.state, PCViewStateHidden, nil);
    GHAssertEquals(bottomTocView.state, PCViewStateHidden, nil);
    
    [_hudController tap];
    
    GHAssertEquals(topBarView.state, PCViewStateVisible, nil);
    GHAssertEquals(bottomTocView.state, PCViewStateVisible, nil);
    
    [bottomTocView tapButton];
    
    GHAssertEquals(topBarView.state, PCViewStateVisible, nil);
    GHAssertEquals(bottomTocView.state, PCViewStateActive, nil);
}

- (void)testPopupsDismission
{
    [[_hudControllerDelegateMock expect] hudControllerDismissAllPopups:_hudController];
    
    _hudController.previewMode = YES;
    
    [_hudController tap];
    [_hudController tap];
    [_hudController tap];
    
    [_hudControllerDelegateMock verify];
}

@end