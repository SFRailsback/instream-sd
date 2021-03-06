//
// inSTREAM-SD-2D (inSTREAM version 3.1)
// Developed by Lang Railsback & Assoc., Arcata CA for Argonne National Laboratory
// Software maintained by Jackson Scientific Computing, McKinleyville CA;
// This library is distributed without any warranty; without even the
// implied warranty of merchantability or fitness for a particular purpose.
// See file LICENSE for details and terms of copying
// 

#import "SurvProb.h"
#import "TroutFunc.h"
#import "globals.h"



@interface HookingSP : SurvProb
{

  TroutFunc* troutFunc;

}

+ createBegin: aZone;
- createEnd;


-  createTroutFuncWithMap: (id <Map>) aMap
            withInputMethod: (SEL) anInputMethod;


- (double) getSurvivalProb;

- (void) drop;

@end



