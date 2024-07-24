function IGainCOntrol = GainControlPreProcessing(I0)        

        Icss = CalculateCenterSrndSorf(I0,1,4);
        
        ISORF = CenterSeroundSORF(I0,1,15,30,1,10,20);
        IPossitive = ISORF - min(min(ISORF)); % if negative it will come to zero and above
        ISORFnorm= IPossitive./max(max(IPossitive));
        
        alpha = 0.5;
        Inew = alpha*ISORFnorm + (1-alpha)*Icss;
        IGainCOntrol = Inew./max(max(Inew));