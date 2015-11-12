//
//  ViewController.m
//  canvas
//
//  Created by Chang Liu on 11/12/15.
//  Copyright © 2015 Chang Liu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, assign) CGPoint trayOriginalCenter;
@property (nonatomic, assign) CGPoint mouseOriginalCenter;
@property (nonatomic, assign) CGPoint trayCenterWhenOpen;
@property (nonatomic, assign) CGPoint trayCenterWhenClose;

@property (weak, nonatomic) IBOutlet UIView *trayView;
@property (nonatomic, strong) UIImageView *newlyCreatedFace;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.trayCenterWhenOpen = self.trayView.center;
    self.trayCenterWhenClose = CGPointMake(self.trayCenterWhenOpen.x, self.trayCenterWhenOpen.y + 170);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onTrayPanGuesture:(UIPanGestureRecognizer *)sender {
    CGPoint location = [sender locationInView:self.view];
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        self.trayOriginalCenter = self.trayView.center;
        self.mouseOriginalCenter = location;
        NSLog(@"Gesture began at: %@", NSStringFromCGPoint(location));
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        CGPoint vel = [sender velocityInView:self.trayView];
        if (vel.y > 0) {
            [self closeTray];
        }
        else {
            [self openTray];
        }
        NSLog(@"Gesture changed at: %@", NSStringFromCGPoint(location));
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        NSLog(@"Gesture ended at: %@", NSStringFromCGPoint(location));
    }
}
- (IBAction)onArrowTap:(UITapGestureRecognizer *)sender {
    if (self.trayView.center.y == self.trayCenterWhenOpen.y) {
        [self closeTray];
    }
    else {
        [self openTray];
    }
}

- (void)closeTray {
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:0.6
          initialSpringVelocity:0.8
                        options:UIViewAnimationOptionAllowAnimatedContent
                     animations:^{
                         self.trayView.center = self.trayCenterWhenClose;
                     }
                     completion:nil];
}

- (void)openTray {
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:0.6
          initialSpringVelocity:0.8
                        options:UIViewAnimationOptionAllowAnimatedContent
                     animations:^{
                         self.trayView.center = self.trayCenterWhenOpen;
                     }
                     completion:nil];

}

- (IBAction)onFacePanGesture:(UIPanGestureRecognizer *)sender {
    CGPoint location = [sender locationInView:self.view];
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        // Gesture recognizers know the view they are attached to
        UIImageView *imageView = (UIImageView *)sender.view;
        
        // Create a new image view that has the same image as the one currently panning
        self.newlyCreatedFace = [[UIImageView alloc] initWithImage:imageView.image];
        
        // Add the new face to the tray's parent view.
        [self.view addSubview:self.newlyCreatedFace];
        
        // Initialize the position of the new face.
        self.newlyCreatedFace.center = imageView.center;
        
        // Since the original face is in the tray, but the new face is in the
        // main view, you have to offset the coordinates
        CGPoint faceCenter = self.newlyCreatedFace.center;
        self.newlyCreatedFace.center = CGPointMake(faceCenter.x,
                                                   faceCenter.y + _trayView.frame.origin.y);
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        self.newlyCreatedFace.center = location;
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        NSLog(@"Gesture ended at: %@", NSStringFromCGPoint(location));
    }
}

@end
