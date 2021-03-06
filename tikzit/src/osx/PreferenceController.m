//
//  PreferenceController.m
//  TikZiT
//
//  Created by Karl Johan Paulsson on 26/02/2013.
//  Copyright (c) 2013 Aleks Kissinger. All rights reserved.
//
//
//  This file is part of TikZiT.
//
//  TikZiT is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  TikZiT is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with TikZiT.  If not, see <http://www.gnu.org/licenses/>.
//

#import "PreferenceController.h"

@interface PreferenceController ()

@end

@implementation PreferenceController

- (id)initWithWindowNibName:(NSString *)windowNibName preambleController:(PreambleController *)pc{
    if (!(self = [super initWithWindowNibName:windowNibName])) return nil;
    
    preambleController = pc;
    
    return self;
}

- (NSRect)newFrameForNewContentView:(NSView*)view {
    NSWindow *window = [self window];
    NSRect newFrameRect = [window frameRectForContentRect:[view frame]];
    NSRect oldFrameRect = [window frame];
    NSSize newSize = newFrameRect.size;
    NSSize oldSize = oldFrameRect.size;
    
    NSRect frame = [window frame];
    frame.size = newSize;
    frame.origin.y -= (newSize.height - oldSize.height);
    
    return frame;
}

- (NSView *)viewForTag:(int)tag {
    
    NSView *view = nil;
    switch (tag) {
        default:
        case 0:
            view = generalView;
        break;
        case 1:
            view = engineView;
        break;
        case 2:
            view = updateView;
        break;
        case 3:
            view = preambleView;
        break;
        case 4:
            view = customNodeView;
        break;
    }
    
    return  view;
}

- (BOOL)validateToolbarItem:(NSToolbarItem *)item {
    
    if ([item tag] == currentViewTag) return NO;
    else return YES;
    
}

- (void)awakeFromNib {

    [[self window] setContentSize:[generalView frame].size];
    [[[self window] contentView] addSubview:generalView];
    [[[self window] contentView] setWantsLayer:YES];

    updateController = [[UpdatePreferenceController alloc] initWithNibName:@"UpdatePreferencePanel" bundle:nil];
    [[updateController view] setFrame:[updateView frame]];
    [[[self window] contentView] replaceSubview:updateView with:[updateController view]];
    updateView = [updateController view];

    [[preambleController view] setFrame:[preambleView frame]];
    [[[self window] contentView] replaceSubview:preambleView with:[preambleController view]];
    preambleView = [preambleController view];
    
    customNodeController = [[CustomNodeController alloc] initWithNibName:@"CustomNodes" bundle:nil];
    [[customNodeController view] setFrame:[customNodeView frame]];
    [[[self window] contentView] replaceSubview:customNodeView with:[customNodeController view]];
    customNodeView = [customNodeController view];
    
    [[self window] setContentSize:[engineView frame].size];
    [[[self window] contentView] addSubview:engineView];
    currentViewTag = 1;
}

- (IBAction)switchView:(id)sender {
    
    int tag = [sender tag];
    NSView *view = [self viewForTag:tag];
    NSView *previousView = [self viewForTag:currentViewTag];
    currentViewTag = tag;
    
    NSRect newFrame = [self newFrameForNewContentView:view];
    
    [NSAnimationContext beginGrouping];
    
    if ([[NSApp currentEvent] modifierFlags] & NSShiftKeyMask)
        [[NSAnimationContext currentContext] setDuration:1.0];
    
    [[[[self window] contentView] animator] replaceSubview:previousView with:view];
    [[[self window] animator] setFrame:newFrame display:YES];
    
    [NSAnimationContext endGrouping];

}

@end
