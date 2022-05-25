function [bodyPlasma, bodyBlood] = portionBodyMix(bodyPlasma, portionPlasma, bodyBlood, portionBlood)

%---------------------PLASMA-----------------------------------------------------------------------------------------------------
bodyPlasma.volume = bodyPlasma.volume - portionPlasma.volume; %Remove portion volume from body plasma volume before mixing

%Calculations of concentrations of strong ions in body plasma after mixing
bodyPlasma.Na = equilibrium(bodyPlasma.Na, bodyPlasma.volume, portionPlasma.Na, portionPlasma.volume);
bodyPlasma.K = equilibrium(bodyPlasma.K, bodyPlasma.volume, portionPlasma.K, portionPlasma.volume);
bodyPlasma.Ca = equilibrium(bodyPlasma.Ca, bodyPlasma.volume, portionPlasma.Ca, portionPlasma.volume);
bodyPlasma.Mg = equilibrium(bodyPlasma.Mg, bodyPlasma.volume, portionPlasma.Mg, portionPlasma.volume);
bodyPlasma.Cl = equilibrium(bodyPlasma.Cl, bodyPlasma.volume, portionPlasma.Cl, portionPlasma.volume);
bodyPlasma.PO4 = equilibrium(bodyPlasma.PO4, bodyPlasma.volume, portionPlasma.PO4, portionPlasma.volume);
bodyPlasma.SO4 = equilibrium(bodyPlasma.SO4, bodyPlasma.volume, portionPlasma.SO4, portionPlasma.volume);
bodyPlasma.acids = equilibrium(bodyPlasma.acids, bodyPlasma.volume, portionPlasma.acids, portionPlasma.volume);
bodyPlasma.glucose = equilibrium(bodyPlasma.glucose, bodyPlasma.volume, portionPlasma.glucose, portionPlasma.volume);

bodyPlasma.volume = bodyPlasma.volume + portionPlasma.volume; %Add portion volume to body plasma volume after mixing

%---------------------BLOOD------------------------------------------------------------------------------------------------------

bodyBlood.volume = bodyBlood.volume - portionBlood.volume; %Remove portion volume from body blood volume before mixing

bodyBlood.tCO2 = equilibrium(bodyBlood.tCO2, bodyBlood.volume, portionBlood.tCO2, portionBlood.volume); %Calculate new concentration of tCO2

BBbefore = bodyBlood.BB; %temporarily saves the concentration of BB to calculate BE 
bodyBlood.BB = equilibrium(bodyBlood.BB, bodyBlood.volume, portionBlood.BB, portionBlood.volume); %Calculate new concentration of BB

bodyBlood.BE = bodyBlood.BE - (BBbefore-bodyBlood.BB); %Calculate the new BE, based on the change of BB

p = totals_newton(bodyBlood.tCO2, bodyBlood.BE, bodyBlood.tO2, bodyBlood.Hb, bodyBlood.FMetHb, bodyBlood.FCOHb, bodyBlood.T, bodyBlood.cDPG);
bodyBlood.pH = p(1);
bodyBlood.PCO2 = p(2);
bodyBlood.PO2 = p(3);
bodyBlood.SO2 = p(4);

q = estcrb2b(bodyBlood.pH, bodyBlood.PCO2, bodyBlood.PO2,bodyBlood.Hb, bodyBlood.FMetHb, bodyBlood.FCOHb, bodyBlood.T, bodyBlood.cDPG);
bodyPlasma.SID = q(6);

bodyBlood.volume = bodyBlood.volume + portionBlood.volume; %Add portion volume to body blood volume after mixing

end