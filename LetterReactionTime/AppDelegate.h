//
//  AppDelegate.h
//  LetterReactionTime
//
//  MIT License
//
//  Copyright (c) 2014 Justin Jia
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
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
