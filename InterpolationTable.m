//
// inSTREAM-SD-2D (inSTREAM version 3.1)
// Developed by Lang Railsback & Assoc., Arcata CA for Argonne National Laboratory
// Software maintained by Jackson Scientific Computing, McKinleyville CA;
// This library is distributed without any warranty; without even the
// implied warranty of merchantability or fitness for a particular purpose.
// See file LICENSE for details and terms of copying
// 




#import "InterpolationTable.h"


@implementation InterpolationTable

+ create: aZone
{

   InterpolationTable* interpolationTable = [super create: aZone];

   interpolationTable->interpolationZone = [Zone create: aZone];

   interpolationTable->useLogs = NO;

   interpolationTable->funcArrayMax = 0;
   interpolationTable->xValues = nil;
   interpolationTable->yValues = nil;

   interpolationTable->maxX = -LARGEINT;
   
   return interpolationTable;

}


///////////////////////////////////////////////////////
//
// addX:Y
//
// Adds a point to the interpolation function. 
// Points must be added in order of increasing
// X values: if anX is less than or equal to the largest
// X value already in the function, an error is raised.
//
////////////////////////////////////////////////////////
- addX: (double) anX
     Y: (double) aY
{
   double* anXValue = [interpolationZone alloc: sizeof(double)];
   double* aYValue  = [interpolationZone alloc: sizeof(double)];

   if(xValues == nil)
   {
       xValues = [Array createBegin: interpolationZone];
       [xValues setDefaultMember: nil];
       [xValues setCount: 0];
       xValues = [xValues createEnd];
   }

   if(yValues == nil)
   { 
       yValues = [Array createBegin: interpolationZone];
       [yValues setDefaultMember: nil];
       [yValues setCount: 0];
       yValues = [yValues createEnd];
   }
   

   if(anX <= maxX)
   {
       fprintf(stderr, "InterpolationTable >>>> The inputted X = is less than or equal to the largest X\n already in the interpolation function\n");
       fflush(0);
       exit(1);
   }
      
   
   //
   // Reset maxX
   //

   maxX = anX;

   if(useLogs)
   {
       if(anX <= 0.0 || aY <= 0)
       {
           fprintf(stderr, "ERROR: InterpolationTable >>>> addX:Y >>>> Attempt to add zero or negative values to interpolation\n function when using logarithmic interpolation.\n");
           fflush(0);
           exit(1);
       }

       *anXValue = log(anX);
       *aYValue = log(aY); 
   }
   else
   {
       *anXValue = anX;
       *aYValue = aY; 
   }

   [xValues setCount: funcArrayMax + 1];
   [yValues setCount: funcArrayMax + 1];

   [xValues atOffset: funcArrayMax put: (void *) anXValue];
   [yValues atOffset: funcArrayMax put: (void *) aYValue];


   funcArrayMax += 1;

   return self;

}



- reset
{
  int i;
  for(i = 0; i < funcArrayMax; i++)
  {
       //[interpolationZone free: [xValues atOffset: i]];
       //[interpolationZone free: [yValues atOffset: i]];
  }

  //[xValues drop];
  //[yValues drop]; 

  //xValues = nil;
  //yValues = nil;

  [interpolationZone drop];

  useLogs = NO;

  funcArrayMax = 0;

  maxX = (double) -LARGEINT;

  interpolationZone = [Zone create: [self getZone]];

  return self;

}


- setLogarithmicInterpolationOn
{
   int funcArrayIndex;
   double *anX;
   double *aY;

   if(useLogs)
   {
       fprintf(stderr, "WARNING: InterpolationTable >>>> setLogarithmicInterpolationOn >>>> useLogs is **ALREADY** set to on\n");
       fflush(0);
   }
   else
   {
       for(funcArrayIndex = 0; funcArrayIndex < funcArrayMax; funcArrayIndex++)
       {


           if(*(anX = (double *) [xValues atOffset: funcArrayIndex]) <= 0.0)
           {
               fprintf(stderr, "InterpolationTable >>>> setLogarithmicInterpolationOn was called when interpolation table includes at least one X value less than or equal to zero\n");
               fflush(0);
               exit(1);
           }
           if(*(aY = (double *) [yValues atOffset: funcArrayIndex]) <= 0.0)
           {
               fprintf(stderr, "InterpolationTable >>>> setLogarithmicInterpolationOn was called when interpolation table includes at least one Y value less than or equal to zero\n");
               fflush(0);
               exit(1);
           }


           *anX = log(*anX);
           *aY = log(*aY);
   
           [xValues atOffset: funcArrayIndex put: (void *) anX];
           [yValues atOffset: funcArrayIndex put: (void *) aY];

       }

       useLogs = YES;
   }

   return self;

}




////////////////////////////////////////////////
//
// getValueFor
//
// Always assumes input values are not logged.
//
////////////////////////////////////////////////
- (double) getValueFor: (double) anX
{


   if(funcArrayMax < 2)
   {
       fprintf(stderr, "InterpolationTable >>>> getValueFor: >>>> Fewer than 2 pairs of values in interpolation table\n");
       fflush(0);
       exit(1);
   }

   if(useLogs == NO)
   {
      return [self interpolateFor: anX];
   }
   else  // perform logarithmic interpolation
   {

      if(anX <= 0.0)
      {
          fprintf(stderr, "InterpolationTable >>>> getValueFor: >>>> Attempt to get value for a zero or negative X when using logarithmic interpolation\n");
          fflush(0);
          exit(1);
      }

      anX = log(anX);

      return exp([self interpolateFor: anX]);

   }

}



////////////////////////////////////////////
//
// interpolateFor
// 
////////////////////////////////////////////
- (double) interpolateFor: (double) anX
{
   int funcArrayIndex;
   double loFuncX = (double) -LARGEINT;
   double hiFuncX = 0.0;
   double loFuncY = 0.0; 
   double hiFuncY = 0.0;
   double diff = 0.0;


   for(funcArrayIndex = 1; funcArrayIndex < funcArrayMax; funcArrayIndex++)
   {
       hiFuncX = *(double *) [xValues atOffset: funcArrayIndex];
       
            if(anX <= hiFuncX)
            {
               loFuncX = *(double *) [xValues atOffset: funcArrayIndex - 1];
               hiFuncY = *(double *) [yValues atOffset: funcArrayIndex];
               loFuncY = *(double *) [yValues atOffset: funcArrayIndex - 1];
               break;
            }

   }

   if(loFuncX == -LARGEINT)
   {
       //
       // Highest X in function exceeded -
       // so extrapolatefrom 2 highest points
       //

       //
       // Decrement the funcArrayIndex so we don't go beyond the end of the array
       //
       --funcArrayIndex; 
       
       loFuncX = *(double *) [xValues atOffset: funcArrayIndex - 1];
       hiFuncX = *(double *) [xValues atOffset: funcArrayIndex];
       loFuncY = *(double *) [yValues atOffset: funcArrayIndex - 1];
       hiFuncY = *(double *) [yValues atOffset: funcArrayIndex];
   }

   diff = (anX - loFuncX)/(hiFuncX - loFuncX);

   return (loFuncY + (diff * (hiFuncY - loFuncY)));
}



/////////////////////////////////////////////
//
// getTableIndexFor
//
// This method is very similar to getValueFor except that it returns
// funcArrayIndex-1 - the lookup table array offset for
// lowFuncX; 
//
//
// Always assumes input values are not logged.
//
//
/////////////////////////////////////////////
- (int) getTableIndexFor: (double) anX 
{
   int funcArrayIndex;
   double loFuncX = (double) -LARGEINT;
   double hiFuncX = 0.0;

   if(useLogs == YES) 
   {
      if(anX <= 0)
      {
          fprintf(stderr, "ERROR: InterpolationTable >>>> getTableIndexFor >>>> useLogs is ON and input anX is less than or equal to zero\n");
          fflush(0);
          exit(1);
      }
      else
      {
          anX = log(anX);
      }
   }

   if(funcArrayMax < 2)
   {
       fprintf(stderr, "ERROR: InterpolationTable >>>> getTableIndexFor: >>>> Fewer than 2 pairs of values in interpolation table\n");
       fflush(0);
       exit(1);
   }


   for(funcArrayIndex = 1; funcArrayIndex < funcArrayMax; funcArrayIndex++)
   {
       hiFuncX = *(double *) [xValues atOffset: funcArrayIndex];
       
            if(anX <= hiFuncX)
            {
               loFuncX = *(double *) [xValues atOffset: funcArrayIndex - 1];
               break;
            }

   }

   if(loFuncX == -LARGEINT)
   {
       //
       // Highest X in function exceeded -
       // so extrapolatefrom 2 highest points
       //

       //
       // Decrement the funcArrayIndex so we don't go beyond the end of the array
       //
       --funcArrayIndex; 
       
   }

   return funcArrayIndex;
}




/////////////////////////////////////////////
//
// getInterpFractionForX
//
// This method is very similar to getValueFor except that it returns
// diff.
//
// Always assumes input values are not logged.
//
//
/////////////////////////////////////////////
- (double) getInterpFractionFor: (double) anX 
{

   int funcArrayIndex;
   double loFuncX = (double) -LARGEINT;
   double hiFuncX = 0.0;
   double diff = 0.0;

   if(useLogs == YES) 
   {
      if(anX <= 0)
      {
          fprintf(stderr, "ERROR: InterpolationTable >>>> getInterpFracFor: >>>> useLogs is ON and input anX is less than or equal to zero\n");
          fflush(0);
          exit(1);
      }
      else
      {
          anX = log(anX);
      }
   }

   if(funcArrayMax < 2)
   {
       fprintf(stderr, "ERROR: InterpolationTable >>>> getInterpFracFor: >>>> Fewer than 2 pairs of values in interpolation table\n");
       fflush(0);
       exit(1);
   }

   for(funcArrayIndex = 1; funcArrayIndex < funcArrayMax; funcArrayIndex++)
   {
       hiFuncX = *(double *) [xValues atOffset: funcArrayIndex];
       
            if(anX <= hiFuncX)
            {
               loFuncX = *(double *) [xValues atOffset: funcArrayIndex - 1];
               break;
            }

   }

   if(loFuncX == -LARGEINT)
   {
       //
       // Highest X in function exceeded -
       // so extrapolatefrom 2 highest points
       //

       //
       // Decrement the funcArrayIndex so we don't go beyond the end of the array
       //
       --funcArrayIndex; 
       
       loFuncX = *(double *) [xValues atOffset: funcArrayIndex - 1];
       hiFuncX = *(double *) [xValues atOffset: funcArrayIndex];
   }

   diff = (anX - loFuncX)/(hiFuncX - loFuncX);

   return diff;
}



/////////////////////////////////////////////////////
//
// getValueWithTableIndex:
//     withInterpFraction:
//
/////////////////////////////////////////////////////
- (double) getValueWithTableIndex: (int) anIndex 
               withInterpFraction: (double) aFraction
{
     double loFuncY;
     double hiFuncY;

     double returnValue;

     if(funcArrayMax < 2)
     {
         fprintf(stderr, "ERROR: InterpolationTable >>>> getValueWithTableIndex:withInterpFraction: >>>> Fewer than 2 pairs of values in interpolation table\n");
         fflush(0);
         exit(1);
     }

     loFuncY = *(double *) [yValues atOffset: anIndex - 1];
     hiFuncY = *(double *) [yValues atOffset: anIndex];

     returnValue = loFuncY + (aFraction * (hiFuncY - loFuncY));

     if(useLogs)
     {
         return returnValue = exp(returnValue);
     }
 
     return returnValue;


}


- printSelf
{
  int i;

  fprintf(stdout, "Interpolator >>>> printSelf >>>> BEGIN\n");
  fflush(0); 


  for(i = 0; i < funcArrayMax; i++)
  {
      //fprintf(stdout, "xValues[%d] = %f yValues[%d] = %f\n", i, exp(*((double *)[xValues atOffset: i])), i, exp(*((double *) [yValues atOffset: i])));
      fprintf(stdout, "xValues[%d] = %f yValues[%d] = %f\n", i, *((double *)[xValues atOffset: i]), i, *((double *) [yValues atOffset: i]));
      fflush(0); 
  }

  fprintf(stdout, "Interpolator >>>> printSelf >>>> END\n");
  fflush(0); 

  return self;
}

- (void) drop
{
  if(xValues != nil)
  {
      int i;
      for(i = 0; i < funcArrayMax; i++)
      {
           //[interpolationZone free: [xValues atOffset: i]];
      }
  }

  if(yValues != nil)
  {
      int i;
      for(i = 0; i < funcArrayMax; i++)
      {
          //[interpolationZone free: [yValues atOffset: i]];
      }
  }

  if(interpolationZone != nil)
  {
     [interpolationZone drop];
  }
  interpolationZone = nil;

   [super drop];
}
    
@end

