#pragma rtGlobals=1		// Use modern global access method.
Function Initialize(ph,pco2)					//start of sim, will put in arterial blood gas, calculate bicarb. Bicarb will be held constant.
	variable pH, pCO2
	
	nvar bicarb=bicarb, hb=hb
	bicarb= Eq8(pco2,ph)
	nvar BE=BE, syspco2=syspco2
		BE=FindBE( bicarb,Hb,ph)
		syspco2=pco2
	print BE,pCO2,bicarb
End

Function ORIGCalcPK(ph,t)
	variable ph,t
	
	variable pk
	
	pk=6.086
	pk+=0.042*(7.4-ph)
	pk+=(38-t)*( 0.00472 + (0.00139*(7.4-ph)) ) 
	
	return (pk)
end

Function CalcPK(ph,t)
	variable ph,t
	
	variable pk
	
	pk=6.086
	pk+=0.042*(7.4-ph)
	pk+=(38-t)*( 0.00472 + (0.00139*(7.4-ph)) ) 
	
	return (6.2)
end

Function CalcS(t)
	variable t //temp in celcius
	
	return (0.0307 + (0.00057*(37-t)) + (0.00002*((37-t)^2))  )
End

Function FindCp(s,pco2,ph,pk)
	variable s,pco2,ph,pk

	variable phdiff=ph-pk
	
	variable CCO2pl=2.226*pco2* s * (1 + 10^phdiff)

	return (CCO2pl)
End



Function FindCb(pco2,temp,ph,Hb,So2)   
	variable pco2,temp,ph,Hb,So2
	
	variable pk=calcpk(ph,temp)
	variable s=calcS(temp)
	
	
	variable Cp= FindCp(s,pco2,ph,pk)
		
	
	variable ratio=(0.0289*hb)/( (3.352 - 0.456*So2)*(8.142-ph) )   

	variable part2=(1 - ratio)
	
	return (Cp*part2)
end
	

	
	
Function FindPH(pco2,hco3)
	variable pco2,hco3
	
	return (6.1 +log (HCO3/ (0.03 * PCO2))   )
end

Function FindCb2(pco2,s,hco3,Hb,So2)
	variable pco2,s,hco3,Hb,So2
	
	variable ph=findph(pco2,hco3)
	
	return (findCb(pco2,s,ph,hb,so2))
end


///*****from Artificial Organs 35(6):579-592 

Function Eq7(BE,Hb,pH)
	variable BE,Hb,pH
	
	variable Chco3=24
	Chco3+=(BE - ((9.5+1.63*hb)*(ph-7.4)))
	Chco3/=(1-(0.014*hb))
return Chco3
end

Function FindBE(CHO3,Hb,pH)
	variable CHO3,Hb,pH
	
	
	variable BE= (CHO3*(1-(0.014*hb))) -24  +  ((9.5+1.63*hb)*(ph-7.4))
return BE
end

Function Eq8(PCO2,ph)
	variable pco2,ph
	
	variable chco3=0.0307*pco2*10^(ph-6.09)
return chco3
end


Function HHequation(HCO3,pH)
	variable HCO3,pH
	
	variable PCO2=HCO3/(0.0307*10^(ph-6.09))
return pCO2
End

Function HHequation2(Hco3,Co2)
	variable HCO3,co2
	
	variable pH = 6.1 + log (HCO3/ (0.0301 * co2))
return pH

end


Function Eq7and8(BE,Hb,ph)	//solve for PCO2 as a function of ph
	variable BE,Hb,ph
	
	variable pCO2=24
	pCO2+=(BE - ((9.5+1.63*hb)*(ph-7.4)))
	pCO2/=(1-(0.014*hb))
	
	pCO2/=0.0307
	pCO2/=(10^(ph-6.09))
return (pco2)
End

Function FindCrossing(w1,w2)
	wave w1,w2
	
	duplicate/o w1, wdiff
		wdiff=w2[p]-w1[p]
		
	FindLevel /Q wdiff,0
		if (V_flag)
			return (nan)
		else
			return (V_levelX)
		endif
	
end


//************************************

Function MakeCO2GasCurve(flow)
	variable flow
	make/o/n=(flow*1000) CO2GasCurve
	CO2GasCurve=760*p/(flow*1000)
End

Function MakeCO2BloodCurve(temp,pHin,Hb,So2in,So2out,flow,pCO2in,BE)
	variable temp,pHin,Hb,So2in,So2out,flow,pCO2in,BE
	
	variable CO2contentIN=FindCb(pco2in,temp,pHin,Hb,So2in)*flow*10
	//print CO2contentIN
		make/o/n=(round(CO2contentIN)*2) CO2bloodcurve
	variable CO2contentout=0, pCO2,pH
	make/o/n=150 w_pco21,w_pco22
			SetScale/I x 6.5,8,"", w_pco21,w_pco22
		
			w_pco22=eq7and8(BE,Hb,x)

			do
				//print  (CO2contentOUT/(flow*10)),temp,x,Hb,So2out
				w_pco21=FindPCO2new((CO2contentOUT/(flow*10)),temp,x,Hb,So2out)
	
	 			pH=FindCrossing(w_pco21,w_pco22)
				if (numtype(ph)>0)
					pCO2=nan
				else			
					pCO2=w_pco21(ph)
				endif
			CO2bloodCurve[CO2contentout]=pCO2
			CO2contentout+=1
			while (	CO2contentout<numpnts(CO2bloodCurve))
	End				
	
Function CombineBlood(Content1,Vol1,Content2,Vol2, temp,Hb,FinalSat)
	variable Content1,Vol1,Content2,Vol2,temp,Hb,FinalSat
	
	variable FinalCO2content=(Content1+Content2)
			
			make/o/n=150 w_pco21,w_pco22
			SetScale/I x 6.5,8,"", w_pco21,w_pco22
			
			variable totalvol=vol1+vol2
			nvar BE=BE, pH=pH,pCO2=pCO2
				w_pco21=FindPCO2new ((FinalCO2content/(totalvol)),temp,x,Hb,FinalSat)
				w_pco22=eq7and8(BE,Hb,x)
	
	 			pH=FindCrossing(w_pco21,w_pco22)
				pCO2=w_pco21(ph)
			return (pco2)
			
	End		
	
Function CombineBlood2(Content1,Vol1,Content2,Vol2, temp,Hb,FinalSat)
	variable Content1,Vol1,Content2,Vol2,temp,Hb,FinalSat
	
	variable FinalCO2content=(Content1+Content2)
			
			make/o/n=150 w_pco21,w_pco22
			SetScale/I x 6.5,8,"", w_pco21,w_pco22
			
			variable totalvol=vol1+vol2
			nvar BE=BE, pH=pH,pCO2=pCO2
				w_pco21=FindPCO2new ((FinalCO2content/(totalvol)),temp,x,Hb,FinalSat)
				w_pco22=eq7and8(BE,Hb,x)
	
	 			pH=FindCrossing(w_pco21,w_pco22)
				pCO2=w_pco21(ph)
			return (pco2)
			
	End						
								
	
Function FindEquilibriumPCO2flux(bloodcurve,gascurve,CO2contentIN)
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


Function FindnewPCO2(PCO2orig,temp,pHorig,Hb,SO2orig,SO2new,co2change,dl)	
	variable PCO2orig,temp,pHorig,Hb,So2orig,SO2new,co2change,dl
											
//variable CO2orig=FindCb(pco2orig,temp,phorig,Hb,So2orig)*dl
	variable CO2orig=FindCb2(pco2orig,temp,phorig,Hb,So2orig)*dl

		//print co2orig
	variable CO2final=CO2orig+co2change			//add +co2 or subtract -co2 to the circulation
		nvar CO2b=CO2b
			CO2b=CO2final
	make/o/n=150 w_pco21,w_pco22
		SetScale/I x 6.5,8,"", w_pco21,w_pco22
		
		w_pco21=FindPCO2new ((CO2final/(dl)),temp,x,Hb,SO2new)
		
	variable bicarborig= Eq8(PCO2orig,pHorig)
	nvar bicarb=bicarb
		bicarb=CorrectBicarbNEW(bicarborig, CO2orig, CO2final)
	nvar BE= BE
		BE=FindBE(bicarb,Hb,phorig)
	//print bicarborig
	//print be
		w_pco22=eq7and8(BE,Hb,x)
	
	nvar pH=pH
		pH=FindCrossing(w_pco21,w_pco22)
	nvar pCO2=pCO2
		pCO2=w_pco21(ph)
	return (pco2)								
											
End

//**********   Go around the circuit, starting with metabolism adding CO2

Function UpdateCO2x10()
	variable i=1
	do
		UpdateCO2()
	i+=1
	while (i<10)
end

Function UpdateCO2()
	
		nvar pCO2apex=pCO2apex,  pCO2middle=pCO2middle,  pCO2base=pCO2base,  pCO2PV=pCO2PV,  pCO2SA=pCO2SA,  pCO2SV=pCO2SV,  pCO2PA=pCO2PA 
		nvar temp=temp, Hb=Hb
		
		nvar bloodbase=bloodbase,bloodmiddle=bloodmiddle,bloodapex=bloodapex
		nvar ventbase=ventbase,ventmiddle=ventmiddle,ventapex=ventapex
	
		nvar SatApex=SatApex,SatMiddle=SatMiddle,SatBase=SatBase
		nvar pO2Apex=pO2Apex,pO2Middle=pO2Middle,pO2Base=pO2Base
	
		nvar FIO2=FIO2,ECMOFIO2=ECMOFIO2,SVO2=SVO2,MVO2=MVO2,Hb=Hb, PAsat=PAsat, PAPO2=PAPO2, SATpulmVein=SATpulmVein
		nvar totalflow=totalflow, heartflow=heartflow, VVECMOflow=VVECMOflow, VAECMOflow=VAECMOflow,PercentVforBlendedECMO=PercentVforBlendedECMO
		nvar satPulmVein=SatPulmVein, pO2PulmVein=pO2PulmVein, SysPO2=SysPO2, SysSat=SysSat, PASat=PASat

		nvar pHsa=pHsa,pHsv=pHsv, pHPA=pHPA, pHPV=pHPV,pH=pH, CO2b=CO2b, ECMOCO2flux=ECMOCO2flux, LungCO2Flux,BE=BE
		
		pCO2SV=FindnewPCO2(PCO2sa,temp,pHsa,Hb,SysSat,SVO2,mvo2,totalflow*10)	
		//print PCO2sa,temp,pHsa,Hb,SysSat,SVO2,mvo2,totalflow*10
		 	pHsv=pH
			variable CO2sv = CO2b

		//	print pH,pCO2sv,CO2sv
		
		//print bloodbase
		
		variable CO2IntoECMO=CO2sv*bloodbase/totalflow					// prorate content based on proportion of ecmo flow
			variable CO2BypassECMO=CO2b-CO2IntoECMO
			
			//print  CO2IntoECMO, CO2bypassECMO
		if (bloodbase>0)
			//now calculate ECMO impact on venous blood
			MakeCO2GasCurve(ventbase)			//base represents ECMO 
			MakeCO2BloodCurve(temp,pHsv,Hb,SVo2,SatBase,bloodbase,pCO2SV,BE)
		
			wave CO2bloodcurve=CO2bloodcurve, CO2gascurve=CO2gascurve
			
			ECMOCO2flux=FindEquilibriumPCO2flux(CO2bloodcurve,CO2gascurve,CO2IntoECMO)			 
				nvar PCO2=PCO2
				pCO2base=PCO2
				
		else
			ECMOCO2flux=0
		endif
		
		variable VVECMOCO2flux,VAECMOCO2Flux
			VVECMOCO2flux=ECMOCO2flux*PercentVforBlendedECMO/100
			VAECMOCO2flux=ECMOCO2flux-VVECMOCO2Flux
					
		//now recalculate pCO2 in PA based on the amount of ecmo flow that is returned to the PA, and the addition of the CO2 contents in the ECMO effluent and in the SV
		
		//print PCO2sv,temp,pHsv,Hb,SVO2,PASAT,(-VVECMOCO2FLux),heartflow*10
		pCO2PA=FindnewPCO2(PCO2sv,temp,pHsv,Hb,SVO2,PASAT,(-VVECMOCO2FLux),heartflow*10)	
		
		pHPA=pH
		variable CO2PA=CO2b
		
		//print pH,PCO2PA,CO2PA
		
		//now calculate impact of non-shunted regions of lungs on co2 elimination 
		//print "Make co2 bloodcurve" , temp,pHPA,Hb,PASAT,SatApex,bloodapex,pCO2PA,BE
			MakeCO2GasCurve(ventapex)			//base represents ECMO 
			MakeCO2BloodCurve(temp,pHPA,Hb,PASAT,SatApex,bloodapex,pCO2PA,BE)
		
			wave CO2bloodcurve=CO2bloodcurve, CO2gascurve=CO2gascurve
			
			variable CO2IntoLung=CO2PA*bloodapex/heartflow					// prorate content based on proportion of lung vs shunt flow
			variable CO2shunt=CO2PA-CO2IntoLung
			

			LungCO2flux=FindEquilibriumPCO2flux(CO2bloodcurve,CO2gascurve,CO2intoLung)			 
			
				nvar PCO2=PCO2
				pCO2apex=PCO2
				
		
		//now, mix together CO2 in ventilated lung with the shunt fraction for the pulmonary venous CO2
		
		pCO2PV=FindnewPCO2(PCO2PA,temp,pHPA,Hb,PASAT,SATpulmVein,(-LungCO2FLux),heartflow*10)	
		pHPV=pH
		variable CO2PV=CO2b
		
	//	print PCO2PA,temp,pHPA,Hb,PASAT,SATpulmVein,(-LungCO2FLux),heartflow*10
		
		//print pH,pCO2PV,CO2PV
		
		

		//now, mix together CO2 in pulmonary vein with the VAECMO flow and CO2 content for the systemic CO2
		
		pCO2SA=FindnewPCO2(PCO2PV,temp,pHPV,Hb,SatPulmVein,SYSSAT,(-VAECMOCO2FLux),totalflow*10)
		//print PCO2PV,temp,pHPV,Hb,SatPulmVein,SYSSAT,(-VAECMOCO2FLux),totalflow*10
		variable CO2SA=CO2b
		pHSA=pH
		//print pH,pCO2SA, CO2SA
		
	End
	
//EXTRA O2 calc

Function ConvertSat2PO2(sat)
	variable sat
	
	wave HbCurve=HbCurve
	Findlevel/q HbCurve sat
	return (V_levelX)
			
End