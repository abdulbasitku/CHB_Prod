global class QSRBatchForMPF3 implements Database.Batchable<sObject>, Database.Stateful {
    
    boolean isNewBusiness;
    Date generationDate;
    Date tdt;//last date of quarter of input date    
    Integer tmonth; //get month
    Integer tyear; //get year
    string TQ;
    Date qsdt; //input date quarter start date
    Date ldt; //last date
    
    string Unqualified = 'Unqualified';
    string Marketing_Qualified = 'Marketing Qualified';
    string Confirmed_SQL = 'Confirmed - SQL';
    string Sales_Initiated = 'Sales Initiated';
    string In_Process = 'In Process';
    string Demo = 'Demo';
    string Proposal_Submitted = 'Proposal - Submitted';
    string Short_Listed = 'Short Listed';
    string Contract_Issued = 'Contract Issued';
    string Closed_Won = 'Closed Won';
    string Closed_Lost = 'Closed Lost';
    string Closed_No_Decision = 'Closed No Decision';
    string Closed_Disqualified = 'Closed - Disqualified';
    
    
    string Q1 = 'Q1';
    string Q2 = 'Q2';
    string Q3 = 'Q3';
    string Q4 = 'Q4';
    
    string CQ = 'CQ';
    
    string LQ1 = 'LQ1';
    string LQ2 = 'LQ2';
    string LQ3 = 'LQ3';
    string LQ4 = 'LQ4';
    
    string YTD = 'YTD';
    
    string NN_BB;
    
    List<QSR_Metric_Opportunity__c> allQsrMetricOpps;
    Map<String, QSR_Metric_Value__c> allQsrMetricValueMaps;
    
    global QSRBatchForMPF3(Date generationDate, boolean isNewBusiness, List<QSR_Metric_Opportunity__c> allQsrMetricOpps, Map<String, QSR_Metric_Value__c> allQsrMetricValueMaps)
    {
        this.isNewBusiness = isNewBusiness;
        this.generationDate = generationDate;    
        if(isNewBusiness)
        {
            this.NN_BB = 'NN';
        }
        else
        {
            this.NN_BB = 'BB';
        }
        
        this.allQsrMetricOpps = allQsrMetricOpps;
        this.allQsrMetricValueMaps = allQsrMetricValueMaps ;
    }
    
    //Method to get the data to be proceesed  
    global database.Querylocator Start(Database.BatchableContext bc){
        
        system.debug('Method --> GenerateQSRReportMarketingByProductFamily() --> Start');
        
        tdt = QSRHelper.GetQuarterLastDate(generationDate);
        system.debug('Input Date Quarter - Last Date: ' + tdt);
        tmonth = tdt.Month(); //get month
        system.debug('Input Month: ' + tmonth);
        tyear = tdt.Year(); //get year
        system.debug('Input Year: ' + tyear);
        qsdt = QSRHelper.GetQuarterStartDate(tmonth, tdt);
        system.debug('Input Date Quarter - Start Date: ' + qsdt);
        ldt = qsdt.addYears(-1);
        system.debug('Last Date: ' + ldt);
        
        TQ = QSRHelper.GetQuarterByMonth(tmonth);        
        system.debug('Input Date Quarter: ' + TQ);
        
        /*if(Test.isRunningTest())
{
//allOppStageHistory = allOppStageHistoryTest;            
}
else*/
        {
            if(isNewBusiness)
            {
                
                return Database.getQueryLocator([Select Id, Name, Type, CHB_Amount__c, CreatedDate, CreatedById, StageName, CloseDate, First_Source__c, Last_Source__c, Product_Family__c,
                                                 Product_Family__r.Name, Product_Family__r.Business_Group__c, Product_Family__r.Business_Group__r.Name From Opportunity where Type = 'New Business' 
                                                 AND StageName like 'Closed%' AND (CloseDate >= :ldt AND CloseDate <= :tdt)]);
            }
            else 
            {
                return Database.getQueryLocator([Select Id, Name, Type, CHB_Amount__c, CreatedDate, CreatedById, StageName, CloseDate, First_Source__c, Last_Source__c, Product_Family__c,
                                                 Product_Family__r.Name, Product_Family__r.Business_Group__c, Product_Family__r.Business_Group__r.Name From Opportunity where Type != 'New Business' 
                                                 AND StageName like 'Closed%' AND (CloseDate >= :ldt AND CloseDate <= :tdt)]);                
            }
        }        
    }
    
    //Method to execute the batch
    global void execute(Database.BatchableContext bc, List<sobject> opps){
        
        for(sobject sop : opps)
        {
            Opportunity op = (Opportunity) sop;
            
            QSR_Metric_Opportunity__c qsrMetricOpp = new QSR_Metric_Opportunity__c();

            //All Opps Closed            
            Datetime ocdt = op.CloseDate; 
            Integer ocmonth = ocdt.Month(); //get month
            Integer ocyear = ocdt.Year(); //get year
            Double cwamt = 0;
            if(op.CHB_Amount__c != null)
            {
                cwamt = op.CHB_Amount__c;
            }
            
            string ocq  = QSRHelper.GetOppQuarter(ocmonth, ocyear, TQ, tyear, tmonth);
            if(op.Product_Family__c == null)
            {
                continue;
            }
            
            
            string qsrMetricValueExtId;
            QSR_Metric_Value__c qsrMetricValue;
            
            //All Opps Closed Won - Quarterwise
            if(op.StageName == 'Closed Won')
            {   
                qsrMetricValueExtId = 'MKTPF_' + NN_BB + '_OPP_CLOSED_WON_' + op.Product_Family__r.Name;
                qsrMetricValue =  allQsrMetricValueMaps.get(qsrMetricValueExtId);
                
                qsrMetricOpp = new QSR_Metric_Opportunity__c();
                
                if(ocq == CQ)
                {
                    qsrMetricValue.Current_Quarter_Count__c= qsrMetricValue.Current_Quarter_Count__c + 1;
                    qsrMetricValue.Current_Quarter_Amount__c = qsrMetricValue.Current_Quarter_Amount__c + cwamt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = op.Id;                            
                    qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue.Id;
                    qsrMetricOpp.Quarter__c= CQ;
                    allQsrMetricOpps.Add(qsrMetricOpp);
                }
                if(ocq == LQ1)
                {                    
                    qsrMetricValue.Last_Quarter_Count__c= qsrMetricValue.Last_Quarter_Count__c + 1;
                    qsrMetricValue.Last_Quarter_Amount__c = qsrMetricValue.Last_Quarter_Amount__c + cwamt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = op.Id;                            
                    qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue.Id;
                    qsrMetricOpp.Quarter__c= LQ1;
                    allQsrMetricOpps.Add(qsrMetricOpp);
                }
                if(ocq == LQ2)
                {
                    qsrMetricValue.X2nd_Last_Quarter_Count__c= qsrMetricValue.X2nd_Last_Quarter_Count__c + 1;
                    qsrMetricValue.X2nd_Last_Quarter_Amount__c = qsrMetricValue.X2nd_Last_Quarter_Amount__c + cwamt; 
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = op.Id;                            
                    qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue.Id;
                    qsrMetricOpp.Quarter__c= LQ2;  
                    allQsrMetricOpps.Add(qsrMetricOpp);                 
                }
                if(ocq == LQ3)
                {
                    qsrMetricValue.X3rd_Last_Quarter_Count__c= qsrMetricValue.X3rd_Last_Quarter_Count__c + 1;
                    qsrMetricValue.X3rd_Last_Quarter_Amount__c = qsrMetricValue.X3rd_Last_Quarter_Amount__c + cwamt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = op.Id;                            
                    qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue.Id;
                    qsrMetricOpp.Quarter__c= LQ3;
                    allQsrMetricOpps.Add(qsrMetricOpp);
                }
                if(ocq == LQ4)
                {
                    qsrMetricValue.X4th_Last_Quarter_Count__c= qsrMetricValue.X4th_Last_Quarter_Count__c + 1;
                    qsrMetricValue.X4th_Last_Quarter_Amount__c = qsrMetricValue.X4th_Last_Quarter_Amount__c + cwamt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = op.Id;                            
                    qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue.Id;
                    qsrMetricOpp.Quarter__c= LQ4;
                    allQsrMetricOpps.Add(qsrMetricOpp);
                }
                if(ocyear == tyear)
                {
                    qsrMetricValue.Year_To_Date_Count__c = qsrMetricValue.Year_To_Date_Count__c + 1;
                    qsrMetricValue.Year_To_Date_Amount__c = qsrMetricValue.Year_To_Date_Amount__c + cwamt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = op.Id;                            
                    qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue.Id;
                    qsrMetricOpp.Quarter__c= YTD;
                    allQsrMetricOpps.Add(qsrMetricOpp);
                }
                
                //If Opp Closed Won and Gen by Mkt
                if(QSRHelper.IsSourceMarketing(op.First_Source__c))
                {
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    
                    qsrMetricValueExtId = 'MKTPF_' + NN_BB + '_OPP_CLOSED_WON_GEN_BY_MKT_' + op.Product_Family__r.Name;
                    qsrMetricValue =  allQsrMetricValueMaps.get(qsrMetricValueExtId);
                    
                    if(ocq == CQ)
                    {
                        qsrMetricValue.Current_Quarter_Count__c= qsrMetricValue.Current_Quarter_Count__c + 1;
                        qsrMetricValue.Current_Quarter_Amount__c = qsrMetricValue.Current_Quarter_Amount__c + cwamt;
                        
                        qsrMetricOpp = new QSR_Metric_Opportunity__c();
                        qsrMetricOpp.Opportunity__c = op.Id;                            
                        qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue.Id;
                        qsrMetricOpp.Quarter__c= CQ;
                        allQsrMetricOpps.Add(qsrMetricOpp);
                    }
                    if(ocq == LQ1)
                    {                    
                        qsrMetricValue.Last_Quarter_Count__c= qsrMetricValue.Last_Quarter_Count__c + 1;
                        qsrMetricValue.Last_Quarter_Amount__c = qsrMetricValue.Last_Quarter_Amount__c + cwamt;
                        
                        qsrMetricOpp = new QSR_Metric_Opportunity__c();
                        qsrMetricOpp.Opportunity__c = op.Id;                            
                        qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue.Id;
                        qsrMetricOpp.Quarter__c= LQ1;
                        allQsrMetricOpps.Add(qsrMetricOpp);
                    }
                    if(ocq == LQ2)
                    {
                        qsrMetricValue.X2nd_Last_Quarter_Count__c= qsrMetricValue.X2nd_Last_Quarter_Count__c + 1;
                        qsrMetricValue.X2nd_Last_Quarter_Amount__c = qsrMetricValue.X2nd_Last_Quarter_Amount__c + cwamt; 
                        
                        qsrMetricOpp = new QSR_Metric_Opportunity__c();
                        qsrMetricOpp.Opportunity__c = op.Id;                            
                        qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue.Id;
                        qsrMetricOpp.Quarter__c= LQ2;   
                        allQsrMetricOpps.Add(qsrMetricOpp);                
                    }
                    if(ocq == LQ3)
                    {
                        qsrMetricValue.X3rd_Last_Quarter_Count__c= qsrMetricValue.X3rd_Last_Quarter_Count__c + 1;
                        qsrMetricValue.X3rd_Last_Quarter_Amount__c = qsrMetricValue.X3rd_Last_Quarter_Amount__c + cwamt;
                        
                        qsrMetricOpp = new QSR_Metric_Opportunity__c();
                        qsrMetricOpp.Opportunity__c = op.Id;                            
                        qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue.Id;
                        qsrMetricOpp.Quarter__c= LQ3;
                        allQsrMetricOpps.Add(qsrMetricOpp);
                    }
                    if(ocq == LQ4)
                    {
                        qsrMetricValue.X4th_Last_Quarter_Count__c= qsrMetricValue.X4th_Last_Quarter_Count__c + 1;
                        qsrMetricValue.X4th_Last_Quarter_Amount__c = qsrMetricValue.X4th_Last_Quarter_Amount__c + cwamt;
                        
                        qsrMetricOpp = new QSR_Metric_Opportunity__c();
                        qsrMetricOpp.Opportunity__c = op.Id;                            
                        qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue.Id;
                        qsrMetricOpp.Quarter__c= LQ4;
                        allQsrMetricOpps.Add(qsrMetricOpp);
                    }
                    if(ocyear == tyear)
                    {
                        qsrMetricValue.Year_To_Date_Count__c = qsrMetricValue.Year_To_Date_Count__c + 1;
                        qsrMetricValue.Year_To_Date_Amount__c = qsrMetricValue.Year_To_Date_Amount__c + cwamt;
                        
                        qsrMetricOpp = new QSR_Metric_Opportunity__c();
                        qsrMetricOpp.Opportunity__c = op.Id;                            
                        qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue.Id;
                        qsrMetricOpp.Quarter__c= YTD;
                        allQsrMetricOpps.Add(qsrMetricOpp);
                    }
                }
                
                //If Opp Closed Won and Inf by Mkt
                if(QSRHelper.IsSourceMarketing(op.Last_Source__c))
                {
                    
                    qsrMetricValueExtId = 'MKTPF_' + NN_BB + '_OPP_CLOSED_WON_INF_BY_MKT_' + op.Product_Family__r.Name;
                    qsrMetricValue =  allQsrMetricValueMaps.get(qsrMetricValueExtId);
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    
                    if(ocq == CQ)
                    {
                        qsrMetricValue.Current_Quarter_Count__c= qsrMetricValue.Current_Quarter_Count__c + 1;
                        qsrMetricValue.Current_Quarter_Amount__c = qsrMetricValue.Current_Quarter_Amount__c + cwamt;
                        
                        qsrMetricOpp = new QSR_Metric_Opportunity__c();
                        qsrMetricOpp.Opportunity__c = op.Id;                            
                        qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue.Id;
                        qsrMetricOpp.Quarter__c= CQ;
                        allQsrMetricOpps.Add(qsrMetricOpp);
                    }
                    if(ocq == LQ1)
                    {                    
                        qsrMetricValue.Last_Quarter_Count__c= qsrMetricValue.Last_Quarter_Count__c + 1;
                        qsrMetricValue.Last_Quarter_Amount__c = qsrMetricValue.Last_Quarter_Amount__c + cwamt;
                        
                        qsrMetricOpp = new QSR_Metric_Opportunity__c();
                        qsrMetricOpp.Opportunity__c = op.Id;                            
                        qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue.Id;
                        qsrMetricOpp.Quarter__c= LQ1;
                        allQsrMetricOpps.Add(qsrMetricOpp);
                    }
                    if(ocq == LQ2)
                    {
                        qsrMetricValue.X2nd_Last_Quarter_Count__c= qsrMetricValue.X2nd_Last_Quarter_Count__c + 1;
                        qsrMetricValue.X2nd_Last_Quarter_Amount__c = qsrMetricValue.X2nd_Last_Quarter_Amount__c + cwamt; 
                        
                        qsrMetricOpp = new QSR_Metric_Opportunity__c();
                        qsrMetricOpp.Opportunity__c = op.Id;                            
                        qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue.Id;
                        qsrMetricOpp.Quarter__c= LQ2; 
                        allQsrMetricOpps.Add(qsrMetricOpp);                  
                    }
                    if(ocq == LQ3)
                    {
                        qsrMetricValue.X3rd_Last_Quarter_Count__c= qsrMetricValue.X3rd_Last_Quarter_Count__c + 1;
                        qsrMetricValue.X3rd_Last_Quarter_Amount__c = qsrMetricValue.X3rd_Last_Quarter_Amount__c + cwamt;
                        
                        qsrMetricOpp = new QSR_Metric_Opportunity__c();
                        qsrMetricOpp.Opportunity__c = op.Id;                            
                        qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue.Id;
                        qsrMetricOpp.Quarter__c= LQ3;
                        allQsrMetricOpps.Add(qsrMetricOpp);
                    }
                    if(ocq == LQ4)
                    {
                        qsrMetricValue.X4th_Last_Quarter_Count__c= qsrMetricValue.X4th_Last_Quarter_Count__c + 1;
                        qsrMetricValue.X4th_Last_Quarter_Amount__c = qsrMetricValue.X4th_Last_Quarter_Amount__c + cwamt;
                        
                        qsrMetricOpp = new QSR_Metric_Opportunity__c();
                        qsrMetricOpp.Opportunity__c = op.Id;                            
                        qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue.Id;
                        qsrMetricOpp.Quarter__c= LQ4;
                        allQsrMetricOpps.Add(qsrMetricOpp);
                    }
                    if(ocyear == tyear)
                    {
                        qsrMetricValue.Year_To_Date_Count__c = qsrMetricValue.Year_To_Date_Count__c + 1;
                        qsrMetricValue.Year_To_Date_Amount__c = qsrMetricValue.Year_To_Date_Amount__c + cwamt;
                        
                        qsrMetricOpp = new QSR_Metric_Opportunity__c();
                        qsrMetricOpp.Opportunity__c = op.Id;                            
                        qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue.Id;
                        qsrMetricOpp.Quarter__c= YTD;
                        allQsrMetricOpps.Add(qsrMetricOpp);
                    }
                }
            }
            
            //All Opps Closed - Nurture - Quarterwise
            if(op.StageName == 'Closed - Nurture')
            {         
                qsrMetricValueExtId = 'MKTPF_' + NN_BB + '_OPP_CLOSED_NURTURE_' + op.Product_Family__r.Name;
                qsrMetricValue =  allQsrMetricValueMaps.get(qsrMetricValueExtId);
                
                qsrMetricOpp = new QSR_Metric_Opportunity__c();
                
                if(ocq == CQ)
                {
                    qsrMetricValue.Current_Quarter_Count__c= qsrMetricValue.Current_Quarter_Count__c + 1;
                    qsrMetricValue.Current_Quarter_Amount__c = qsrMetricValue.Current_Quarter_Amount__c + cwamt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = op.Id;                            
                    qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue.Id;
                    qsrMetricOpp.Quarter__c= CQ;
                    allQsrMetricOpps.Add(qsrMetricOpp);
                }
                if(ocq == LQ1)
                {                    
                    qsrMetricValue.Last_Quarter_Count__c= qsrMetricValue.Last_Quarter_Count__c + 1;
                    qsrMetricValue.Last_Quarter_Amount__c = qsrMetricValue.Last_Quarter_Amount__c + cwamt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = op.Id;                            
                    qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue.Id;
                    qsrMetricOpp.Quarter__c= LQ1;
                    allQsrMetricOpps.Add(qsrMetricOpp);
                }
                if(ocq == LQ2)
                {
                    qsrMetricValue.X2nd_Last_Quarter_Count__c= qsrMetricValue.X2nd_Last_Quarter_Count__c + 1;
                    qsrMetricValue.X2nd_Last_Quarter_Amount__c = qsrMetricValue.X2nd_Last_Quarter_Amount__c + cwamt; 
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = op.Id;                            
                    qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue.Id;
                    qsrMetricOpp.Quarter__c= LQ2;   
                    allQsrMetricOpps.Add(qsrMetricOpp);                
                }
                if(ocq == LQ3)
                {
                    qsrMetricValue.X3rd_Last_Quarter_Count__c= qsrMetricValue.X3rd_Last_Quarter_Count__c + 1;
                    qsrMetricValue.X3rd_Last_Quarter_Amount__c = qsrMetricValue.X3rd_Last_Quarter_Amount__c + cwamt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = op.Id;                            
                    qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue.Id;
                    qsrMetricOpp.Quarter__c= LQ3;
                    allQsrMetricOpps.Add(qsrMetricOpp);
                }
                if(ocq == LQ4)
                {
                    qsrMetricValue.X4th_Last_Quarter_Count__c= qsrMetricValue.X4th_Last_Quarter_Count__c + 1;
                    qsrMetricValue.X4th_Last_Quarter_Amount__c = qsrMetricValue.X4th_Last_Quarter_Amount__c + cwamt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = op.Id;                            
                    qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue.Id;
                    qsrMetricOpp.Quarter__c= LQ4;
                    allQsrMetricOpps.Add(qsrMetricOpp);
                }
                if(ocyear == tyear)
                {
                    qsrMetricValue.Year_To_Date_Count__c = qsrMetricValue.Year_To_Date_Count__c + 1;
                    qsrMetricValue.Year_To_Date_Amount__c = qsrMetricValue.Year_To_Date_Amount__c + cwamt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = op.Id;                            
                    qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue.Id;
                    qsrMetricOpp.Quarter__c= YTD;
                    allQsrMetricOpps.Add(qsrMetricOpp);
                }
            }
            
            //All Opps Closed - Not Interested - Quarterwise
            //Closed - Not Interested
            if(op.StageName == 'Closed - Not Interested')
            {         
                qsrMetricValueExtId = 'MKTPF_' + NN_BB + '_OPP_CLOSED_INTERESTED_' + op.Product_Family__r.Name;
                qsrMetricValue =  allQsrMetricValueMaps.get(qsrMetricValueExtId);
                
                qsrMetricOpp = new QSR_Metric_Opportunity__c();
                
                if(ocq == CQ)
                {
                    qsrMetricValue.Current_Quarter_Count__c= qsrMetricValue.Current_Quarter_Count__c + 1;
                    qsrMetricValue.Current_Quarter_Amount__c = qsrMetricValue.Current_Quarter_Amount__c + cwamt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = op.Id;                            
                    qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue.Id;
                    qsrMetricOpp.Quarter__c= CQ;
                    allQsrMetricOpps.Add(qsrMetricOpp);
                }
                if(ocq == LQ1)
                {                    
                    qsrMetricValue.Last_Quarter_Count__c= qsrMetricValue.Last_Quarter_Count__c + 1;
                    qsrMetricValue.Last_Quarter_Amount__c = qsrMetricValue.Last_Quarter_Amount__c + cwamt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = op.Id;                            
                    qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue.Id;
                    qsrMetricOpp.Quarter__c= LQ1;
                    allQsrMetricOpps.Add(qsrMetricOpp);
                }
                if(ocq == LQ2)
                {
                    qsrMetricValue.X2nd_Last_Quarter_Count__c= qsrMetricValue.X2nd_Last_Quarter_Count__c + 1;
                    qsrMetricValue.X2nd_Last_Quarter_Amount__c = qsrMetricValue.X2nd_Last_Quarter_Amount__c + cwamt; 
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = op.Id;                            
                    qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue.Id;
                    qsrMetricOpp.Quarter__c= LQ2;   
                    allQsrMetricOpps.Add(qsrMetricOpp);                
                }
                if(ocq == LQ3)
                {
                    qsrMetricValue.X3rd_Last_Quarter_Count__c= qsrMetricValue.X3rd_Last_Quarter_Count__c + 1;
                    qsrMetricValue.X3rd_Last_Quarter_Amount__c = qsrMetricValue.X3rd_Last_Quarter_Amount__c + cwamt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = op.Id;                            
                    qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue.Id;
                    qsrMetricOpp.Quarter__c= LQ3;
                    allQsrMetricOpps.Add(qsrMetricOpp);
                }
                if(ocq == LQ4)
                {
                    qsrMetricValue.X4th_Last_Quarter_Count__c= qsrMetricValue.X4th_Last_Quarter_Count__c + 1;
                    qsrMetricValue.X4th_Last_Quarter_Amount__c = qsrMetricValue.X4th_Last_Quarter_Amount__c + cwamt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = op.Id;                            
                    qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue.Id;
                    qsrMetricOpp.Quarter__c= LQ4;
                    allQsrMetricOpps.Add(qsrMetricOpp);
                }
                if(ocyear == tyear)
                {
                    qsrMetricValue.Year_To_Date_Count__c = qsrMetricValue.Year_To_Date_Count__c + 1;
                    qsrMetricValue.Year_To_Date_Amount__c = qsrMetricValue.Year_To_Date_Amount__c + cwamt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = op.Id;                            
                    qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue.Id;
                    qsrMetricOpp.Quarter__c= YTD;
                    allQsrMetricOpps.Add(qsrMetricOpp);
                }
            }
            
            //All Opps Closed - Disqualified - Quarterwise
            if(op.StageName == 'Closed - Disqualified')
            {   
                qsrMetricValueExtId = 'MKTPF_' + NN_BB + '_OPP_CLOSED_DISQUALIFIED_' + op.Product_Family__r.Name;
                qsrMetricValue =  allQsrMetricValueMaps.get(qsrMetricValueExtId);
                
                qsrMetricOpp = new QSR_Metric_Opportunity__c();
                
                if(ocq == CQ)
                {
                    qsrMetricValue.Current_Quarter_Count__c= qsrMetricValue.Current_Quarter_Count__c + 1;
                    qsrMetricValue.Current_Quarter_Amount__c = qsrMetricValue.Current_Quarter_Amount__c + cwamt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = op.Id;                            
                    qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue.Id;
                    qsrMetricOpp.Quarter__c= CQ;
                    allQsrMetricOpps.Add(qsrMetricOpp);
                }
                if(ocq == LQ1)
                {                    
                    qsrMetricValue.Last_Quarter_Count__c= qsrMetricValue.Last_Quarter_Count__c + 1;
                    qsrMetricValue.Last_Quarter_Amount__c = qsrMetricValue.Last_Quarter_Amount__c + cwamt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = op.Id;                            
                    qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue.Id;
                    qsrMetricOpp.Quarter__c= LQ1;
                    allQsrMetricOpps.Add(qsrMetricOpp);
                }
                if(ocq == LQ2)
                {
                    qsrMetricValue.X2nd_Last_Quarter_Count__c= qsrMetricValue.X2nd_Last_Quarter_Count__c + 1;
                    qsrMetricValue.X2nd_Last_Quarter_Amount__c = qsrMetricValue.X2nd_Last_Quarter_Amount__c + cwamt; 
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = op.Id;                            
                    qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue.Id;
                    qsrMetricOpp.Quarter__c= LQ2;  
                    allQsrMetricOpps.Add(qsrMetricOpp);                 
                }
                if(ocq == LQ3)
                {
                    qsrMetricValue.X3rd_Last_Quarter_Count__c= qsrMetricValue.X3rd_Last_Quarter_Count__c + 1;
                    qsrMetricValue.X3rd_Last_Quarter_Amount__c = qsrMetricValue.X3rd_Last_Quarter_Amount__c + cwamt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = op.Id;                            
                    qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue.Id;
                    qsrMetricOpp.Quarter__c= LQ3;
                    allQsrMetricOpps.Add(qsrMetricOpp);
                }
                if(ocq == LQ4)
                {
                    qsrMetricValue.X4th_Last_Quarter_Count__c= qsrMetricValue.X4th_Last_Quarter_Count__c + 1;
                    qsrMetricValue.X4th_Last_Quarter_Amount__c = qsrMetricValue.X4th_Last_Quarter_Amount__c + cwamt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = op.Id;                            
                    qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue.Id;
                    qsrMetricOpp.Quarter__c= LQ4;
                    allQsrMetricOpps.Add(qsrMetricOpp);
                }
                if(ocyear == tyear)
                {
                    qsrMetricValue.Year_To_Date_Count__c = qsrMetricValue.Year_To_Date_Count__c + 1;
                    qsrMetricValue.Year_To_Date_Amount__c = qsrMetricValue.Year_To_Date_Amount__c + cwamt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = op.Id;                            
                    qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue.Id;
                    qsrMetricOpp.Quarter__c= YTD;
                    allQsrMetricOpps.Add(qsrMetricOpp);
                }
            }
            
        }
    }
    
    //Method to be called after the excute
    global void finish(Database.BatchableContext bc){
        //Add your start code for the other batch job here
        
        if(allQsrMetricValueMaps.values().size() > 0){
            List<Database.UpsertResult> qsrMetricValuesResult = Database.upsert( new List<QSR_Metric_Value__c>(allQsrMetricValueMaps.values()), QSR_Metric_Value__c.External_ID__c);
            system.debug('Method --> GenerateQSRReportMarketingByProductFamily' + NN_BB + '() --> Updated Value/Row = ' + qsrMetricValuesResult.size());                                
        }
        
        system.debug('Method --> GenerateQSRReportMarketingByProductFamily'+ NN_BB + '() --> Deleting = ');
        string forDeleteExistingOpp = 'MKTPF_' + NN_BB + '%';
        QSRReportsDeletionBatch2 qsrDeletionBatch = new QSRReportsDeletionBatch2(forDeleteExistingOpp);                
        Id deletionbatchId = Database.executeBatch(qsrDeletionBatch, 2000);
        system.debug('Method --> GenerateQSRReportMarketingByProductFamily'+ NN_BB + '() --> Del Started Batch Id = ' + string.valueOf(deletionbatchId));
        
        if(allQsrMetricOpps.size() > 0){                   
            
            system.debug('Method --> GenerateQSRReportMarketingByProductFamily'+ NN_BB + '() --> Adding New = ' + allQsrMetricOpps.size());  
            QSRReportsUpdaterBatch qsrUpdaterBatch = new QSRReportsUpdaterBatch(allQsrMetricOpps);                
            Id updaterbatchId = Database.executeBatch(qsrUpdaterBatch, 2000);
            system.debug('Method --> GenerateQSRReportMarketingByProductFamily'+ NN_BB + '() --> Started Batch Id = ' + string.valueOf(updaterbatchId));               
            
        }
    }
    
}