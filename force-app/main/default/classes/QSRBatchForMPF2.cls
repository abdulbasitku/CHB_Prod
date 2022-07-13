global class QSRBatchForMPF2 implements Database.Batchable<sObject>, Database.Stateful {
    
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
    
    global QSRBatchForMPF2(Date generationDate, boolean isNewBusiness, List<QSR_Metric_Opportunity__c> allQsrMetricOpps, Map<String, QSR_Metric_Value__c> allQsrMetricValueMaps)
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
                                                 AND (Createddate >= :ldt AND Createddate <= :tdt)]);
            }
            else 
            {
                return Database.getQueryLocator([Select Id, Name, Type, CHB_Amount__c, CreatedDate, CreatedById, StageName, CloseDate, First_Source__c, Last_Source__c, Product_Family__c,
                                                 Product_Family__r.Name, Product_Family__r.Business_Group__c, Product_Family__r.Business_Group__r.Name From Opportunity where Type != 'New Business' 
                                                 AND (Createddate >= :ldt AND Createddate <= :tdt)]);                
            }
        }        
    }
    
    //Method to execute the batch
    global void execute(Database.BatchableContext bc, List<sobject> opps){
        
        for(sobject sop : opps)
        {
            Opportunity op = (Opportunity) sop;
            //All Opps Created - Quarterwise
            Datetime odt = op.CreatedDate; 
            Integer omonth = odt.Month(); //get month
            Integer oyear = odt.Year(); //get year
            Double amt = 0;
            if(op.CHB_Amount__c != null)
            {
                amt = op.CHB_Amount__c;
            }
            
            string lq  = QSRHelper.GetOppQuarter (omonth, oyear, TQ, tyear, tmonth);
            if(op.Product_Family__c == null)
            {
                continue;
            }
            QSR_Metric_Opportunity__c qsrMetricOpp = new QSR_Metric_Opportunity__c();
            
            string qsrMetricValueExtId = 'MKTPF_' + NN_BB + '_OPP_CREATED_' + op.Product_Family__r.Name;
            QSR_Metric_Value__c qsrMetricValue =  allQsrMetricValueMaps.get(qsrMetricValueExtId);
            
            if(lq == CQ)
            {
                
                qsrMetricValue.Current_Quarter_Count__c= qsrMetricValue.Current_Quarter_Count__c + 1;
                qsrMetricValue.Current_Quarter_Amount__c = qsrMetricValue.Current_Quarter_Amount__c + amt;
                
                qsrMetricOpp = new QSR_Metric_Opportunity__c();
                qsrMetricOpp.Opportunity__c = op.Id;                            
                qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue.Id;
                qsrMetricOpp.Quarter__c= CQ;
                allQsrMetricOpps.Add(qsrMetricOpp);
            }
            if(lq == LQ1)
            {                    
                qsrMetricValue.Last_Quarter_Count__c= qsrMetricValue.Last_Quarter_Count__c + 1;
                qsrMetricValue.Last_Quarter_Amount__c = qsrMetricValue.Last_Quarter_Amount__c + amt;
                
                qsrMetricOpp = new QSR_Metric_Opportunity__c();
                qsrMetricOpp.Opportunity__c = op.Id;                            
                qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue.Id;
                qsrMetricOpp.Quarter__c= LQ1;
                allQsrMetricOpps.Add(qsrMetricOpp);
            }
            if(lq == LQ2)
            {
                qsrMetricValue.X2nd_Last_Quarter_Count__c= qsrMetricValue.X2nd_Last_Quarter_Count__c + 1;
                qsrMetricValue.X2nd_Last_Quarter_Amount__c = qsrMetricValue.X2nd_Last_Quarter_Amount__c + amt; 
                
                qsrMetricOpp = new QSR_Metric_Opportunity__c();
                qsrMetricOpp.Opportunity__c = op.Id;                            
                qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue.Id;
                qsrMetricOpp.Quarter__c= LQ2; 
                allQsrMetricOpps.Add(qsrMetricOpp);                  
            }
            if(lq == LQ3)
            {
                qsrMetricValue.X3rd_Last_Quarter_Count__c= qsrMetricValue.X3rd_Last_Quarter_Count__c + 1;
                qsrMetricValue.X3rd_Last_Quarter_Amount__c = qsrMetricValue.X3rd_Last_Quarter_Amount__c + amt;
                
                qsrMetricOpp = new QSR_Metric_Opportunity__c();
                qsrMetricOpp.Opportunity__c = op.Id;                            
                qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue.Id;
                qsrMetricOpp.Quarter__c= LQ3;
                allQsrMetricOpps.Add(qsrMetricOpp);
            }
            if(lq == LQ4)
            {
                qsrMetricValue.X4th_Last_Quarter_Count__c= qsrMetricValue.X4th_Last_Quarter_Count__c + 1;
                qsrMetricValue.X4th_Last_Quarter_Amount__c = qsrMetricValue.X4th_Last_Quarter_Amount__c + amt;
                
                qsrMetricOpp = new QSR_Metric_Opportunity__c();
                qsrMetricOpp.Opportunity__c = op.Id;                            
                qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue.Id;
                qsrMetricOpp.Quarter__c= LQ4;
                allQsrMetricOpps.Add(qsrMetricOpp);
            }
            if(oyear == tyear)
            {
                qsrMetricValue.Year_To_Date_Count__c = qsrMetricValue.Year_To_Date_Count__c + 1;
                qsrMetricValue.Year_To_Date_Amount__c = qsrMetricValue.Year_To_Date_Amount__c + amt;
                
                qsrMetricOpp = new QSR_Metric_Opportunity__c();
                qsrMetricOpp.Opportunity__c = op.Id;                            
                qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue.Id;
                qsrMetricOpp.Quarter__c= YTD;
                allQsrMetricOpps.Add(qsrMetricOpp);
            }
        }
    }
    
    //Method to be called after the excute
    global void finish(Database.BatchableContext bc){
        //Add your start code for the other batch job here
        Database.executeBatch(new QSRBatchForMPF3(generationDate, isNewBusiness, allQsrMetricOpps, allQsrMetricValueMaps));
    }
    
}