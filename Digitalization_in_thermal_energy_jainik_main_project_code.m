           


            
            Ratio_throatarea_exitarea = 5;
            Specific_heat_ratio = 1.4;

             c1 = (Specific_heat_ratio + 1)/2;
            d1 = -(Specific_heat_ratio + 1)/(2*(Specific_heat_ratio - 1));

            a2 = (Specific_heat_ratio-1)/2;
            b2 = (Ratio_throatarea_exitarea)/(c1^d1);
           
            syms m; % m_e = mach number
            mach_equation = b2*m == (1+a2*m^2)^(-d1);
            Y = solve(mach_equation,m);