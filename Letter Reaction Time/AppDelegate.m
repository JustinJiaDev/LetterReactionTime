//
//  AppDelegate.m
//  Letter Reaction Time
//
//  Created by Justin Jia on 6/22/13.
//  Copyright (c) 2013 Justin Jia. All rights reserved.
//

#import "AppDelegate.h"

#define VOCAB_SOURCES @"VocabSources"
#define NOUNS_KEY @"Nouns"
#define VERBS_KEY @"Verbs"

#define FONT_DESCRIPTIONS @"FontDescriptions"
#define FONT_NAME_KEY @"FontName"
#define FONT_SIZE_KEY @"FontSize"

@interface AppDelegate()

@property (nonatomic) BOOL isVerb;
@property (nonatomic) int fontIndex;
@property (nonatomic) int count;
@property (nonatomic) NSTimeInterval timer;
@property (nonatomic, strong) NSMutableArray *verbs;
@property (nonatomic, strong) NSMutableArray *nouns;
@property (nonatomic, strong) NSArray *fonts;
@property (nonatomic, strong) NSMutableArray *results;
- (void)start;
- (void)answeredVerb:(BOOL)isAnsweredVerb;
- (void)finished;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [self startAgainButtonTapped:self];
}

- (IBAction)startButtonTapped:(id)sender
{
    [self.startButton setHidden:YES];
    [self.hint setHidden:YES];

    [self.bButton setHidden:NO];
}

- (IBAction)startAgainButtonTapped:(id)sender
{
    [self.textField setStringValue:@""];
    [self.textField setHidden:NO];
    [self.startButton setHidden:NO];
    [self.hint setHidden:NO];
    self.hint.stringValue = @"Be prepared, experiment will start after you tap the button.";
    
    [self.vButton setHidden:YES];
    [self.nButton setHidden:YES];
    [self.bButton setHidden:YES];
    [self.startAgainButton setHidden:YES];
    [self.saveResultsButton setHidden:YES];
    
    NSDictionary *vocabs = [NSDictionary dictionaryWithContentsOfURL:[[NSBundle mainBundle] URLForResource:VOCAB_SOURCES withExtension:@"plist"]];
    self.verbs = vocabs[VERBS_KEY];
    self.nouns = vocabs[NOUNS_KEY];
    vocabs = nil;
    
    NSArray *fontsDes = [NSArray arrayWithContentsOfURL:[[NSBundle mainBundle] URLForResource:FONT_DESCRIPTIONS withExtension:@"plist"]];
    NSMutableArray *fonts = [NSMutableArray new];
    for (NSDictionary *fontDes in fontsDes)
        [fonts addObject:[NSFont fontWithName:fontDes[FONT_NAME_KEY] size:[fontDes[FONT_SIZE_KEY] intValue]]];
    self.fonts = fonts;
    fonts = nil;
    
    self.results = [NSMutableArray new];
    self.count = 0;
}

- (IBAction)saveResultsButtonTapped:(id)sender
{
    NSOpenPanel *openDlg = [NSOpenPanel openPanel];
    
    [openDlg setCanChooseFiles:NO];
    [openDlg setCanChooseDirectories:YES];
    [openDlg setAllowsMultipleSelection:NO];
    
    if (openDlg.runModal == NSOKButton) {
        NSURL *url = [openDlg.URL URLByAppendingPathComponent:[NSString stringWithFormat:@"results%@.plist",[NSDate date]]];
        
        if ([self.results writeToURL:url atomically:YES]) {
            self.hint.stringValue = @"Saved!";
        } else {
            self.hint.stringValue = @"Failed!";
        }
    }
}

- (IBAction)vButtonTapped:(id)sender
{
    [self answeredVerb:YES];
}

- (IBAction)bButtonTapped:(id)sender
{
    [self.bButton setHidden:YES];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        [NSThread sleepForTimeInterval:1];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self start];
            [self.vButton setHidden:NO];
            [self.nButton setHidden:NO];
        });
    });
}

- (IBAction)nButtonTapped:(id)sender
{
    [self answeredVerb:NO];
}

- (void)answeredVerb:(BOOL)isAnsweredVerb
{
    if (self.nouns.count || self.verbs.count) {
        [self.vButton setHidden:YES];
        [self.nButton setHidden:YES];
        [self.bButton setHidden:NO];
        
        self.count++;
        
        NSTimeInterval interval = [NSDate timeIntervalSinceReferenceDate] - self.timer;
        NSFont *theFont = (self.fonts)[self.fontIndex];
        
        NSDictionary *section = @{@"SECTION": @(self.count),
                                  @"PASSED": @(isAnsweredVerb == self.isVerb),
                                  @"TIME_INTERVAL": @(interval),
                                  @"PART_OF_SPEECH": self.isVerb ? @"VERB" : @"NOUN",
                                  @"FONT_NAME": theFont.fontName,
                                  @"FONT_SIZE": @(theFont.pointSize),
                                  @"FONT_ITALICANGLE": @(theFont.italicAngle),
                                  @"WORD": self.textField.stringValue};
        
        [self.textField setStringValue:@""];
        [self.results addObject:section];
    } else {
        [self finished];
    }
}

- (void)start
{
    self.isVerb = arc4random() % 2;
    if (!self.nouns.count) self.isVerb = YES;
    if (!self.verbs.count) self.isVerb = NO;
    
    self.fontIndex = arc4random() % self.fonts.count;
    self.textField.font = (self.fonts)[self.fontIndex];
    
    self.textField.stringValue = self.isVerb ? (self.verbs)[arc4random() % self.verbs.count] : (self.nouns)[arc4random() % self.nouns.count];
    self.isVerb ? [self.verbs removeObject:self.textField.stringValue] : [self.nouns removeObject:self.textField.stringValue];
    
    self.timer = [NSDate timeIntervalSinceReferenceDate];
}

- (void)finished
{
    [self.vButton setHidden:YES];
    [self.bButton setHidden:YES];
    [self.nButton setHidden:YES];
    [self.textField setHidden:YES];
    [self.startButton setHidden:YES];

    [self.hint setHidden:NO];
    [self.startAgainButton setHidden:NO];
    [self.saveResultsButton setHidden:NO];
    self.hint.stringValue = @"Test finished! Thank you!";
}

@end
