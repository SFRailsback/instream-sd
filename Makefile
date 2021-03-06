ifeq ($(SWARMHOME),)
SWARMHOME=/usr/local/etc
endif


APPLICATION=instreamSD2D
OBJECTS=GraphDataObject.o \
	FishParams.o \
	SearchElement.o ScenarioIterator.o  ExperSwarm.o \
	main.o \
\
	TimeManager.o \
\
	ExperBatchSwarm.o \
	UTMTroutBatchSwarm.o \
\
	ZoneAllocMapper.o \
\
	SurvProb.o \
	SingleFuncProb.o \
	LimitingFunctionProb.o \
\
	SurvMGR.o \
	Func.o \
	LogisticFunc.o \
	ConstantFunc.o \
	BooleanSwitchFunc.o \
\
	ReddSuperImpSP.o \
	ReddSuperImpFunc.o \
\
	ReddScourSP.o \
	ReddScourFunc.o \
\
	AnglePressureFunc.o \
	ReachLengthFunc.o \
	Angling.o \
	TroutFunc.o \
\
	Hooking.o \
\
	BreakoutReporter.o \
	EcoAverager.o \
	BreakoutAverager.o \
	BreakoutVarProbe.o \
	BreakoutMessageProbe.o \
\
	UTMTroutObserverSwarm.o \
	UTMTroutModelSwarm.o \
	HabitatSpace.o \
	UTMInputData.o \
	UTMCell.o \
	FishCell.o \
	UTMTrout.o \
	Rainbow.o \
	Brown.o \
	UTMRedd.o \
	UTMInterpolatorFactory.o \
	InterpolationTable.o \
	TimeSeriesInputManager.o


OTHERCLEAN= trout.exe.core trout.exe unhappiness.output

include $(SWARMHOME)/etc/swarm/Makefile.appl


main.o: main.m 
FishParams.o: FishParams.[hm] 
GraphDataObject.o : GraphDataObject.[hm]
SearchElement.o: SearchElement.[hm]
ScenarioIterator.o: ScenarioIterator.[hm] SearchElement.h
ExperSwarm.o: ExperSwarm.[hm] SearchElement.h ScenarioIterator.h globals.h
#
TimeManager.o : TimeManager.[hm]
#
ExperBatchSwarm.o : ExperBatchSwarm.[hm]
UTMTroutBatchSwarm.o : UTMTroutBatchSwarm.[hm]
#
ZoneAllocMapper.o : ZoneAllocMapper.[hm]
#
SurvProb.o : SurvProb.[hm]
SingleFuncProb.o : SingleFuncProb.[hm]
MultiFunctionMax.o : MultiFunctionMax.[hm]
SurvMGR.o : SurvMGR.[hm]
#
Func.o : Func.[hm]
LogisticFunc.o : LogisticFunc.[hm]
ConstantFunc.o : ConstantFunc.[hm]
BooleanSwitchFunc.o : BooleanSwitchFunc.[hm]
#
ReddSuperImpSP.o : ReddSuperImpSP.[hm] SurvProb.h
ReddSuperImpFunc.o : ReddSuperImpFunc.[hm] Func.h
#
ReddScourSP.o : ReddScourSP.[hm] SurvProb.h
ReddScourFunc.o : ReddScourFunc.[hm] Func.h
#
Angling.o : Angling.[hm] SurvProb.h
AnglePressureFunc.o : AnglePressureFunc.[hm] Func.h
ReachLengthFunc.o : ReachLengthFunc.[hm] Func.h
TroutFunc.o : TroutFunc.[hm] Func.h
#
Hooking.o : Hooking.[hm] SurvProb.h
#
BreakoutReporter.o : BreakoutReporter.[hm]
EcoAverager.o : BreakoutAverager.[hm]
BreakoutAverager.o : BreakoutAverager.[hm]
BreakoutVarProbe.o : BreakoutVarProbe.[hm]
BreakoutMessageProbe.o : BreakoutMessageProbe.[hm]
#
UTMInputData.o : UTMInputData.[hm]
UTMCell.o : UTMCell.[hm]
FishCell.o : FishCell.[hm]
UTMTrout.o : UTMTrout.[hm]
Rainbow.o : Rainbow.[hm]
Brown.o : Brown.[hm]
UTMRedd.o : UTMRedd.[hm]
UTMInterpolatorFactory.o : UTMInterpolatorFactory.[hm]
InterpolationTable.o : InterpolationTable.[hm]
TimeSeriesInputManager.o : TimeSeriesInputManager.[hm]
#
UTMTroutObserverSwarm.o  : UTMTroutObserverSwarm.[hm]
UTMTroutModelSwarm.o : UTMTroutModelSwarm.[hm]
HabitatSpace.o : HabitatSpace.[hm]
