#import "AppDelegate.h"

static NSString *const HiddenFilesOFF = @"😴";
static NSString *const HiddenFilesON = @"😳";

// links
static NSString *const AboutLink = @"http://jamesmarino.name";
static NSString *const AppAboutLink = @"http://jamesmarino.name/projects";

@interface AppDelegate ()

@property (strong, nonatomic) NSStatusItem *statusItem;

// Actions
- (IBAction)clickContact:(id)sender;
- (IBAction)clickAbout:(id)sender;
- (IBAction)clickAppAbout:(id)sender;

@property (strong, nonatomic) IBOutlet NSMenu *statusMenu;
@property (strong, nonatomic) IBOutlet NSWindow *window;

// Commands
@property (strong, nonatomic) NSString *KillFinder;
@property (strong, nonatomic) NSArray *KillFinderArgs;
@property (strong, nonatomic) NSString *Defaults;
@property (strong, nonatomic) NSArray *DefaultsArgsYES;
@property (strong, nonatomic) NSArray *DefaultsArgsNO;

@end

@implementation AppDelegate

- (id)init
{
	self = [super init];
	
	self.KillFinder = @"/usr/bin/killall";
	self.KillFinderArgs = @[@"Finder"];
	self.Defaults = @"/usr/bin/defaults";
	self.DefaultsArgsYES = @[@"write", @"com.apple.finder", @"AppleShowAllFiles", @"YES"];
	self.DefaultsArgsNO = @[@"write", @"com.apple.finder", @"AppleShowAllFiles", @"NO"];
	
	return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	
	self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
	
	// Show hidden files
	self.statusItem.title = HiddenFilesON;
	[self showHiddenFiles:YES];
	
	[self.statusItem setToolTip:@"Hide and Show Hidden Files"];
	[self.statusItem setHighlightMode:NO];
	// [self.statusItem setMenu:self.statusMenu];
	[self.statusItem setAction:@selector(itemClicked:)];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
	
}

- (void)itemClicked:(id)sender
{
	// Check for right click menu
	NSEvent *event = [NSApp currentEvent];
	
	// Right Click
	if([event modifierFlags] & NSControlKeyMask) {
		[self.statusItem popUpStatusItemMenu:self.statusMenu];
		
	} else {
		// Check what setting to place
		if (self.statusItem.title == HiddenFilesOFF) {
			self.statusItem.title = HiddenFilesON;
			[self showHiddenFiles:YES];
		} else if (self.statusItem.title == HiddenFilesON) {
			self.statusItem.title = HiddenFilesOFF;
			[self showHiddenFiles:NO];
		}
	}
}

- (void)showHiddenFiles:(BOOL)show
{
	NSTask *task1 = [[NSTask alloc] init];
	NSTask *task2 = [[NSTask alloc] init];
	
	// Defaults
	task1.launchPath = self.Defaults;
	if (show) {
		task1.arguments = self.DefaultsArgsYES;
	} else {
		task1.arguments = self.DefaultsArgsNO;
	}
	
	// Finder
	task2.launchPath = self.KillFinder;
	task2.arguments = self.KillFinderArgs;
	
	// Execute
	[task1 launch];
	[task2 launch];
}

- (IBAction)clickAbout:(id)sender
{
	[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:AboutLink]];
}

- (IBAction)clickAppAbout:(id)sender
{
	[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:AppAboutLink]];
}

- (IBAction)clickContact:(id)sender
{
	NSString *mailtoAddress = [[NSString stringWithFormat:@"mailto:%@?Subject=%@&body=%@", @"me@jamesmarino.name", @"Feedback Regarding 'ShowTime' App", @""] stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
	
	[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:mailtoAddress]];
}
@end
