function [equilibriumConcentration] = equilibrium(solution1Concentration,solution1Volume, solution2Concentration, solution2Volume)

totalAmount = solution1Concentration*solution1Volume + solution2Concentration*solution2Volume;

equilibriumConcentration = totalAmount/(solution1Volume+solution2Volume);

end