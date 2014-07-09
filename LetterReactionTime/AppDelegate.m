//
//  AppDelegate.m
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

static NSString * const vocabSources = @"VocabSources";
static NSString * const nounsKey = @"Nouns";
static NSString * const verbsKey = @"Verbs";
static NSString * const fontDescriptions = @"FontDescriptions";
static NSString * const fontNameKey = @"FontName";
static NSString * const fontSizeKey = @"FontSize";
static NSString * const plistExtension = @"plist";

#import "AppDelegate.h"

@interface AppDelegate()

@property (assign, nonatomic, getter = isVerb) BOOL verb;
@property (assign, nonatomic) NSInteger fontIndex;
@property (assign, nonatomic) NSInteger count;
@property (assign, nonatomic) NSTimeInterval timer;

@property (strong, nonatomic) NSMutableArray *verbs;
@property (strong, nonatomic) NSMutableArray *nouns;
@property (strong, nonatomic) NSMutableArray *results;
@property (strong, nonatomic) NSArray *fonts;

- (void)answeredVerb:(BOOL)isAnsweredVerb;
- (void)start;
- (void)finished;

@end

@implementation AppDelegate

#pragma mark - Application Delegate Methods

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [self startAgainButtonTapped:self];
}

#pragma mark - View Methods

- (IBAction)startButtonTapped:(id)sender
{
    self.startButton.hidden = self.hint.hidden = YES;
    self.bButton.hidden = NO;
}

- (IBAction)startAgainButtonTapped:(id)sender
{
    self.vButton.hidden = self.nButton.hidden = self.bButton.hidden = self.startAgainButton.hidden = self.saveResultsButton.hidden = YES;
    self.textField.hidden = self.startButton.hidden = self.hint.hidden = NO;

    self.hint.stringValue = NSLocalizedString(@"Be prepared, experiment will start after you tap the button.", @"Prepare to shart hint");
    self.textField.stringValue = [NSString string];

    NSDictionary *vocabs = [NSDictionary dictionaryWithContentsOfURL:[[NSBundle mainBundle] URLForResource:vocabSources withExtension:plistExtension]];
    self.verbs = vocabs[verbsKey];
    self.nouns = vocabs[nounsKey];

    NSArray *fontsDes = [NSArray arrayWithContentsOfURL:[[NSBundle mainBundle] URLForResource:fontDescriptions withExtension:plistExtension]];
    NSMutableArray *fonts = [NSMutableArray new];
    for (NSDictionary *fontDes in fontsDes) {
        [fonts addObject:[NSFont fontWithName:fontDes[fontNameKey] size:[fontDes[fontSizeKey] intValue]]];
    }
    self.fonts = fonts;

    self.results = [NSMutableArray array];
    self.count = 0;
}

- (IBAction)saveResultsButtonTapped:(id)sender
{
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];

    openPanel.canChooseDirectories = YES;
    openPanel.canChooseFiles = NO;
    openPanel.allowsMultipleSelection = NO;

    if (openPanel.runModal == NSOKButton) {
        NSURL *url = [openPanel.URL URLByAppendingPathComponent:[NSString stringWithFormat:@"Results (%@).plist",[NSDate date]]];
        BOOL saved = [self.results writeToURL:url atomically:YES];
        self.hint.stringValue = saved ? NSLocalizedString(@"Saved", @"Output saved") : NSLocalizedString(@"Failed", @"Output failed");
    }
}

- (IBAction)vButtonTapped:(id)sender
{
    [self answeredVerb:YES];
}

- (IBAction)bButtonTapped:(id)sender
{
    self.bButton.hidden = YES;

    [[NSOperationQueue new] addOperationWithBlock:^{
        [NSThread sleepForTimeInterval:1];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self start];
            self.vButton.hidden = self.nButton.hidden = NO;
        }];
    }];
}

- (IBAction)nButtonTapped:(id)sender
{
    [self answeredVerb:NO];
}

#pragma mark - Private Methods

- (void)answeredVerb:(BOOL)isAnsweredVerb
{
    if (self.nouns.count || self.verbs.count) {
        self.vButton.hidden = self.nButton.hidden = YES;
        self.bButton.hidden = NO;

        self.count++;
        
        NSFont *theFont = self.fonts[self.fontIndex];
        NSDictionary *section = @{@"SECTION": @(self.count),
                                  @"PASSED": @(isAnsweredVerb == self.isVerb),
                                  @"TIME_INTERVAL": @([NSDate timeIntervalSinceReferenceDate] - self.timer),
                                  @"PART_OF_SPEECH": self.isVerb ? @"VERB" : @"NOUN",
                                  @"FONT_NAME": theFont.fontName,
                                  @"FONT_SIZE": @(theFont.pointSize),
                                  @"FONT_ITALICANGLE": @(theFont.italicAngle),
                                  @"WORD": self.textField.stringValue};
        [self.results addObject:section];

        self.textField.stringValue = [NSString string];
    } else {
        [self finished];
    }
}

- (void)start
{
    self.verb = arc4random() % 2;
    self.verb = !self.nouns.count ? YES : self.verb;
    self.verb = !self.verbs.count ? NO : self.verb;
    
    self.fontIndex = arc4random() % self.fonts.count;
    self.textField.font = (self.fonts)[self.fontIndex];
    
    self.textField.stringValue = self.isVerb ? self.verbs[arc4random() % self.verbs.count] : self.nouns[arc4random() % self.nouns.count];
    self.isVerb ? [self.verbs removeObject:self.textField.stringValue] : [self.nouns removeObject:self.textField.stringValue];
    
    self.timer = [NSDate timeIntervalSinceReferenceDate];
}

- (void)finished
{
    self.vButton.hidden = self.bButton.hidden = self.nButton.hidden = self.textField.hidden = self.startButton.hidden = YES;
    self.hint.hidden = self.startAgainButton.hidden = self.saveResultsButton.hidden = NO;

    self.hint.stringValue = NSLocalizedString(@"Finished", @"Test finished hint");
}

@end
