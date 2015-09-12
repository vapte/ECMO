#pragma rtGlobals=1		// Use modern global access method.


Window ecmonew() : Panel
	PauseUpdate; Silent 1		// building window...
	NewPanel /W=(170,84,1271,720)
	SetDrawLayer UserBack
	SetDrawEnv linethick= 10,linefgc= (29524,1,58982),arrow= 1,arrowfat= 3
	DrawLine 470,498,597,394
	SetDrawEnv linethick= 10,linefgc= (65535,0,0),arrow= 1,arrowfat= 3
	DrawLine 759,304,992,304
	SetDrawEnv linethick= 10,linefgc= (65535,0,0),arrow= 1,arrowfat= 3
	DrawLine 596,302,447,301
	SetDrawEnv fsize= 18
	DrawText 63,471,"V"
	SetDrawEnv fsize= 18
	DrawText 178,472,"A"
	DrawText 104,476,"output"
	SetDrawEnv textrot= 90
	DrawText 214,451,"sweep"
	Slider sliderVentBase,pos={228,403},size={53,167},proc=SliderProcVentbase
	Slider sliderVentBase,limits={0,5,0.5},variable= ventBase,thumbColor= (65535,65533,32768)
	GroupBox groupApex,pos={36,25},size={246,133},title="Ventilator"
	GroupBox groupApex,font="Comic Sans MS",fSize=14,frame=0
	GroupBox groupBase,pos={36,374},size={246,220},title="ECMO",font="Comic Sans MS"
	GroupBox groupBase,fSize=12,frame=0
	SetVariable setvarFIO2,pos={70,62},size={111,19},proc=SetVarProcFIO2,title="FIO2"
	SetVariable setvarFIO2,font="Comic Sans MS",fSize=12
	SetVariable setvarFIO2,limits={0.01,1,0.01},value= FIO2
	SetVariable setvarMVO2,pos={626,545},size={88,19},proc=SetVarProcSVO2,title="MVO2"
	SetVariable setvarMVO2,font="Comic Sans MS",fSize=12
	SetVariable setvarMVO2,limits={100,500,10},value= mvo2,live= 1
	SetVariable setvarHb,pos={184,264},size={71,19},proc=SetVarProcHb,title="Hb"
	SetVariable setvarHb,font="Comic Sans MS",fSize=12,limits={0,20,1},value= Hb
	GroupBox groupApex1,pos={601,18},size={151,107},title="Lung"
	GroupBox groupApex1,font="Comic Sans MS",fSize=18
	GroupBox groupMiddle1,pos={501,128},size={109,20},title="Shunt"
	GroupBox groupMiddle1,font="Comic Sans MS",fSize=12
	GroupBox groupBase1,pos={603,251},size={151,176},title="ECMO"
	GroupBox groupBase1,font="Comic Sans MS",fSize=18
	ValDisplay valdispSatBase,pos={644,375},size={62,17},title="Sat"
	ValDisplay valdispSatBase,font="Comic Sans MS",fSize=12,format="%.0f"
	ValDisplay valdispSatBase,limits={0,0,0},barmisc={0,1000},value= #"GVECMOSAT"
	ValDisplay valdispLungSAT,pos={643,87},size={58,17},title="Sat"
	ValDisplay valdispLungSAT,font="Comic Sans MS",fSize=12,format="%.0f"
	ValDisplay valdispLungSAT,limits={0,0,0},barmisc={0,1000},value= #"GVLUNGSAT"
	GroupBox groupPulmVein,pos={888,1},size={163,184},title="Pulm Vein"
	GroupBox groupPulmVein,labelBack=(62759,0,1120),font="Comic Sans MS",fSize=16
	ValDisplay valdispAo1Sat,pos={940,111},size={68,24},title="Sat"
	ValDisplay valdispAo1Sat,font="Comic Sans MS",fSize=16,format="%0.f"
	ValDisplay valdispAo1Sat,limits={0,0,0},barmisc={0,1000},value= #"GVAo1SAT"
	SetVariable setvarECMOFIO2,pos={66,552},size={123,19},proc=SetVarProcFIO2,title="ECMO FIO2"
	SetVariable setvarECMOFIO2,font="Comic Sans MS",fSize=12
	SetVariable setvarECMOFIO2,limits={0.01,1,0.01},value= ECMOFIO2
	GroupBox groupSystemArt,pos={888,396},size={167,188},title="Systemic"
	GroupBox groupSystemArt,labelBack=(62759,0,1120),font="Comic Sans MS",fSize=16
	ValDisplay valdispSystemicSat,pos={927,512},size={96,34},title="Sat"
	ValDisplay valdispSystemicSat,font="Comic Sans MS",fSize=24,format="%0.f"
	ValDisplay valdispSystemicSat,limits={0,0,0},barmisc={0,1000},value= #"GVAo2SAT"
	ValDisplay valdisptotalflow,pos={605,582},size={137,25},title="Total Flow"
	ValDisplay valdisptotalflow,fSize=18,format="%.1f"
	ValDisplay valdisptotalflow,limits={0,0,0},barmisc={0,1000},value= #"totalflow"
	ValDisplay valdispCalcSVO4,pos={1594,264},size={96,13},title="PA sat"
	ValDisplay valdispCalcSVO4,format="%0.f",limits={0,0,0},barmisc={0,1000}
	ValDisplay valdispCalcSVO4,value= #"PAsat"
	GroupBox groupSystemVenous,pos={303,394},size={167,188},title="Venous"
	GroupBox groupSystemVenous,labelBack=(42509,0,11245),font="Comic Sans MS"
	GroupBox groupSystemVenous,fSize=16
	ValDisplay valdispSVO2,pos={329,484},size={124,33},title="SVO2",fSize=24
	ValDisplay valdispSVO2,format="%.0f",limits={0,0,0},barmisc={0,1000}
	ValDisplay valdispSVO2,value= #"GVSV1Sat"
	GroupBox groupPulmArt,pos={304,2},size={164,184},title="Pulm Artery"
	GroupBox groupPulmArt,labelBack=(42509,0,11245),font="Comic Sans MS",fSize=16
	ValDisplay valdispCalcSVO2,pos={347,106},size={96,25},title="PA sat",fSize=18
	ValDisplay valdispCalcSVO2,format="%0.f",limits={0,0,0},barmisc={0,1000}
	ValDisplay valdispCalcSVO2,value= #"GVSV2SAT"
	SetVariable setvarMinuteVent,pos={72,101},size={161,19},proc=SetVarProcFIO2,title="Ventilation (L/min)"
	SetVariable setvarMinuteVent,font="Comic Sans MS",fSize=12
	SetVariable setvarMinuteVent,limits={1,10,0.5},value= ventApex
	GroupBox groupPatient,pos={34,178},size={248,169},title="Patient"
	GroupBox groupPatient,font="Comic Sans MS",fSize=14,frame=0
	SetVariable setvarCO,pos={94,208},size={161,19},proc=SetVarProcFIO2,title="Cardiac Output"
	SetVariable setvarCO,font="Comic Sans MS",fSize=12
	SetVariable setvarCO,limits={1,10,0.5},value= heartflow
	SetVariable setvarMVO3,pos={167,236},size={88,19},proc=SetVarProcSVO2,title="MVO2"
	SetVariable setvarMVO3,font="Comic Sans MS",fSize=12
	SetVariable setvarMVO3,limits={100,500,10},value= mvo2,live= 1
	SetVariable setvarSF,pos={76,321},size={179,19},proc=SetVarProcSVO2,title="Lung Shunt Fraction"
	SetVariable setvarSF,font="Comic Sans MS",fSize=12
	SetVariable setvarSF,limits={0,1,0.05},value= SF,live= 1
	Slider sliderAVblendECMO,pos={80,454},size={89,13},proc=SliderProc
	Slider sliderAVblendECMO,limits={100,0,10},variable= PercentVforblendedECMO,side= 0,vert= 0
	SetVariable setvarECMOFLOW,pos={71,410},size={109,19},proc=SetVarProcFIO2,title="Flow"
	SetVariable setvarECMOFLOW,font="Comic Sans MS",fSize=12
	SetVariable setvarECMOFLOW,limits={0,5,0.5},value= BloodBase
	ValDisplay valdisVV,pos={497,277},size={71,17},title="V Flow"
	ValDisplay valdisVV,font="Comic Sans MS",fSize=12,format="%.1f"
	ValDisplay valdisVV,limits={0,0,0},barmisc={0,1000},value= #"VVECMOflow"
	ValDisplay valdisVA,pos={829,277},size={72,17},title="A Flow"
	ValDisplay valdisVA,font="Comic Sans MS",fSize=12,format="%.1f"
	ValDisplay valdisVA,limits={0,0,0},barmisc={0,1000},value= #"VAECMOflow"
	GroupBox groupLowerIVC,pos={411,307},size={34,108},title="\\Z06"
	GroupBox groupLowerIVC,labelBack=(42509,0,11245),font="Comic Sans MS",fSize=5
	GroupBox groupLowerIVC,frame=0
	GroupBox groupUpperIVC,pos={408,188},size={34,108},labelBack=(65238,0,0)
	GroupBox groupUpperIVC,font="Comic Sans MS",fSize=16,frame=0
	GroupBox groupAorticArch,pos={996,188},size={34,117},labelBack=(62759,0,1120)
	GroupBox groupAorticArch,font="Comic Sans MS",fSize=16,frame=0
	GroupBox groupUpperIVC3,pos={1231,171},size={34,108},labelBack=(65238,0,0)
	GroupBox groupUpperIVC3,font="Comic Sans MS",fSize=16,frame=0
	GroupBox groupFemoralA,pos={996,309},size={34,108},labelBack=(62759,0,1120)
	GroupBox groupFemoralA,font="Comic Sans MS",fSize=16,frame=0
	GroupBox groupShunt,pos={473,150},size={411,16},labelBack=(42509,0,11245)
	GroupBox groupShunt,font="Comic Sans MS",fSize=16,frame=0
	GroupBox groupLungA,pos={471,62},size={129,32},labelBack=(42509,0,11245)
	GroupBox groupLungA,font="Comic Sans MS",fSize=16,frame=0
	GroupBox groupLungV,pos={757,65},size={128,30},labelBack=(62759,0,1120)
	GroupBox groupLungV,font="Comic Sans MS",fSize=16,frame=0
	GroupBox groupSysV,pos={472,535},size={125,31},labelBack=(42509,0,11245)
	GroupBox groupSysV,font="Comic Sans MS",fSize=16,frame=0
	GroupBox groupSysA,pos={749,534},size={137,33},labelBack=(62759,0,1120)
	GroupBox groupSysA,font="Comic Sans MS",fSize=16,frame=0
	GroupBox groupPerfusion,pos={600,492},size={149,122},title="Perfusion"
	GroupBox groupPerfusion,font="Comic Sans MS",fSize=18
	GroupBox groupUpperIVC2,pos={411,191},size={34,108},labelBack=(42509,0,11245)
	GroupBox groupUpperIVC2,font="Comic Sans MS",fSize=16,frame=0
	ValDisplay valdispECMOCO2flux,pos={623,398},size={107,14},title="CO2 elimination"
	ValDisplay valdispECMOCO2flux,font="Comic Sans MS",fSize=9,format="%.0f"
	ValDisplay valdispECMOCO2flux,limits={0,0,0},barmisc={0,1000}
	ValDisplay valdispECMOCO2flux,value= #"ECMOCO2flux"
	ValDisplay valdispLUNGCO2flux,pos={625,106},size={107,14},title="CO2 elimination"
	ValDisplay valdispLUNGCO2flux,font="Comic Sans MS",fSize=9,format="%.0f"
	ValDisplay valdispLUNGCO2flux,limits={0,0,0},barmisc={0,1000}
	ValDisplay valdispLUNGCO2flux,value= #"LUNGCO2flux"
	ValDisplay valdispAo2pH,pos={903,464},size={47,22},fSize=16,format="%.2f"
	ValDisplay valdispAo2pH,limits={0,0,0},barmisc={0,1000},mode= 2
	ValDisplay valdispAo2pH,value= #"GVAo2ph"
	ValDisplay valdispAo2pCO2,pos={959,463},size={34,22},fSize=16,format="%.0f"
	ValDisplay valdispAo2pCO2,limits={0,0,0},barmisc={0,1000},mode= 2
	ValDisplay valdispAo2pCO2,value= #"GVao2pCO2"
	ValDisplay valdispAo2pO2,pos={1000,463},size={44,22},fSize=16,format="%.0f"
	ValDisplay valdispAo2pO2,limits={0,0,0},barmisc={0,1000},mode= 2
	ValDisplay valdispAo2pO2,value= #"GVAo2PO2"
	ValDisplay valdispSV2pH,pos={316,36},size={47,22},fSize=16,format="%.2f"
	ValDisplay valdispSV2pH,limits={0,0,0},barmisc={0,1000},mode= 2
	ValDisplay valdispSV2pH,value= #"GVSV2ph"
	ValDisplay valdispSV2pCO2,pos={370,35},size={34,22},fSize=16,format="%.0f"
	ValDisplay valdispSV2pCO2,limits={0,0,0},barmisc={0,1000},mode= 2
	ValDisplay valdispSV2pCO2,value= #"GVSV2pCO2"
	ValDisplay valdispSV2pO2,pos={411,35},size={44,22},fSize=16,format="%.0f"
	ValDisplay valdispSV2pO2,limits={0,0,0},barmisc={0,1000},mode= 2
	ValDisplay valdispSV2pO2,value= #"GVSV2pO2"
	ValDisplay valdispAo1pH,pos={901,48},size={47,22},fSize=16,format="%.2f"
	ValDisplay valdispAo1pH,limits={0,0,0},barmisc={0,1000},mode= 2
	ValDisplay valdispAo1pH,value= #"GVAo1ph"
	ValDisplay valdispAo1pCO2,pos={957,47},size={34,22},fSize=16,format="%.0f"
	ValDisplay valdispAo1pCO2,limits={0,0,0},barmisc={0,1000},mode= 2
	ValDisplay valdispAo1pCO2,value= #"GVao1pCO2"
	ValDisplay valdispAo1pO2,pos={998,47},size={44,22},fSize=16,format="%.0f"
	ValDisplay valdispAo1pO2,limits={0,0,0},barmisc={0,1000},mode= 2
	ValDisplay valdispAo1pO2,value= #"GVAo1PO2"
	ValDisplay valdispSV1pCO2,pos={371,428},size={34,22},fSize=16,format="%.0f"
	ValDisplay valdispSV1pCO2,limits={0,0,0},barmisc={0,1000},mode= 2
	ValDisplay valdispSV1pCO2,value= #"GVSV1pCO2"
	ValDisplay valdispSV1pH,pos={317,429},size={47,22},fSize=16,format="%.2f"
	ValDisplay valdispSV1pH,limits={0,0,0},barmisc={0,1000},mode= 2
	ValDisplay valdispSV1pH,value= #"GVSV1ph"
	ValDisplay valdispSV1pO2,pos={412,428},size={44,22},fSize=16,format="%.0f"
	ValDisplay valdispSV1pO2,limits={0,0,0},barmisc={0,1000},mode= 2
	ValDisplay valdispSV1pO2,value= #"GVSV1pO2"
	ValDisplay valdispLungpH,pos={606,50},size={47,22},fSize=16,format="%.2f"
	ValDisplay valdispLungpH,limits={0,0,0},barmisc={0,1000},mode= 2
	ValDisplay valdispLungpH,value= #"GVLungph"
	ValDisplay valdispLUNGpCO2,pos={660,50},size={34,22},fSize=16,format="%.0f"
	ValDisplay valdispLUNGpCO2,limits={0,0,0},barmisc={0,1000},mode= 2
	ValDisplay valdispLUNGpCO2,value= #"GVLUNGpCO2"
	ValDisplay valdispLUNGpO2,pos={704,49},size={44,22},fSize=16,format="%.0f"
	ValDisplay valdispLUNGpO2,limits={0,0,0},barmisc={0,1000},mode= 2
	ValDisplay valdispLUNGpO2,value= #"GVLUNGpO2"
	ValDisplay valdispECMOpH,pos={609,294},size={47,22},fSize=16,format="%.2f"
	ValDisplay valdispECMOpH,limits={0,0,0},barmisc={0,1000},mode= 2
	ValDisplay valdispECMOpH,value= #"GVECMOph"
	ValDisplay valdispECMOpCO2,pos={663,294},size={34,22},fSize=16,format="%.0f"
	ValDisplay valdispECMOpCO2,limits={0,0,0},barmisc={0,1000},mode= 2
	ValDisplay valdispECMOpCO2,value= #"GVECMOpCO2"
	ValDisplay valdispECMOpO2,pos={707,293},size={44,22},fSize=16,format="%.0f"
	ValDisplay valdispECMOpO2,limits={0,0,0},barmisc={0,1000},mode= 2
	ValDisplay valdispECMOpO2,value= #"GVECMOpO2"
	SetVariable setvarDLCO,pos={167,292},size={88,19},title="DLCO"
	SetVariable setvarDLCO,font="Comic Sans MS",fSize=12
	SetVariable setvarDLCO,limits={100,500,10},value= GVDLCO,live= 1
EndMacro
