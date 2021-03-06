/*
 * Copyright 2012  Alex Merry <dev@randomguy3.me.uk>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#import "TZFoundation.h"
#import "InputDelegate.h"

@class Application;
@class Configuration;
@class ContextWindow;
@class Preambles;
@class PreambleEditor;
@class PreviewWindow;
@class SettingsDialog;
@class StyleManager;
@class TikzDocument;
@class ToolBox;
@class Window;
@protocol Tool;

extern Application* app;

/**
 * Manages the main application window
 */
@interface Application: NSObject {
    // the main application configuration
    Configuration     *configFile;
    // maintains the known (user-defined) styles
    StyleManager      *styleManager;
    // maintains the preambles used for previews
    Preambles         *preambles;
    // the last-accessed folders (for open and save dialogs)
    NSString          *lastOpenFolder;
    NSString          *lastSaveAsFolder;

    ToolBox           *toolBox;
    PreambleEditor    *preambleWindow;
    ContextWindow     *contextWindow;
    SettingsDialog    *settingsDialog;

    // the open windows (array of Window*)
    NSMutableArray    *openWindows;

    // tools
    id<Tool>           activeTool;
    NSArray           *tools;
}

/**
 * The main application configuration file
 */
@property (readonly) Configuration *mainConfiguration;

/**
 * The app-wide style manager instance
 */
@property (readonly) StyleManager *styleManager;

/**
 * The app-wide preambles registry
 */
@property (readonly) Preambles *preambles;

/**
 * The tools
 */
@property (readonly) NSArray  *tools;

/**
 * The currently-selected tool
 */
@property (assign)   id<Tool>  activeTool;

/**
 * The folder last actively chosen by a user for opening a file
 */
@property (copy) NSString *lastOpenFolder;

/**
 * The folder last actively chosen by a user for saving a file
 */
@property (copy) NSString *lastSaveAsFolder;

/**
 * The application instance.
 */
+ (Application*) app;

/**
 * Starts the application with a single window containing an empty file
 */
- (id) init;
/**
 * Starts the application with the given files open
 */
- (id) initWithFiles:(NSArray*)files;

/**
 * Loads a new, empty document in a new window
 */
- (void) newWindow;
/**
 * Loads an existing document from a file in a new window
 *
 * @param doc  the document the new window should show
 */
- (void) newWindowWithDocument:(TikzDocument*)doc;
/**
 * Quit the application, confirming with the user if there are
 * changes to any open documents.
 */
- (void) quit;

/**
 * Show the dialog for editing preambles.
 */
- (void) presentPreamblesEditor;
/**
 * Show the context-aware window
 */
- (void) presentContextWindow;
/**
 * Show the settings dialog.
 */
- (void) presentSettingsDialog;

/**
 * Save the application configuration to permanent storage
 *
 * Should be called just before the application exits
 */
- (void) saveConfiguration;

/**
 * @result YES if key event was processed, NO otherwise
 */
- (BOOL) activateToolForKey:(unsigned int)keyVal withMask:(InputMask)mask;

@end

// vim:ft=objc:ts=8:et:sts=4:sw=4
