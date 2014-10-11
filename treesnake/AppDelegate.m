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

PyObject     *treesnakeLib = NULL;

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
    
//    [statusMenu addItemWithTitle:@"Test" action:@selector(testPython:) keyEquivalent:@"t"];
    
    //[statusMenu addItem:[NSMenuItem separatorItem]];
    
    // Quit menu option
    NSMenuItem *tItem = nil;
    tItem = [statusMenu addItemWithTitle:@"Quit" action:@selector(terminate:) keyEquivalent:@"q"];
    [tItem setKeyEquivalentModifierMask:NSCommandKeyMask];
    
    // Attach the menu
    [statusItem setMenu:statusMenu];
    
    [self reloadPython];
    [self updateStatusMenu];
    
    NSString *refresh_rate = call_function(@"refresh_rate");
    
    NSLog(@"%lld", [refresh_rate longLongValue]);
    
    [NSTimer scheduledTimerWithTimeInterval:[refresh_rate longLongValue]
                                     target:self
                                   selector:@selector(updateStatusMenu)
                                   userInfo:nil
                                    repeats:YES];
}

-(void) updateStatusMenu {
    NSString *output = call_function(@"command");
    if (output) {
        NSString *text = output;
        statusItem.title = text;
    } else {
        statusItem.title = @"NULL";
    }
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (void) awakeFromNib {
}

-(void)reloadPython
{
    NSLog(@"Load/Reload Python!");
    Py_Initialize();
    const char *pypath = [[[NSBundle mainBundle] resourcePath] UTF8String];

    // import sys
    PyObject *sys = PyImport_Import(PyString_FromString("sys"));

    // sys.path.append(resourcePath)
    PyObject *sys_path_append = PyObject_GetAttrString(PyObject_GetAttrString(sys, "path"), "append");
    PyObject *resourcePath = PyTuple_New(1);
    PyTuple_SetItem(resourcePath, 0, PyString_FromString(pypath));
    PyObject_CallObject(sys_path_append, resourcePath);

    // sys.path.append(~/.treesnake/)
    NSString *homeDir = NSHomeDirectory();
    NSString *treesnakeDir = [homeDir stringByAppendingString:@"/.treesnake"];
    const char *pypath1 = [treesnakeDir cStringUsingEncoding:[NSString defaultCStringEncoding]];;
    PyObject *resourcePath1 = PyTuple_New(1);
    PyTuple_SetItem(resourcePath1, 0, PyString_FromString(pypath1));
    PyObject_CallObject(sys_path_append, resourcePath1);
    
    // import treesnake   # this is in ~/.treesnake/treesnake.py
    treesnakeLib = PyImport_Import(PyString_FromString("treesnake"));
    if (treesnakeLib) {
        NSLog(@"treesnake module loaded");
    } else {
        NSLog(@"treesnake module could not be loaded");
    }
}

-(void)testPython:(id) sender
{
    NSString *output = call_function(@"refresh_rte");
    if (output) {
        NSString *text = output;
        statusItem.title = text;
    } else {
        statusItem.title = @"NULL";
    }
}

NSString *call_function(NSString *functionName)
{
    NSLog(@"Call function.");
    if (treesnakeLib) {
        PyObject *my_func = PyObject_GetAttrString(treesnakeLib, [functionName cStringUsingEncoding:[NSString defaultCStringEncoding]]);
        if (my_func && PyCallable_Check(my_func)){
            PyObject *result = PyObject_CallObject(my_func, NULL);
            return [NSString stringWithFormat:@"%s", PyString_AsString(result)];
        }
        else {
//            return @"Function not found or not callable.";
            return [functionName stringByAppendingString:@": cannot call"];
        }
    } else {
        return @"treesnake: not loaded";
    }
}

@end
