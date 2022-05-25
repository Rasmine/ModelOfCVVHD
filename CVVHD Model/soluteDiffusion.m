function [plasma, dialysate] = soluteDiffusion(plasma,dialysate)

dialysateClAmountTotal = dialysate.Cl*dialysate.volume;
dialysateClAmountEq = dialysateClAmountTotal*0.8;
dialysateClAmountExtra = dialysateClAmountTotal*0.2;
dialysate.Cl = dialysateClAmountEq/dialysate.volume;

%Calculation of eqilibrium concentrations of strong ions
plasma.Na = equilibrium(dialysate.Na, dialysate.volume, plasma.Na, plasma.volume);
plasma.K = equilibrium(dialysate.K, dialysate.volume, plasma.K, plasma.volume);
plasma.Ca = equilibrium(dialysate.Ca, dialysate.volume, plasma.Ca, plasma.volume);
plasma.Mg = equilibrium(dialysate.Mg, dialysate.volume, plasma.Mg, plasma.volume);
plasma.Cl = equilibrium(dialysate.Cl, dialysate.volume, plasma.Cl, plasma.volume);
plasma.PO4 = equilibrium(dialysate.PO4, dialysate.volume, plasma.PO4, plasma.volume);
plasma.SO4 = equilibrium(dialysate.SO4, dialysate.volume, plasma.SO4, plasma.volume);
plasma.acids = equilibrium(dialysate.acids, dialysate.volume, plasma.acids, plasma.volume);
plasma.glucose = equilibrium(dialysate.glucose, dialysate.volume, plasma.glucose, plasma.volume);

dialysate.Na = plasma.Na;
dialysate.K = plasma.K;
dialysate.Ca = plasma.Ca;
dialysate.Mg = plasma.Mg;
dialysate.Cl = plasma.Cl;
dialysate.PO4 = plasma.PO4;
dialysate.SO4 = plasma.SO4;
dialysate.acids = plasma.acids;
dialysate.glucose = plasma.glucose;

dialysateClAmount = (dialysate.Cl*dialysate.volume) + dialysateClAmountExtra;
dialysate.Cl = dialysateClAmount/dialysate.volume;

%Calculation of SID in plasma and dialysate
plasma.SID = SID(plasma);
dialysate.SID = SID(dialysate);

end