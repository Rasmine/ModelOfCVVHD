clear; clc;

%-----------------------------INPUT VALUES ------------------------------------
%Initial Patient Blood Values
bodyBlood.pH = 7.28;
bodyBlood.PCO2 = 4.7;
bodyBlood.PO2 = 6;
bodyBlood.Hb = 9.3;
bodyBlood.FMetHb = 0;
bodyBlood.FCOHb = 0;
bodyBlood.T = 37;
bodyBlood.cDPG = 5;
bodyBlood.volume = 5; %L

%Initial Patient Plasma Values
bodyPlasma.Na = 138;
bodyPlasma.K = 3.5;
bodyPlasma.Ca = 2.3;
bodyPlasma.Mg = 0.9; 
bodyPlasma.Cl = 106;
bodyPlasma.PO4 = 1.2;
bodyPlasma.SO4 = 0.6;
bodyPlasma.acids = 6;
bodyPlasma.glucose = 10.5; 

%Initial Dialysate Values
dialysate.Na = 140;
dialysate.K = 2;
dialysate.Ca = 1.5;
dialysate.Mg = 0.5;
dialysate.Cl = 111;
dialysate.HCO3 = 35;
dialysate.PO4 = 0;
dialysate.SO4 = 0; 
dialysate.acids = 0;
dialysate.glucose = 5.55;

%Flow Values
bloodFlow = 100; %ml/min
dialysateFlow =2000; %ml/h

%--------------------------------------------------------------------------------

%Calculations of variables of bodyBlood and SID in plasma and dialysate
q = estcrb2b(bodyBlood.pH, bodyBlood.PCO2, bodyBlood.PO2,bodyBlood.Hb, bodyBlood.FMetHb, bodyBlood.FCOHb, bodyBlood.T, bodyBlood.cDPG);
bodyBlood.BE = q(1);
bodyBlood.tCO2 = q(2); 
bodyBlood.SO2 = q(3);
bodyBlood.BB = q(4);
bodyBlood.tO2 = q(5);
bodyPlasma.SID = q(6);
bodyPlasma.HCO3 = q(7);
bodyPlasma.NBB = q(8);

dialysate.SID = SID(dialysate); %Calculation of SID in dialysate according to solute concentrations in dialysate

bodyPlasma.volume = bodyBlood.volume * 0.55 ; %Calculation of plasma volume in Liters

portionPlasma = bodyPlasma; %Creates a portion of Plasma with the same concentrations
portionBlood = bodyBlood; %Creates a portion of Blood with the same concentrations

%Calculation of portion and dialysate volume
plasmaFlow = bloodFlow * 0.55;  %Plasma is 55% of blood
portionPlasma.volume = plasmaFlow/1000; %Unit is L/min
plasmaPortionVolume = portionPlasma.volume; %Create global variable for plasma portion volume
portionBlood.volume = bloodFlow/1000; %Unit is L/min
bloodPortionVolume = portionBlood.volume; %Create global variable for blood portion volume
dialysate.volume = (dialysateFlow/60)/1000; %Unit is L/min

for minute = 1:1200

    %----------------------DIFFUSION------------------------------
    [portionPlasma, dialysateEffluent] = soluteDiffusion(portionPlasma, dialysate);
    
    %-----------------------UPDATE OF BLOOD PORTION---------------
    [portionBlood, portionPlasma, transportedCO2Amount] = updateBlood(portionBlood, portionPlasma, dialysate, dialysateEffluent);
    
    %-----------------------MIXING PORTION AND BODY---------------
    [bodyPlasma, bodyBlood] = portionBodyMix(bodyPlasma, portionPlasma, bodyBlood, portionBlood);
    
    %----------------------------REMOVING CO2---------------------
    bodyBlood.tCO2 = (bodyBlood.tCO2*bodyBlood.volume - transportedCO2Amount*0.35)/bodyBlood.volume;
   
    %Calculations of ph, PCO2 etc. in blood portion
    p = totals_newton(bodyBlood.tCO2, bodyBlood.BE, bodyBlood.tO2, bodyBlood.Hb, bodyBlood.FMetHb, bodyBlood.FCOHb, bodyBlood.T, bodyBlood.cDPG);
    bodyBlood.pH = p(1);
    bodyBlood.PCO2 = p(2);
    bodyBlood.PO2 = p(3);
    bodyBlood.SO2 = p(4);
    
    %--PREPARING FOR A NEW PORTION OF BLOOD AND PLASMA WITH THE CONCENTRATIONS FROM THE BODY-
    portionPlasma = bodyPlasma;
    portionBlood = bodyBlood;
    portionPlasma.volume = plasmaPortionVolume;
    portionBlood.volume = bloodPortionVolume;


end
