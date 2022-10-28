global class WT_TerafinaAPYHelper 
{
	global static APYResponseModel GetApy(Double interestRate, Double interestAdjustment, String periodFrequencyChoice, String interestFrequencyCode, Integer maturityPeriod)
    {
        APYResponseModel responseModel = new APYResponseModel();
        responseModel.IsSuccess = false;
        Boolean isMaturityPeriod = false;
        Integer periodFrequency = 0;
        Double calculatedPeriod = 12;
        
        //TODO: Move to Custom Metadata Type
        if(String.isNotBlank(periodFrequencyChoice))
        {
            switch on periodFrequencyChoice.toLowerCase()
            {
                when 'monthly'
                {
                    periodFrequency = 1;
                }
                when 'quarterly'
                {
                    periodFrequency = 3;
                }
                when 'annual'
                {
                    periodFrequency = 12;
                }
                when 'maturity'
                {
                    if(String.isNotBlank(interestFrequencyCode))
                    {
                        if(interestFrequencyCode.toLowerCase() == 'm')
                        {
                            periodFrequency = maturityPeriod;
                        }
                        else if(interestFrequencyCode.toLowerCase() == 'd')
                        {
                            periodFrequency = maturityPeriod;
                            calculatedPeriod = 365;
                        }
                    }
                    isMaturityPeriod = true;
                }
            }
        }
        
        if(periodFrequency != 0)
        {
            Double finalAmountToRaisePower = 1 + (interestRate/(calculatedPeriod/periodFrequency));
            Double finalExponentAmount = calculatedPeriod/periodFrequency;
            Double finalAmount = Math.pow(finalAmountToRaisePower, finalExponentAmount) - 1;
            responseModel.Yield = ((Decimal)(finalAmount * 100)).setScale(4);
        }
        
        Double apy = 0;
        if(interestRate != null)
        {
            Double combinedRate = interestRate;
            
            if(interestAdjustment != null)
            {
                combinedRate = interestRate + interestAdjustment;
            }
            
            Double monthlyRate = combinedRate/12;
            Double finalValueToRaiseToPower = 1 + monthlyRate;
            apy = Math.pow(finalValueToRaiseToPower, 12) - 1;
            
            responseModel.IsSuccess = true;
            responseModel.APY = ((Decimal)(apy * 100)).setScale(2);
        }
        
        return responseModel;
    }
    
    global class APYResponseModel
    {
        public Decimal APY;
        public Decimal Yield;
        public Boolean IsSuccess;
    }
}