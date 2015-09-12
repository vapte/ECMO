#pragma rtGlobals=1		// Use modern global access method.


//global variables to hold co2 pressure (pco2), content (cco2), ph, po2, o2sat, bicarb, in each volume compartment
//compartments are:  SV1,SV2, Lung, Ao1, Ao2, ECMO

//GVSV1pCO2,GVSV2pCO2, GVLungpCO2, GVAo1pCO2, GVAo2pCO2, GVECMOpCO2
//GVSV1cCO2,GVSV2cCO2, GVLungcCO2, GVAo1cCO2, GVAo2cCO2, GVECMOcCO2
//GVSV1pH,GVSV2pH, GVLungpH, GVAo1pH, GVAo2pH, GVECMOpH
//GVSV1pO2,GVSV2pO2, GVLungpO2, GVAo1pO2, GVAo2pO2, GVECMOpO2
//GVSV1SAT,GVSV2SAT, GVLungSAT, GVAo1SAT, GVAo2SAT, GVECMOSAT
//GVSV1bicarb,GVSV2bicarb, GVLungbicarb, GVAo1bicarb, GVAo2bicarb, GVECMObicarb

//Other Global Variables:  GVHb, GVBE, GVTemp
Function FIndHCO3plEq2NEW(cCO2pl, pCO2pl)			//eq 2
	variable cCO2pl, pCO2pl
	variable s=calcSnew(37)

	return ((cCO2pl - (pCO2pl*s))	/2.226)			//added 2.226 factor to convert from mmol to ml!!!
End

Function CorrectBicarbNEW(origbicarb, origCCO2, changeCCO2)		//based on mass action, acute change in bicarb estimated at 1 for each 10 mmHg increase in PCO2 over 40, and -2 for each reduction of 10 from 40
	variable origbicarb, origCCO2, changeCCO2
	
	variable ratio= (changeCCO2)/(changeCCO2+origCCO2)
	variable change=ratio*5

return (max(18,origbicarb+change))
End

Function CorrectBicarbNEW2(origbicarb,PCO2)		//based on mass action, acute change in bicarb estimated at 1 for each 10 mmHg increase in PCO2 over 40, and -2 for each reduction of 10 from 40
	variable origbicarb ,PCO2
	nvar GVpCO2=GVpCO2
	
	variable ratio= (GVpCO2-pCO2)/(pCO2)
	variable change=ratio*5

return (max(18,origbicarb-change))
End

Function ReturnBicarbNEW(PCO2,ph)					//from equation 8
	variable pco2,ph
	
	variable chco3=0.0307*pco2*10^(ph-6.09)
return chco3
end

Function ReturnPHNEW(PCO2,cho3)					//from equation 8
	variable pco2,cho3
	
	return (Log(cho3/(0.0307*pco2))+6.09)
end



Function FindBEnew(CHO3,Hb,pH)
	variable CHO3,Hb,pH
	
	
	variable BE= (CHO3*(1-(0.014*hb))) -24  +  ((9.5+1.63*hb)*(ph-7.4))
return BE
End

Function FindpHnew(BE,CHO3,Hb)
	variable BE,CHO3,Hb
	variable pH=( (BE-(CHO3*(1-(0.014*hb))) + 24  )/ ((9.5+1.63*hb) ) + 7.4
return pH

end


Function CalcPKnew(ph,t)
	variable ph,t
	
	variable pk
	
	pk=6.086
	pk+=0.042*(7.4-ph)
	pk+=(38-t)*( 0.00472 + (0.00139*(7.4-ph)) ) 
	
	return (pk)
end

Function CalcSnew(t)					//this s  is in mM per torr!
	variable t 
	
	return (0.0307 + (0.00057*(37-t)) + (0.00002*((37-t)^2))  )
End


Function FindCpNew(s,pco2,ph,pk)
	variable s,pco2,ph,pk

	variable phdiff=ph-pk
	
	variable CCO2pl=2.226*pco2* s * (1 + 10^phdiff)				//this 2.226 converts from mM to ml

	return (CCO2pl)
End

Function FindCbNEW(pco2,temp,ph,Hb,So2)   // this is in mM!!!
	variable pco2,temp,ph,Hb,So2
	
	variable pk=calcpknew(ph,temp)
	variable s=calcSnew(temp)
	variable Cp= FindCpNew(s,pco2,ph,pk)

		
	
	variable ratio=(0.0289*hb)/( (3.352 - 0.456*So2)*(8.142-ph) )   

	variable part2=(1 - ratio)
	
	return (Cp*part2)
end
	
		
Function FindPCO2New(Cb,temp,ph,Hb,So2)   			//eq 5 and 6, rearranged
	variable Cb,temp,ph,Hb,So2
	
	variable pk=calcpknew(ph,temp)
	variable phdiff=ph-pk
	variable s=calcSnew(temp)
	
	variable ratio=(0.0289*hb)/( (3.352 - 0.456*So2)*(8.142-ph) ) 
	
	variable pCO2= Cb/(2.226* s * (1 + 10^phdiff)) 
				pCO2/=  (1-ratio)
	
	return (pCO2)
end



Function InitializeCO2new(pH,pCO2,sat)					//start of sim, will put in systemic arterial blood gas, calculate bicarb. 
	variable pH, pCO2,sat
	wave w=W_data
	
	if (sat<2)
		print "Sat should be between 10 and 100"
	endif
	
	nvar GVAo2ph=GVAo2ph; GVAo2ph=pH
	nvar GVAo2pCO2=GVAo2pCO2; GVAo2pCO2=pCO2
	nvar  GVAo2SAT= GVAo2SAT;  GVAo2SAT=sat
	nvar GVpCO2=GVpCO2; GVpCO2=pCO2
	
	nvar GVAo2bicarb=GVAo2bicarb, GVbicarb=GVbicarb, GVhb=GVhb, GVtemp=GVTemp
	
	GVAo2bicarb= ReturnBicarbNEW(pco2,ph)
	GVbicarb=GVAO2bicarb
	nvar GVSV1bicarb=GVSV1bicarb;GVSV1bicarb=GVbicarb
	nvar GVSV2bicarb=GVSV2bicarb;GVSV2bicarb=GVbicarb
	nvar GVLUNGbicarb=GVLUNGbicarb;GVLUNGbicarb=GVbicarb
	nvar GVAo1bicarb=GVAo1bicarb;GVAo1bicarb=GVbicarb
	nvar GVECMObicarb=GVECMObicarb;GVECMObicarb=GVbicarb
	
	
	nvar GVBE=GVBE,GVTtemp=GVTemp,GVHb=GVhb
		GVBE=FindBE( GVAo2bicarb,GVHb,ph)
	
	nvar GVAo2BE=GVAo2BE;GVAo2BE=GVBE
	nvar GVSV1BE=GVSV1BE;GVSV1BE=GVBE
	nvar GVSV2BE=GVSV2BE;GVSV2BE=GVBE
	nvar GVLUNGBE=GVLUNGBE;GVLUNGBE=GVBE
	nvar GVAo1BE=GVAo1BE;GVAo1BE=GVBE
	nvar GVECMOBE=GVECMOBE;GVECMOBE=GVBE
	
	
		
	nvar GVAo2cCO2=GVAo2cCO2
		GVAo2cCO2= FindCbNEW(GVAo2pCO2,GVtemp,ph,GVHb,sat/100)   
		
	print GVAo2pCO2,GVtemp,ph,GVHb,sat,GVAo2bicarb
	
	
End


//now we've got the values for the systemic arterial blood initialized


//Function ChangeCO2Content(pCO2orig,pHorig,cCO2orig,So2orig,SO2new,co2change,bicarb,dl)	
//	variable pCO2orig,pHorig,cCO2orig,So2orig,SO2new,co2change,bicarb,dl
	

Function ChangeCO2Content(pCO2orig,cCO2orig,SO2new,co2change,HCO3,baseE,dl)	
	variable pCO2orig,cCO2orig,SO2new,co2change,hco3,baseE,dl
											
	co2change/=dl									//content is ml per dl

	nvar cCO2=	cCO2
		cCO2=cCO2orig+(co2change)			//add +co2 or subtract -co2 to the circulation
	
	make/o/n=200 w_pco21,w_pco22
		SetScale/I x 6,8,"", w_pco21,w_pco22
		
	nvar GVtemp=GVtemp, GVhb=GVhb
		w_pco21=FindPCO2new(cCO2,GVtemp,x,GVHb,SO2new)
		//	print cCO2,GVtemp,"ph",GVHb,SO2new

	
	nvar BE= BE, pH=pH,bicarb=bicarb,pCO2=pCO2,GVpCO2=GVpCO2
			
		//pH= returnPHNew(pCO2orig,bicarb)
		//pH= returnPHNew(pCO2orig,hco3)


		//BE=FindBEnew(bicarb,GVHb,pH)
		//print FindBEnew(bicarb,GVHb,pH)
		
		//w_pco22=eq7and8(FindBEnew(hco3,GVHb,x),GVHb,x)

w_pco22=eq7and8(BaseE,GVHb,x)
		//w_pco22=HHequationfindpCO2( bicarb,x)
		//w_pco22=HHequationfindpCO2( hco3,x)

		pH=FindCrossing(w_pco21,w_pco22)
		pCO2=w_pco21(ph)

	bicarb=correctbicarbNEW2(hco3,pCO2)

	pH=HHequationFindpH(bicarb,pCO2)
	return (pco2)								
											
End


Function ChangeCO2ContentCOMBINE(pCO2a,cCO2a,Vola,hco3a,cCO2b,Volb,FinalSAT)
	variable pCO2a,cCO2a,Vola,hco3a,cCO2b,Volb,FinalSAT

	variable TotalVol=VOLa+VOLb
	
	nvar cCO2=	cCO2
		cCO2=((cCO2a*VOLa)+(cCO2b*VOLb))	/TotalVol		
	
	make/o/n=200 w_pco21,w_pco22
		SetScale/I x 6,8,"", w_pco21,w_pco22
		
	nvar GVtemp=GVtemp, GVhb=GVhb
		w_pco21=FindPCO2new(cCO2,GVtemp,x,GVHb,FinalSAT)
				//print cCO2,GVtemp,"ph",GVHb,FinalSAT

	
	nvar GVBE= GVBE, pH=pH,bicarb=bicarb,pCO2=pCO2
	//	bicarb=correctbicarbNEW(hco3a,cCO2a,(cCO2-cCO2a))
			
		//pH= returnPHNew(pCO2orig,bicarb)
		//pH= returnPHNew(pCO2a,hco3a)


		//BE=FindBEnew(bicarb,GVHb,pH)
		
	//	w_pco22=HHequationfindpCO2( bicarb,x)

		w_pco22=eq7and8(GVBE,GVHb,x)
	
		pH=FindCrossing(w_pco21,w_pco22)
		pCO2=w_pco21(ph)
		
	bicarb=correctbicarbNEW2(hco3a,pCO2)
		pH=HHequationFindpH(bicarb,pCO2)

	
	//GVBE=FindBEnew(bicarb,GVHb,pH)
	
	return (pco2)								
											
End


//*************				These two curves are required to determine matching of pCO2 across lungs or ECMO. 
Function MakeCO2GasCurveNEW(flow)
	variable flow
	make/o/n=(flow*1000) CO2GasCurve
	CO2GasCurve=760*p/(flow*1000)
End


Function MakeCO2BloodCurveNEW(pCO2in,cCO2in,SATin,SATout,hco3,be,flow)
	variable pCO2in,cCO2in,SATin,SATout,hco3,be,flow
	
	
	variable TotalCO2in=round(cCO2in*flow*10)						//the oxygenator will always remove co2, so the curve goes from 0 co2 to starting content (plus 10 for good luck!)
	variable vpCO2,  vTCO2=0, vdeltaCO2=-TotalCO2in

		make/o/n=(TotalCO2in) CO2bloodcurve
			do
				
				vpCO2=ChangeCO2Content(pCO2in,cCO2in,SATout,vdeltaCO2,hco3,be,(flow*10))	
				CO2bloodCurve[vTCO2]=vpCO2
				vdeltaCO2+=1; vTCO2+=1
			while (	vTCO2<numpnts(CO2bloodCurve))
	End		
	
	
	
	
Function FindEquilibriumPCO2fluxNEW(bloodcurve,gascurve,CO2contentIN)
	wave bloodcurve,gascurve; variable CO2ContentIN
	
	variable CO2flux=0, PCO2blood, PCO2gas
		do
			PCO2blood=bloodcurve[CO2contentIN-CO2flux]
			PCO2gas=gascurve[CO2flux]
		CO2flux+=1
		while (PCO2blood>PCO2gas)
		
		nvar PCO2=PCO2
		pCO2=pCO2blood
		//print Pco2blood,pco2gas
	return (CO2flux)
End


//***  this function is required to mix effluent from shunt, or from ecmo to see impact when the volumes combine

Function CombineBloodNEW(CO2conc1,Vol1,bicarb1,BE1,CO2Conc2,Vol2, bicarb2,BE2,temp,Hb,FinalSat)
	variable CO2conc1,Vol1,bicarb1,BE1,CO2Conc2,Vol2, bicarb2,BE2,temp,Hb,FinalSat
	
	variable TotalCO2content=(CO2conc1*Vol1)+(CO2conc2*Vol2)
	variable totalvol=vol1+vol2
	variable FinalcCO2=TotalCO2content/totalvol
	variable FinalBicarb=((bicarb1*vol1)+(bicarb2*vol2))/totalvol
	variable FinalBE=((BE1*vol1)+(BE2*vol2))/totalvol
		
		
	nvar pH=pH,pCO2=pCO2, BE=BE, bicarb=bicarb, cCO2=cCO2
		
		pH=FindpHnew(finalBE,finalbicarb,hb)
		//print finalBE,finalbicarb,hb
		pCO2= FindPCO2New(FinalcCO2,temp,pH,Hb,FinalSat)   
		//print FinalcCO2,temp,pH,Hb,FinalSat
			
		cCO2=FinalcCO2
		bicarb=finalbicarb
		BE=FinalBE
	
	return (pco2)
		
	End	


Function UpdateCO2NEW()

NVAR GVSV1pCO2= GVSV1pCO2,GVSV2pCO2= GVSV2pCO2, GVLungpCO2= GVLungpCO2, GVAo1pCO2=GVAo1pCO2, GVAo2pCO2=GVAo2pCO2, GVECMOpCO2=GVECMOpCO2
NVAR GVSV1cCO2=GVSV1cCO2,GVSV2cCO2=GVSV2cCO2, GVLungcCO2=GVLungcCO2, GVAo1cCO2=GVAo1cCO2, GVAo2cCO2=GVAo2cCO2, GVECMOcCO2=GVECMOcCO2
NVAR GVSV1pH=GVSV1pH,GVSV2pH=GVSV2pH, GVLungpH=GVLungpH, GVAo1pH=GVAo1pH, GVAo2pH=GVAo2pH, GVECMOpH=GVECMOpH
NVAR GVSV1pO2=GVSV1pO2,GVSV2pO2=GVSV2pO2, GVLungpO2=GVLungpO2, GVAo1pO2=GVAo1pO2, GVAo2pO2=GVAo2pO2, GVECMOpO2=GVECMOpO2
NVAR GVSV1SAT=GVSV1SAT,GVSV2SAT=GVSV2SAT, GVLungSAT=GVLungSAT, GVAo1SAT=GVAo1SAT, GVAo2SAT=GVAo2SAT, GVECMOSAT=GVECMOSAT
NVAR GVSV1bicarb=GVSV1bicarb,GVSV2bicarb=GVSV2bicarb, GVLungbicarb=GVLungbicarb, GVAo1bicarb=GVAo1bicarb, GVAo2bicarb=GVAo2bicarb, GVECMObicarb=GVECMObicarb
NVAR GVSV1BE=GVSV1BE,GVSV2BE=GVSV2BE, GVLungBE=GVLungBE, GVAo1BE=GVAo1BE, GVAo2BE=GVAo2BE, GVECMOBE=GVECMOBE
NVAR GVSV1vol= GVSV1vol,GVSV2vol= GVSV2vol, GVLungvol= GVLungvol, GVAo1vol=GVAo1vol, GVAo2vol=GVAo2vol
NVAR GVHb=GVhb, GVBE=GVBE, GVTemp=GVTemp, mvo2=mvo2, totalflow=totalflow,bloodbase=bloodbase,VentBase=VentBase, PASat=PASat, VentApex=VentApex, BloodApex=BloodApex, BloodMiddle=BloodMiddle
NVAR pH=pH, pCO2=pCO2, cCO2=cCO2, bicarb=bicarb, BE=BE
NVAR EcmoCO2Flux=EcmoCO2Flux, LungCO2Flux=LungCO2Flux, PercentVforBlendedECMO=PercentVforBlendedECMO
	//start the loop with the arterial blood gas and bicarb known, then add CO2 based on metabolic rate	
		
		//print GVAo2pCO2,GVAo2cCO2,GVAo2SAT,GVSV1SAT,mvo2,GVAo2bicarb,totalflow*10
		GVSV1pCO2=ChangeCO2Content(GVAo2pCO2,GVAo2cCO2,GVSV1SAT/100,mvo2,GVAo2bicarb,GVAo2BE,totalflow*10)
		GVSV1cCO2 = cCO2
		GVSV1pH=pH
		//GVSV1bicarb=bicarb
		GVSV1BE=GVBE
		
		GVSV2pCO2=GVSV1pCO2			//GVSV2 will be the same values of GVSV1 unless there is VV ECMO flow, in which case they will be modified below 
		GVSV2cCO2 = GVSV1cCO2
		GVSV2pH=GVSV1pH
		//GVSV2bicarb=GVSV1bicarb
		GVSV2BE=GVSV1BE
				
	//print pco2,cco2,ph,bicarb,be
	
	
	
		//now look at the effect of ECMO acting on the venous blood
			
		if (bloodbase>0)
			//now calculate ECMO impact on venous blood
			variable CO2IntoECMO=GVSV1cCO2*bloodbase*10			//blood base is in liters, need to convert to dl				
			variable CO2BypassECMO=GVSV1cCO2*(totalflow-bloodbase)*10
		
			MakeCO2GasCurveNEW(ventbase)			//base represents ECMO 
			MakeCO2BloodCurveNEW(GVSV1pco2,GVSV1cCO2,GVSV1SAT/100,GVECMOSAT/100,GVSV1bicarb,GVSV1BE,bloodbase)
			
			wave CO2bloodcurve=CO2bloodcurve, CO2gascurve=CO2gascurve
			
			ECMOCO2flux=FindEquilibriumPCO2fluxNEW(CO2bloodcurve,CO2gascurve,CO2IntoECMO)			 
				
				GVECMOpCO2=ChangeCO2Content(GVSV1pCO2,GVSV1cCO2,GVECMOSAT/100,-ECMOCO2flux,GVSV1bicarb,GVSV1BE,bloodbase*10)
				GVECMOcCO2 = cCO2
				GVECMOpH=pH
				//GVECMObicarb=bicarb
				GVECMOBE=GVBE
		
				variable VVECMOblood=bloodbase*PercentVforBlendedECMO/100
				Variable VAECMOblood=bloodbase-VVECMOblood		
		
		//now recalculate pCO2 in SV2 based on the amount of ecmo flow that is returned to the venous system (VVECMO >0), and the addition of the CO2 contents in the ECMO effluent and in the SV

			if (VVECMOblood>0)
				if ((totalflow-bloodbase)>VVECMOblood)  //majority of flow is normal venous flow, therefore, that will be the main component which will be modified by ecmo, i.e. "a"
					ChangeCO2ContentCOMBINE(GVSV1pCO2,GVSV1cCO2,(totalflow-bloodbase)*10,GVSV1bicarb,GVECMOcCO2,VVECMOblood*10,GVSV2SAT/100)
				else
					ChangeCO2ContentCOMBINE(GVECMOpCO2,GVECMOcCO2,VVECMOblood*10,GVECMObicarb,GVSV1cCO2,(totalflow-bloodbase)*10,GVSV2SAT/100)
					
				endif
						
				GVSV2pCO2=pCO2
				GVSV2cCO2 = cCO2
				GVSV2pH=pH
				//GVSV2bicarb=bicarb
				GVSV2BE=GVBE
				
			endif
		else
			GVECMOcCO2=0			//necessary to make sure co2 content is zero if flow is zero 
		Endif
		
		//now calculate impact of VQ matched lungs on co2 elimination 
		//print "Make co2 bloodcurve" , temp,pHPA,Hb,PASAT,SatApex,bloodapex,pCO2PA,BE
			MakeCO2GasCurveNEW(ventapex)			//apex represents VQ matched lung bed
			MakeCO2BloodCurveNEW(GVSV2pCO2,GVSV2cCO2,GVSV2SAT/100,GVLungSat/100,GVSV2bicarb,GVSV2BE,bloodapex)

			wave CO2bloodcurve=CO2bloodcurve, CO2gascurve=CO2gascurve
			
			variable CO2IntoLung=GVSV2cCO2*bloodapex*10					// prorate content based on proportion of lung vs shunt flow
			variable CO2shunt=GVSV2cCO2*bloodmiddle*10
		
		

			LungCO2flux=FindEquilibriumPCO2fluxNEW(CO2bloodcurve,CO2gascurve,CO2intoLung)			 
			//print GVSV2pCO2,GVSV2cCO2,GVSV2SAT/100,GVLungSAT/100,-LungCO2flux,GVSV2bicarb,bloodapex*10
				GVLungpCO2=ChangeCO2Content(GVSV2pCO2,GVSV2cCO2,GVLungSAT/100,-LungCO2flux,GVSV2bicarb,GVSV2BE,bloodapex*10)
				GVLungcCO2 = cCO2
				GVLungpH=pH
				//GVLungbicarb=bicarb
				GVLungBE=GVBE
				
		//now recalculate impact of mixing shunted and non-shunted blood to yield the pulmonary vein numbers		
				
			//CombineBloodNEW(GVLungcCO2,(bloodapex*10),GVLungbicarb,GVLungBE,GVSV2cCO2,bloodmiddle*10, GVSV2bicarb,GVSV2BE,GVtemp,GVHb,GVAo1SAT/100)
			ChangeCO2ContentCOMBINE(GVLungpCO2,GVLungcCO2,bloodapex*10,GVLungbicarb,GVSV2cCO2,bloodmiddle*10,GVAo1SAT/100)
				GVAo1pCO2=pCO2
				GVAo1cCO2 = cCO2
				GVAo1pH=pH
				//GVAo1bicarb=bicarb
				GVAo1BE=GVBE
			
		
		//now, mix together Ao1 with the VAECMO flowto yeild the Ao2 numbers
		
			//CombineBloodNEW(GVAo1cCO2,(bloodapex+bloodmiddle)*10,GVAo1bicarb,GVAo1BE,GVECMOcCO2,VAECMOblood*10, GVECMObicarb,GVECMOBE,GVtemp,GVHb,GVAo2Sat/100)
			if ( (bloodapex+bloodmiddle)>VAECMOblood)
				
				ChangeCO2ContentCOMBINE(GVAo1pCO2,GVAo1cCO2,(bloodapex+bloodmiddle)*10,GVAo1bicarb,GVECMOcCO2,VAECMOblood*10,GVAo2SAT/100)
			else
				
				ChangeCO2ContentCOMBINE(GVECMOpCO2,GVECMOcCO2,(VAECMOblood)*10,GVECMObicarb,GVAo1cCO2,(bloodapex+bloodmiddle)*10,GVAo2SAT/100)
			endif
				GVAo2pCO2=pCO2
				GVAo2cCO2 = cCO2
				GVAo2pH=pH
				//GVAo2bicarb=bicarb
				GVAo2BE=GVBE
		
End


Function Update()
	wave artery=artery,vein=vein,alveoli=alveoli,alveioli2=alveoli2
	wave arterycolor=arterycolor,veincolor=veincolor
	wave HbNormal=HbNormal
	
	nvar bloodbase=bloodbase,bloodmiddle=bloodmiddle,bloodapex=bloodapex
	nvar ventbase=ventbase,ventmiddle=ventmiddle,ventapex=ventapex
	
	nvar SatApex=SatApex,SatMiddle=SatMiddle,SatBase=SatBase
	nvar pO2Apex=pO2Apex,pO2Middle=pO2Middle,pO2Base=pO2Base
	
	nvar FIO2=FIO2,ECMOFIO2=ECMOFIO2,SVO2=SVO2,MVO2=MVO2,GVHb=GVHb, PAsat=PAsat, PAPO2=PAPO2
	nvar totalflow=totalflow, heartflow=heartflow, VVECMOflow=VVECMOflow, VAECMOflow=VAECMOflow,PercentVforBlendedECMO=PercentVforBlendedECMO
	nvar satPulmVein=SatPulmVein, pO2PulmVein=pO2PulmVein, SysPO2=SysPO2, SysSat=SysSat, SVPO2=SVPO2
	
	NVAR GVSV1pO2=GVSV1pO2,GVSV2pO2=GVSV2pO2, GVLungpO2=GVLungpO2, GVAo1pO2=GVAo1pO2, GVAo2pO2=GVAo2pO2, GVECMOpO2=GVECMOpO2, GVECMOpCO2=GVECMOpCO2
	NVAR GVSV1SAT=GVSV1SAT,GVSV2SAT=GVSV2SAT, GVLungSAT=GVLungSAT, GVAo1SAT=GVAo1SAT, GVAo2SAT=GVAo2SAT, GVECMOSAT=GVECMOSAT

nvar SF=SF
			
	
	BloodApex=HeartFlow*(1-SF)
	BloodMiddle=HeartFlow*SF
		
	GVSV1SAT=FindSVO2(MVO2,GVAo2Sat,GVAo2pO2,totalflow,gvhb)
	GVSV1pO2=ConvertSat2PO2(GVSV1SAT)
		ChangeGroupBoxColor("groupsystemvenous",GVSV1SAT)
		ChangeGroupBoxColor("grouplowerIVC",GVSV1SAT)
		ChangeGroupBoxColor("groupSysV",GVSV1SAT)

	
		//ECMO  satbase will be output of ECMO that mixes with rest of lung flow-admixture is PA sat
		
	variable maxpo2,maxsat
		maxPO2=ReturnEquilibriumPO2(ECMOFIO2,VentBase,(Sat2PO2(GVSV1SAT)),BloodBase)
		maxsat=Hbnormal[maxPO2]
	

		//need to check that the calculated flux by the above method does not exceed the company specs for maximum ECMO flux		
	variable CalcFlux=CalcBloodContent(maxsat,GVHb,(bloodBase*10)) - CalcBloodContent(GVSV1SAT,GVHb,(bloodBase*10))
	variable MaxFlux=ECMOflux(BloodBase,(760-(sat2po2(GVSV1SAT))))
		
	//print CalcFlux,MaxFlux

	if (CalcFlux<MaxFlux)
		GVECMOpo2=maxPO2-GVECMOpCO2
		GVECMOSAT=maxSat		
	
	else  //add MaxFlux to venous content 
		variable Vcontent= CalcBloodContent(GVSV1SAT,GVHb,(bloodBase*10)) + MaxFlux
	//print Vcontent
		GVECMOpo2= CalcPO2fromContent(Vcontent,GVHb,(bloodbase*10))
		GVECMOSAT=Hbnormal[GVECMOpo2]
	
		
	endif
	
	nvar ECMOefficiency=ECMOefficiency
		ECMOefficiency=min(1,(MaxFlux/CalcFlux))
	
									//now calculate change in pCO2 in the ECMO effluent
									// takes co2 in systemic venous volume going through ECMO, equilibrate pCO2 with ECMO sweep volume, calculate CO2 flux


// Now calculte PA sat--portion of ECMO flow that is returned to venous system will mix with remaining cardiac output.
	
	VVECMOflow=PercentVforBlendedECMO*bloodbase/100
	heartflow=bloodapex+bloodmiddle
	
	if (heartflow<=VVECMOflow)
		
		bloodbase-=1
		VVECMOflow=PercentVforBlendedECMO*bloodbase/100
		print "flow through lungs less than VV ecmo!!"
		
	endif
	
	VAECMOflow=(100-PercentVforBlendedECMO)*bloodbase/100
	totalflow=heartflow+VAECMOflow
	
	
	GVSV2SAT=Admixture(GVECMOSAT,GVECMOpO2,VVECMOflow,GVSV1SAT,GVSV1pO2,(heartflow-VVECMOflow))
	GVSV2pO2=sat2PO2(GVSV2SAT)
		ChangeGroupBoxColor("groupUpperIVC2",GVSV2SAT)
		ChangeGroupBoxColor("groupPulmArt",GVSV2SAT)
		ChangeGroupBoxColor("groupLungA",GVSV2SAT)
		ChangeGroupBoxColor("groupShunt",GVSV2SAT)
		

								//calculate PCO2 content in venous blood
	
	//GOOD LUNG
	nvar GVDLCO=GVDLCO
	variable scaled=limit(  (100-((100-GVDLCO)* (bloodapex/5))),10,100) 
	variable EffectiveFIO2=	scaled*FIO2/100		//just a formula to decrease FIO2 related to DLCO (0 to 100% pred) and CO
	GVLUNGpO2=ReturnEquilibriumPO2(EffectiveFIO2,VentApex,GVSV2pO2,BloodApex)
	//print FIO2,VentApex,PAPO2,BloodApex
	GVLUNGSAT=HbNormal[GVLUNGpO2]
	
			ChangeGroupBoxColor("groupLungV",GVLUNGSAT)
		
	//SHUNT
	
//	po2middle=ReturnEquilibriumPO2(FIO2,VentMiddle,(Sat2PO2(GVSV2SAT)),BloodMiddle)
//	Satmiddle=HbNormal[po2middle]
	
			//veincolor[1]=Convertsat2color2(satMiddle)
		
	//now, combine the good lung and shunt to give the pulm vein admixture
	
		GVAo1SAT=Admixture(GVLUNGSAT,GVLUNGpO2,BloodApex,GVSV2SAT,GVSV2pO2,bloodMiddle)
	//	print GVLUNGSAT,GVLUNGpO2,BloodApex,GVSV2SAT,GVSV2pO2,bloodMiddle
		GVAo1pO2=Sat2PO2(GVAo1SAT)

			ChangeGroupBoxColor("groupPulmVein",GVAo1SAT)
			ChangeGroupBoxColor("groupAorticArch",GVAo1SAT)
			
	//now, combine the pulm vein and the VAecmo flow for the systemic admixture
		GVAo2SAT=Admixture(GVAo1SAT,GVAo1pO2,heartflow,GVECMOSAT,GVECMOpO2,VAECMOflow)
		//print GVAo1SAT,GVAo1pO2,heartflow,GVECMOSAT,GVECMOpO2,VAECMOflow
		GVAo2PO2=Sat2PO2(GVAo2SAT)

		ChangeGroupBoxColor("groupFemoralA",GVAo2SAT)
		ChangeGroupBoxColor("groupSystemArt",GVAo2SAT)
		ChangeGroupBoxColor("groupSysA",GVAo2SAT)

	//Now take care of ph and pCO2
	 NVAR LungCO2Flux=LungCO2Flux, ECMOCO2Flux=ECMOCO2flux
	// do
	 	UpdateCO2NEW()
	// while ( (LungCO2Flux+ECMOCO2Flux-MVO2)>5)
End






Function WriteData()
NVAR GVSV1pCO2= GVSV1pCO2,GVSV2pCO2= GVSV2pCO2, GVLungpCO2= GVLungpCO2, GVAo1pCO2=GVAo1pCO2, GVAo2pCO2=GVAo2pCO2, GVECMOpCO2=GVECMOpCO2
NVAR GVSV1cCO2=GVSV1cCO2,GVSV2cCO2=GVSV2cCO2, GVLungcCO2=GVLungcCO2, GVAo1cCO2=GVAo1cCO2, GVAo2cCO2=GVAo2cCO2, GVECMOcCO2=GVECMOcCO2
NVAR GVSV1pH=GVSV1pH,GVSV2pH=GVSV2pH, GVLungpH=GVLungpH, GVAo1pH=GVAo1pH, GVAo2pH=GVAo2pH, GVECMOpH=GVECMOpH
NVAR GVSV1pO2=GVSV1pO2,GVSV2pO2=GVSV2pO2, GVLungpO2=GVLungpO2, GVAo1pO2=GVAo1pO2, GVAo2pO2=GVAo2pO2, GVECMOpO2=GVECMOpO2
NVAR GVSV1SAT=GVSV1SAT,GVSV2SAT=GVSV2SAT, GVLungSAT=GVLungSAT, GVAo1SAT=GVAo1SAT, GVAo2SAT=GVAo2SAT, GVECMOSAT=GVECMOSAT
NVAR GVSV1bicarb=GVSV1bicarb,GVSV2bicarb=GVSV2bicarb, GVLungbicarb=GVLungbicarb, GVAo1bicarb=GVAo1bicarb, GVAo2bicarb=GVAo2bicarb, GVECMObicarb=GVECMObicarb
NVAR GVSV1BE=GVSV1BE,GVSV2BE=GVSV2BE, GVLungBE=GVLungBE, GVAo1BE=GVAo1BE, GVAo2BE=GVAo2BE, GVECMOBE=GVECMOBE
NVAR GVSV1vol= GVSV1vol,GVSV2vol= GVSV2vol, GVLungvol= GVLungvol, GVAo1vol=GVAo1vol, GVAo2vol=GVAo2vol
NVAR GVHb=GVhb, GVBE=GVBE, GVTemp=GVTemp, mvo2=mvo2, totalflow=totalflow,bloodbase=bloodbase,VentBase=VentBase, PASat=PASat, VentApex=VentApex, BloodApex=BloodApex, BloodMiddle=BloodMiddle
NVAR pH=pH, pCO2=pCO2, cCO2=cCO2, bicarb=bicarb, BE=BE
NVAR EcmoCO2Flux=EcmoCO2Flux, LungCO2Flux=LungCO2Flux, PercentVforBlendedECMO=PercentVforBlendedECMO

variable i=-1
wave w=W_data

i+=1;w[i]=GVSV1pCO2
i+=1;w[i]=GVSV2pCO2
i+=1;w[i]=GVLungpCO2
i+=1;w[i]=GVAo1pCO2
i+=1;w[i]=GVAo2pCO2
i+=1;w[i]=GVECMOpCO2

i+=1;w[i]=GVSV1cCO2
i+=1;w[i]=GVSV2cCO2
i+=1;w[i]=GVLungcCO2
i+=1;w[i]=GVAo1cCO2
i+=1;w[i]=GVAo2cCO2
i+=1;w[i]=GVECMOcCO2

i+=1;w[i]=GVSV1pH
i+=1;w[i]=GVSV2pH
i+=1;w[i]=GVLungpH
i+=1;w[i]=GVAo1pH
i+=1;w[i]=GVAo2pH
i+=1;w[i]=GVECMOpH

i+=1;w[i]=GVSV1pO2
i+=1;w[i]=GVSV2pO2
i+=1;w[i]=GVLungpO2
i+=1;w[i]=GVAo1pO2
i+=1;w[i]=GVAo2pO2
i+=1;w[i]=GVECMOpO2

i+=1;w[i]=GVSV1SAT
i+=1;w[i]=GVSV2SAT
i+=1;w[i]=GVLungSAT
i+=1;w[i]=GVAo1SAT
i+=1;w[i]=GVAo2SAT
i+=1;w[i]=GVECMOSAT

i+=1;w[i]=GVSV1bicarb
i+=1;w[i]=GVSV2bicarb
i+=1;w[i]=GVLungbicarb
i+=1;w[i]=GVAo1bicarb
i+=1;w[i]=GVAo2bicarb
i+=1;w[i]=GVECMObicarb

i+=1;w[i]=GVSV1BE
i+=1;w[i]=GVSV2BE
i+=1;w[i]=GVLungBE
i+=1;w[i]=GVAo1BE
i+=1;w[i]=GVAo2BE
i+=1;w[i]=GVECMOBE

i+=1;w[i]=GVSV1VOL
i+=1;w[i]=GVSV2VOL
i+=1;w[i]=GVLungVOL
i+=1;w[i]=GVAo1VOL
i+=1;w[i]=GVAo2VOL

i+=1;w[i]=GVHb
i+=1;w[i]=GVTemp
i+=1;w[i]=mvo2
i+=1;w[i]=totalflow
i+=1;w[i]=bloodbase
i+=1;w[i]=VentBase
i+=1;w[i]=VentApex
i+=1;w[i]=BloodApex
i+=1;w[i]=BloodMiddle
i+=1;w[i]=EcmoCO2Flux
i+=1;w[i]=LungCO2Flux 
i+=1;w[i]=PercentVforBlendedECMO

End