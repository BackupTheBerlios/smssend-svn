#import "Ctrl_invio.h"

@implementation Ctrl_invio

- (IBAction)invia:(id)sender
{
	pid_t pid;
	
	//preparazione variabili che contengono prefisso,numero e testo del messaggio
	strcpy(pref,[[prefixEdit stringValue] UTF8String]);
	strcpy(num,[[numberEdit stringValue] UTF8String]);
	strcpy(mess,[[messEdit string] UTF8String]);
	
	//Azzeramento edit del prefisso,del numero e del messaggio
	[prefixEdit setStringValue:@""];
	[numberEdit setStringValue:@""];
	[messEdit setString:@""];
	//[prefixEdit setContinuous:true];
	
	pid=fork();   //creazione processo figlio
	
	if (pid<0)
		exit(0);
	if (pid==0)
	{
		
		
		//strcpy(pref,[prefix UTF8String]);
		//strcpy(num,[number UTF8String]);
		//execl("/usr/bin/alicesms","alicesms",pref,num,mess,0);
	}
	else
		wait(0);
}

@end
