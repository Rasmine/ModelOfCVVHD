function [SID] = SID(solution)

positive = solution.Na + solution.K + solution.Ca*2 + solution.Mg*2; %mEq
negative = - solution.Cl - solution.PO4*1.7692 - solution.SO4*2 - solution.acids*1.047; %mEq
SID = positive+negative;
end