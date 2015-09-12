#pragma rtGlobals=1		// Use modern global access method.
//formulae taken from J PPl PHysio 90:1798-1810,2001

Function FindcCO2plEq1(pCO2,ph,pk)			//eq 1
	variable pco2,ph,pk
	variable s=0.0307
	
	return (2.226*pCO2*s*(1+10^(ph-pk)))		//added 2.226 factor to convert from mmol to ml!!!
End

Function FindpCO2eq1r(cCO2pl,ph,pk)
	variable cCO2pl,ph,pk
	variable s=0.0307
	
	return ( cCO2pl/(2.226*s*(1+10^(ph-pk))))
End


Function FIndHCO3plEq2(cCO2pl, pCO2pl)			//eq 2
	variable cCO2pl, pCO2pl
	variable s=0.0307

	return ((cCO2pl - (pCO2pl*s))	/2.226)			//added 2.226 factor to convert from mmol to ml!!!
End

Function FIndpCO2plEq2r(cCO2pl,HCO3pl)			//eq 2 rearranged
	variable cCO2pl,HCO3pl
	variable s=0.0307

	return ( (cCO2pl -(HCO3pl*2.226))/s )
End

Function HHequationFindpH(Hco3pl,pCO2pl)
	variable Hco3pl,pCO2pl
	
	variable pH = 6.1 + log (HCO3pl/ (0.0301 * pco2pl))
return pH

end

Function HHequationFindpCO2(Hco3pl,ph)
	variable HCO3pl,pH
	
	variable PCO2pl=HCO3pl/(0.0307*10^(ph-6.09))
return pCO2pl

end


Function FindPkEq3(ph)
	variable ph
	
	variable pk
	
	pk=6.086
	pk+=0.042*(7.4-ph)
	pk+=0.00472
	pk+= 0.00139*(7.4-ph) 
	
	return (pk)
end

Function FindPkEq3andHH(Hco3pl,pCO2pl)
	variable Hco3pl,pCO2pl
	
	variable pk
	variable ph=HHequationFindpH(Hco3pl,pCO2pl)
	pk=6.086
	pk+=0.042*(7.4-ph)
	pk+=0.00472
	pk+= 0.00139*(7.4-ph) 
	
	return (pk)
end

Function FindcCO2bEq4(cCO2pl, Hb, sat,pH)
	variable cCO2pl, Hb, sat, pH
	
	variable result
		result = cCO2pl
		result *= (1 - (  0.0289*hb/( (3.352 - 0.456*sat)*(8.142-pH) )    ) )
	return result
end

Function FindcCO2bEq4plus(Hb, sat,HCO3pl,pCO2pl,pCO2new)
	variable Hb, sat,HCO3pl,pCO2pl,pCO2new
	variable s=0.0307
	
	variable newbicarb=CorrectBicarbNEW(HCO3pl, pCO2pl, (pCO2new-pCO2pl))
	//variable newbicarb=HCO3pl
	variable pH = 6.1 + log (newbicarb/ (0.0301 * pco2new))
	variable pk=FindPkEq3andHH(newbicarb,pCO2new)
	variable cCO2pl=(2.226*pCO2new*s*(1+10^(ph-pk)))
	
	variable result = cCO2pl*(1 - (  0.0289*hb/( (3.352 - 0.456*sat)*(8.142-pH) )    ) )
	
	return result
end





Function FindcCO2plEq4andHH(cCO2b, Hb, sat,HCO3pl,pCO2pl)
	variable cCO2b, Hb, sat,HCO3pl,pCO2pl
	variable ph=HHequationFindpH(HCO3pl,pCO2pl)
	
	variable cCO2pl = cCO2b / (1 - (  0.0289*hb/( (3.352 - 0.456*sat)*(8.142-pH) )    ) )
	return cCO2pl
end



Function FindpCO2eq1req4andHH(cCO2b,Hb,sat,HCO3pl,pCO2pl)
	variable cCO2b,Hb,sat,HCO3pl,pCO2pl
	variable s=0.0307
	
	variable pk=FindPkEq3andHH(Hco3pl,pCO2pl)
	variable ph=HHequationFindpH(Hco3pl,pCO2pl)
	
	variable cCO2pl=FindcCO2plEq4andHH(cCO2b, Hb, sat,HCO3pl,pCO2pl)
	
	 return ( cCO2pl/(2.226*s*(1+10^(ph-pk))))
End

