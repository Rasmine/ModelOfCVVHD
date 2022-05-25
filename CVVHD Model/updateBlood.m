function [portionBlood, portionPlasma, transportedCO2Amount] = updateBlood(portionBlood, portionPlasma, dialysate, dialysateEffluent)

dialysate.SIDAmount = dialysate.SID * dialysate.volume; %Calculates SID amount in dialysate before diffusion
dialysateEffluent.SIDAmount = dialysateEffluent.SID * dialysateEffluent.volume; %Calculates SID amount in dialysate after diffusion
transportedCO2Amount = dialysate.SIDAmount - dialysateEffluent.SIDAmount; %Calculates the transported CO2 amount from dialysate to blood, which is equal to the transported amount of HCO3, which is equal to SID in dialysate
transportedBBAmount = transportedCO2Amount; %Calculates the transported buffer base amount, which is equal to transported CO2 amount as OH- is also transported

portionBlood.amountTCO2 = portionBlood.tCO2 * portionBlood.volume; %Calculates tCO2 amount in blood portion before diffusion
portionBlood.amountTCO2 = portionBlood.amountTCO2 + transportedCO2Amount; %Calculates new tCO2 amount in Blood portion after diffusion
portionBlood.tCO2 = portionBlood.amountTCO2 / portionBlood.volume; %Calculates new tCO2 concentration

portionBlood.amountBB = portionBlood.BB * portionBlood.volume; %Calculates Buffer base amount in blood portion before diffusion
portionBlood.amountBB = portionBlood.amountBB + transportedBBAmount; %Calculates new buffer base amount in Blood portion after diffusion
portionBlood.BB = portionBlood.amountBB / portionBlood.volume; %Calculates new buffer base concentration

portionBlood.BE = portionBlood.BE + (transportedBBAmount/portionBlood.volume); %Calculates base excess in Blood portion

%Calculations of ph, PCO2 etc. in blood portion
p = totals_newton(portionBlood.tCO2, portionBlood.BE, portionBlood.tO2, portionBlood.Hb, portionBlood.FMetHb, portionBlood.FCOHb, portionBlood.T, portionBlood.cDPG);
portionBlood.pH = p(1);
portionBlood.PCO2 = p(2);
portionBlood.PO2 = p(3);
portionBlood.SO2 = p(4);

%Updates SID in blood portion after diffusion
q = estcrb2b(portionBlood.pH, portionBlood.PCO2, portionBlood.PO2,portionBlood.Hb, portionBlood.FMetHb, portionBlood.FCOHb, portionBlood.T, portionBlood.cDPG);
portionPlasma.SID = q(6);
portionPlasma.HCO3 = q(7);
portionPlasma.NBB = q(8);

end