//
//  AppDelegate.h
//  Letter Reaction Time
//
//  Created by Justin Jia on 6/22/13.
//  Copyright (c) 2013 Justin Jia. All rights reserved.
//

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSTextField *textField;
@property (weak) IBOutlet NSTextField *hint;
- (IBAction)startButtonTapped:(id)sender;
- (IBAction)startAgainButtonTapped:(id)sender;
- (IBAction)saveResultsButtonTapped:(id)sender;
- (IBAction)vButtonTapped:(id)sender;
- (IBAction)bButtonTapped:(id)sender;
- (IBAction)nButtonTapped:(id)sender;
@property (weak) IBOutlet NSButton *startButton;
@property (weak) IBOutlet NSButton *vButton;
@property (weak) IBOutlet NSButton *bButton;
@property (weak) IBOutlet NSButton *nButton;
@property (weak) IBOutlet NSButton *saveResultsButton;
@property (weak) IBOutlet NSButton *startAgainButton;

@end
