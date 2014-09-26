//
//  AppDelegate.m
//  treesnake
//
//  Created by Harshad Sharma on 25/09/14.
//  Copyright (c) 2014 Harshad Sharma. All rights reserved.
//
//  Using code examples from:
//    - http://cocoatutorial.grapewave.com/tag/status-bar/
//    - http://howto.oz-apps.com/2013/04/creating-menubar-menu-mac-osx-using.html
//    - http://lepture.com/en/2012/create-a-statusbar-app


#import "AppDelegate.h"
#import "Python.h"


NSStatusItem *statusItem;
NSMenu       *statusMenu;
NSStatusBar  *statusBar;


@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
    statusBar = [NSStatusBar systemStatusBar];
    statusItem = [statusBar statusItemWithLength:NSVariableStatusItemLength];
    statusItem.title = @"·•·";
    statusItem.highlightMode = YES;
    
    // Build on-click menu
    statusMenu = [[NSMenu alloc] initWithTitle:@""];
    [statusMenu setAutoenablesItems:NO];
    
    //[statusMenu addItemWithTitle:@"One" action:nil keyEquivalent:@""];
    //[statusMenu addItemWithTitle:@"Two" action:nil keyEquivalent:@""];
    //[statusMenu addItemWithTitle:@"Three" action:nil keyEquivalent:@""];
    [statusMenu addItemWithTitle:@"Reload" action:@selector(reloadPython:) keyEquivalent:@""];

    
    //[statusMenu addItem:[NSMenuItem separatorItem]];
    
    // Quit menu option
    NSMenuItem *tItem = nil;
    tItem = [statusMenu addItemWithTitle:@"Quit" action:@selector(terminate:) keyEquivalent:@"q"];
    [tItem setKeyEquivalentModifierMask:NSCommandKeyMask];
    
    // Attach the menu
    [statusItem setMenu:statusMenu];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (void) awakeFromNib {
}

-(void)reloadPython:(id) sender
{
    NSLog(@"You asked to reload Python");
}

@end
