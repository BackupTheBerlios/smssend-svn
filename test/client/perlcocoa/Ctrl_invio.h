/* Ctrl_invio */

#import <Cocoa/Cocoa.h>

@interface Ctrl_invio : NSObject
{
    IBOutlet id forkPid;
    IBOutlet id messEdit;
    IBOutlet id numberEdit;
    IBOutlet id prefixEdit;
	NSString *prefix;
	NSString *number;
	char pref[5];
	char num[10];
	char mess[200];
}
- (IBAction)invia:(id)sender;
@end
