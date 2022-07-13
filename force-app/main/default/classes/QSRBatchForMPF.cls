global class QSRBatchForMPF implements Database.Batchable<sObject>, Database.Stateful {
    
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
            
    List<QSR_Metric_Opportunity__c> allQsrMetricOpps = new List<QSR_Metric_Opportunity__c>();
    Map<String, QSR_Metric_Value__c> allQsrMetricValueMaps = new  Map<String, QSR_Metric_Value__c>();
    
    global QSRBatchForMPF(Date generationDate, boolean isNewBusiness)
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
        
       
                
        QSR_Metric__c qsrMetric = new QSR_Metric__c();
        qsrMetric.External_ID__c = 'MKTPF_' + NN_BB;
        qsrMetric.Report_Date_Range__c = string.valueOf(tdt) + ' ==> ' + string.valueOf(ldt) + '| Generated On: ' + string.valueOf(Datetime.now()) ;
        if(isNewBusiness)
        {
            qsrMetric.Name = 'Marketing By Product Family - New Name';
        }
        else
        {
            qsrMetric.Name = 'Marketing By Product Family - Back to base';            
        }
        
        try
        {                                        
            Database.UpsertResult qsrMetricResult = Database.upsert(qsrMetric, QSR_Metric__c.External_ID__c);  
            qsrMetric.Id = qsrMetricResult.getId();
        }
        catch(DmlException e)
        {
            system.debug('Method --> GenerateQSRReportMarketing ' + NN_BB + '() --> DML Exception Occured post conversion DML');
            system.debug(e);
        }
        
        List<Product_Family__c> prodFamilies =  [Select Id, Name, Business_Group__c, Business_Group__r.Name From Product_Family__c];
        
        //make maps of prod fams
        List<QSR_Metric_Value__c> allQsrMetricValues = new List<QSR_Metric_Value__c>();
        
        
        for(Product_Family__c pf : prodFamilies)
        {         
            
            QSR_Metric_Value__c mktUql = new QSR_Metric_Value__c();
            mktUql.External_Id__c = 'MKTPF_' + NN_BB + '_UQL' + '_' + pf.Name;
            mktUql.Name = 'Unqualified';
            mktUql.Current_Quarter_Amount__c = 0;
            mktUql.Current_Quarter_Count__c = 0;
            mktUQL.Last_Quarter_Amount__c = 0;
            mktUql.Last_Quarter_Count__c = 0;
            mktUQL.X2nd_Last_Quarter_Amount__c = 0;
            mktUql.X2nd_Last_Quarter_Count__c = 0;
            mktUQL.X3rd_Last_Quarter_Amount__c = 0;
            mktUql.X3rd_Last_Quarter_Count__c = 0;
            mktUQL.X4th_Last_Quarter_Amount__c = 0;
            mktUql.X4th_Last_Quarter_Count__c = 0;
            mktUQL.Year_To_Date_Amount__c = 0;
            mktUql.Year_To_Date_Count__c = 0;
            mktUql.Sorting_Order__c = 1;
            mktUql.Category__c = 'Product Families';        
            mktUql.QSR_Metric__c = qsrMetric.Id;
            
            mktUql.Product_Family__c = pf.Id;
            mktUql.Product_Family_Name__c = pf.Name;
            mktUql.Business_Group__c = pf.Business_Group__c;
            if(pf.Business_Group__c != null)
            {
                mktUql.Business_Group_Name__c = pf.Business_Group__r.Name;
            }
            allQsrMetricValues.Add(mktUql);
            
            QSR_Metric_Value__c mktMql = new QSR_Metric_Value__c();
            mktMql.External_Id__c = 'MKTPF_' + NN_BB + '_MQL_' + pf.Name;
            mktMql.Name = 'Marketing Qualified';
            mktMql.Current_Quarter_Amount__c = 0;
            mktMql.Current_Quarter_Count__c = 0;
            mktMql.Last_Quarter_Amount__c = 0;
            mktMql.Last_Quarter_Count__c = 0;
            mktMql.X2nd_Last_Quarter_Amount__c = 0;
            mktMql.X2nd_Last_Quarter_Count__c = 0;
            mktMql.X3rd_Last_Quarter_Amount__c = 0;
            mktMql.X3rd_Last_Quarter_Count__c = 0;
            mktMql.X4th_Last_Quarter_Amount__c = 0;
            mktMql.X4th_Last_Quarter_Count__c = 0;
            mktMql.Year_To_Date_Amount__c = 0;
            mktMql.Year_To_Date_Count__c = 0;
            mktMql.Sorting_Order__c = 2;
            mktMql.Category__c = 'Product Families'; 
            mktMql.QSR_Metric__c = qsrMetric.Id;
            
            mktMql.Product_Family__c = pf.Id;
            mktMql.Product_Family_Name__c = pf.Name;
            mktMql.Business_Group__c = pf.Business_Group__c;
            if(pf.Business_Group__c != null)
            {
                mktMql.Business_Group_Name__c = pf.Business_Group__r.Name;
            }
            allQsrMetricValues.Add(mktMql);
            
            QSR_Metric_Value__c mktCSql = new QSR_Metric_Value__c();
            mktCSql.External_Id__c = 'MKTPF_' + NN_BB + '_C-SQL' + '_' + pf.Name;
            mktCSql.Name = 'Confirmed - SQL';
            mktCSql.Current_Quarter_Amount__c = 0;
            mktCSql.Current_Quarter_Count__c = 0;
            mktCSql.Last_Quarter_Amount__c = 0;
            mktCSql.Last_Quarter_Count__c = 0;
            mktCSql.X2nd_Last_Quarter_Amount__c = 0;
            mktCSql.X2nd_Last_Quarter_Count__c = 0;
            mktCSql.X3rd_Last_Quarter_Amount__c = 0;
            mktCSql.X3rd_Last_Quarter_Count__c = 0;
            mktCSql.X4th_Last_Quarter_Amount__c = 0;
            mktCSql.X4th_Last_Quarter_Count__c = 0;
            mktCSql.Year_To_Date_Amount__c = 0;
            mktCSql.Year_To_Date_Count__c = 0;
            mktCSql.Sorting_Order__c = 3;
            mktCSql.Category__c = 'Product Families'; 
            mktCSql.QSR_Metric__c = qsrMetric.Id;
            
            mktCSql.Product_Family__c = pf.Id;
            mktCSql.Product_Family_Name__c = pf.Name;
            mktCSql.Business_Group__c = pf.Business_Group__c;
            if(pf.Business_Group__c != null)
            {
                mktCSql.Business_Group_Name__c = pf.Business_Group__r.Name;
            }
            allQsrMetricValues.Add(mktCSql);
            
            QSR_Metric_Value__c mktOppCreated = new QSR_Metric_Value__c();
            mktOppCreated.External_Id__c = 'MKTPF_' + NN_BB + '_OPP_CREATED' + '_' + pf.Name;
            mktOppCreated.Name = 'Opportunities Created';
            mktOppCreated.Current_Quarter_Amount__c = 0;
            mktOppCreated.Current_Quarter_Count__c = 0;
            mktOppCreated.Last_Quarter_Amount__c = 0;
            mktOppCreated.Last_Quarter_Count__c = 0;
            mktOppCreated.X2nd_Last_Quarter_Amount__c = 0;
            mktOppCreated.X2nd_Last_Quarter_Count__c = 0;
            mktOppCreated.X3rd_Last_Quarter_Amount__c = 0;
            mktOppCreated.X3rd_Last_Quarter_Count__c = 0;
            mktOppCreated.X4th_Last_Quarter_Amount__c = 0;
            mktOppCreated.X4th_Last_Quarter_Count__c = 0;
            mktOppCreated.Year_To_Date_Amount__c = 0;
            mktOppCreated.Year_To_Date_Count__c = 0;
            mktOppCreated.Sorting_Order__c = 4;
            mktOppCreated.Category__c = 'Product Families'; 
            mktOppCreated.QSR_Metric__c = qsrMetric.Id;
            
            mktOppCreated.Product_Family__c = pf.Id;
            mktOppCreated.Product_Family_Name__c = pf.Name;
            mktOppCreated.Business_Group__c = pf.Business_Group__c;
            if(pf.Business_Group__c != null)
            {
                mktOppCreated.Business_Group_Name__c = pf.Business_Group__r.Name;
            }        
            allQsrMetricValues.Add(mktOppCreated);
            
            QSR_Metric_Value__c mktOppClosedWon = new QSR_Metric_Value__c();
            mktOppClosedWon.External_Id__c = 'MKTPF_' + NN_BB + '_OPP_CLOSED_WON' + '_' + pf.Name;
            mktOppClosedWon.Name = 'Opportunities Closed Won';
            mktOppClosedWon.Current_Quarter_Amount__c = 0;
            mktOppClosedWon.Current_Quarter_Count__c = 0;
            mktOppClosedWon.Last_Quarter_Amount__c = 0;
            mktOppClosedWon.Last_Quarter_Count__c = 0;
            mktOppClosedWon.X2nd_Last_Quarter_Amount__c = 0;
            mktOppClosedWon.X2nd_Last_Quarter_Count__c = 0;
            mktOppClosedWon.X3rd_Last_Quarter_Amount__c = 0;
            mktOppClosedWon.X3rd_Last_Quarter_Count__c = 0;
            mktOppClosedWon.X4th_Last_Quarter_Amount__c = 0;
            mktOppClosedWon.X4th_Last_Quarter_Count__c = 0;
            mktOppClosedWon.Year_To_Date_Amount__c = 0;
            mktOppClosedWon.Year_To_Date_Count__c = 0;
            mktOppClosedWon.Sorting_Order__c = 5;
            mktOppClosedWon.Category__c = 'Product Families'; 
            mktOppClosedWon.QSR_Metric__c = qsrMetric.Id;
            
            mktOppClosedWon.Product_Family__c = pf.Id;
            mktOppClosedWon.Product_Family_Name__c = pf.Name;
            mktOppClosedWon.Business_Group__c = pf.Business_Group__c;
            if(pf.Business_Group__c != null)
            {
                mktOppClosedWon.Business_Group_Name__c = pf.Business_Group__r.Name;
            }                
            allQsrMetricValues.Add(mktOppClosedWon);
            
            QSR_Metric_Value__c mktOppClosedWonGenByMkt = new QSR_Metric_Value__c();
            mktOppClosedWonGenByMkt.External_Id__c = 'MKTPF_' + NN_BB + '_OPP_CLOSED_WON_GEN_BY_MKT' + '_' + pf.Name;
            mktOppClosedWonGenByMkt.Name = 'Opportunities Closed Won - Generated By Marketing';
            mktOppClosedWonGenByMkt.Current_Quarter_Amount__c = 0;
            mktOppClosedWonGenByMkt.Current_Quarter_Count__c = 0;
            mktOppClosedWonGenByMkt.Last_Quarter_Amount__c = 0;
            mktOppClosedWonGenByMkt.Last_Quarter_Count__c = 0;
            mktOppClosedWonGenByMkt.X2nd_Last_Quarter_Amount__c = 0;
            mktOppClosedWonGenByMkt.X2nd_Last_Quarter_Count__c = 0;
            mktOppClosedWonGenByMkt.X3rd_Last_Quarter_Amount__c = 0;
            mktOppClosedWonGenByMkt.X3rd_Last_Quarter_Count__c = 0;
            mktOppClosedWonGenByMkt.X4th_Last_Quarter_Amount__c = 0;
            mktOppClosedWonGenByMkt.X4th_Last_Quarter_Count__c = 0;
            mktOppClosedWonGenByMkt.Year_To_Date_Amount__c = 0;
            mktOppClosedWonGenByMkt.Year_To_Date_Count__c = 0;
            mktOppClosedWonGenByMkt.Sorting_Order__c = 6;
            mktOppClosedWonGenByMkt.Category__c = 'Product Families'; 
            mktOppClosedWonGenByMkt.QSR_Metric__c = qsrMetric.Id; 
            
            mktOppClosedWonGenByMkt.Product_Family__c = pf.Id;
            mktOppClosedWonGenByMkt.Product_Family_Name__c = pf.Name;
            mktOppClosedWonGenByMkt.Business_Group__c = pf.Business_Group__c;
            if(pf.Business_Group__c != null)
            {
                mktOppClosedWonGenByMkt.Business_Group_Name__c = pf.Business_Group__r.Name;
            }                       
            allQsrMetricValues.Add(mktOppClosedWonGenByMkt);
            
            QSR_Metric_Value__c mktOppClosedWonInfByMkt = new QSR_Metric_Value__c();
            mktOppClosedWonInfByMkt.External_Id__c = 'MKTPF_' + NN_BB + '_OPP_CLOSED_WON_INF_BY_MKT' + '_' + pf.Name;
            mktOppClosedWonInfByMkt.Name = 'Opportunities Closed Won - Influenced By Marketing';
            mktOppClosedWonInfByMkt.Current_Quarter_Amount__c = 0;
            mktOppClosedWonInfByMkt.Current_Quarter_Count__c = 0;
            mktOppClosedWonInfByMkt.Last_Quarter_Amount__c = 0;
            mktOppClosedWonInfByMkt.Last_Quarter_Count__c = 0;
            mktOppClosedWonInfByMkt.X2nd_Last_Quarter_Amount__c = 0;
            mktOppClosedWonInfByMkt.X2nd_Last_Quarter_Count__c = 0;
            mktOppClosedWonInfByMkt.X3rd_Last_Quarter_Amount__c = 0;
            mktOppClosedWonInfByMkt.X3rd_Last_Quarter_Count__c = 0;
            mktOppClosedWonInfByMkt.X4th_Last_Quarter_Amount__c = 0;
            mktOppClosedWonInfByMkt.X4th_Last_Quarter_Count__c = 0;
            mktOppClosedWonInfByMkt.Year_To_Date_Amount__c = 0;
            mktOppClosedWonInfByMkt.Year_To_Date_Count__c = 0;
            mktOppClosedWonInfByMkt.Sorting_Order__c = 7;
            mktOppClosedWonInfByMkt.Category__c = 'Product Families'; 
            mktOppClosedWonInfByMkt.QSR_Metric__c = qsrMetric.Id; 
            
            mktOppClosedWonInfByMkt.Product_Family__c = pf.Id;
            mktOppClosedWonInfByMkt.Product_Family_Name__c = pf.Name;
            mktOppClosedWonInfByMkt.Business_Group__c = pf.Business_Group__c;
            if(pf.Business_Group__c != null)
            {
                mktOppClosedWonInfByMkt.Business_Group_Name__c = pf.Business_Group__r.Name;
            }                              
            allQsrMetricValues.Add(mktOppClosedWonInfByMkt);
            
            QSR_Metric_Value__c mktOppClosedNurture = new QSR_Metric_Value__c();
            mktOppClosedNurture.External_Id__c = 'MKTPF_' + NN_BB + '_OPP_CLOSED_NURTURE' + '_' + pf.Name;
            mktOppClosedNurture.Name = 'Opportunities Closed - Nurture';
            mktOppClosedNurture.Current_Quarter_Amount__c = 0;
            mktOppClosedNurture.Current_Quarter_Count__c = 0;
            mktOppClosedNurture.Last_Quarter_Amount__c = 0;
            mktOppClosedNurture.Last_Quarter_Count__c = 0;
            mktOppClosedNurture.X2nd_Last_Quarter_Amount__c = 0;
            mktOppClosedNurture.X2nd_Last_Quarter_Count__c = 0;
            mktOppClosedNurture.X3rd_Last_Quarter_Amount__c = 0;
            mktOppClosedNurture.X3rd_Last_Quarter_Count__c = 0;
            mktOppClosedNurture.X4th_Last_Quarter_Amount__c = 0;
            mktOppClosedNurture.X4th_Last_Quarter_Count__c = 0;
            mktOppClosedNurture.Year_To_Date_Amount__c = 0;
            mktOppClosedNurture.Year_To_Date_Count__c = 0;
            mktOppClosedNurture.Sorting_Order__c = 8;
            mktOppClosedNurture.Category__c = 'Product Families'; 
            mktOppClosedNurture.QSR_Metric__c = qsrMetric.Id;
            
            mktOppClosedNurture.Product_Family__c = pf.Id;
            mktOppClosedNurture.Product_Family_Name__c = pf.Name;
            mktOppClosedNurture.Business_Group__c = pf.Business_Group__c;
            if(pf.Business_Group__c != null)
            {
                mktOppClosedNurture.Business_Group_Name__c = pf.Business_Group__r.Name;
            }                                      
            allQsrMetricValues.Add(mktOppClosedNurture);
            
            QSR_Metric_Value__c mktOppClosedNotInterested = new QSR_Metric_Value__c();
            mktOppClosedNotInterested.External_Id__c = 'MKTPF_' + NN_BB + '_OPP_CLOSED_INTERESTED' + '_' + pf.Name;
            mktOppClosedNotInterested.Name = 'Opportunities Closed - Not Interested';
            mktOppClosedNotInterested.Current_Quarter_Amount__c = 0;
            mktOppClosedNotInterested.Current_Quarter_Count__c = 0;
            mktOppClosedNotInterested.Last_Quarter_Amount__c = 0;
            mktOppClosedNotInterested.Last_Quarter_Count__c = 0;
            mktOppClosedNotInterested.X2nd_Last_Quarter_Amount__c = 0;
            mktOppClosedNotInterested.X2nd_Last_Quarter_Count__c = 0;
            mktOppClosedNotInterested.X3rd_Last_Quarter_Amount__c = 0;
            mktOppClosedNotInterested.X3rd_Last_Quarter_Count__c = 0;
            mktOppClosedNotInterested.X4th_Last_Quarter_Amount__c = 0;
            mktOppClosedNotInterested.X4th_Last_Quarter_Count__c = 0;
            mktOppClosedNotInterested.Year_To_Date_Amount__c = 0;
            mktOppClosedNotInterested.Year_To_Date_Count__c = 0;
            mktOppClosedNotInterested.Sorting_Order__c = 9;
            mktOppClosedNotInterested.Category__c = 'Product Families'; 
            mktOppClosedNotInterested.QSR_Metric__c = qsrMetric.Id;
            
            mktOppClosedNotInterested.Product_Family__c = pf.Id;
            mktOppClosedNotInterested.Product_Family_Name__c = pf.Name;
            mktOppClosedNotInterested.Business_Group__c = pf.Business_Group__c;
            if(pf.Business_Group__c != null)
            {
                mktOppClosedNotInterested.Business_Group_Name__c = pf.Business_Group__r.Name;
            }                                              
            allQsrMetricValues.Add(mktOppClosedNotInterested);
            
            QSR_Metric_Value__c mktOppClosedDisqualified = new QSR_Metric_Value__c();
            mktOppClosedDisqualified.External_Id__c = 'MKTPF_' + NN_BB + '_OPP_CLOSED_DISQUALIFIED' + '_' + pf.Name;
            mktOppClosedDisqualified.Name = 'Opportunities Closed - Disqualified';
            mktOppClosedDisqualified.Current_Quarter_Amount__c = 0;
            mktOppClosedDisqualified.Current_Quarter_Count__c = 0;
            mktOppClosedDisqualified.Last_Quarter_Amount__c = 0;
            mktOppClosedDisqualified.Last_Quarter_Count__c = 0;
            mktOppClosedDisqualified.X2nd_Last_Quarter_Amount__c = 0;
            mktOppClosedDisqualified.X2nd_Last_Quarter_Count__c = 0;
            mktOppClosedDisqualified.X3rd_Last_Quarter_Amount__c = 0;
            mktOppClosedDisqualified.X3rd_Last_Quarter_Count__c = 0;
            mktOppClosedDisqualified.X4th_Last_Quarter_Amount__c = 0;
            mktOppClosedDisqualified.X4th_Last_Quarter_Count__c = 0;
            mktOppClosedDisqualified.Year_To_Date_Amount__c = 0;
            mktOppClosedDisqualified.Year_To_Date_Count__c = 0;
            mktOppClosedDisqualified.Sorting_Order__c = 10;
            mktOppClosedDisqualified.Category__c = 'Product Families'; 
            mktOppClosedDisqualified.QSR_Metric__c = qsrMetric.Id;
            
            mktOppClosedDisqualified.Product_Family__c = pf.Id;
            mktOppClosedDisqualified.Product_Family_Name__c = pf.Name;
            mktOppClosedDisqualified.Business_Group__c = pf.Business_Group__c;
            if(pf.Business_Group__c != null)
            {
                mktOppClosedDisqualified.Business_Group_Name__c = pf.Business_Group__r.Name;
            }                                                      
            allQsrMetricValues.Add(mktOppClosedDisqualified);
        }
        
        
        try
        {                            
            if(allQsrMetricValues.size() > 0){
                List<Database.UpsertResult> qsrMetricValuesResult = Database.upsert( new List<QSR_Metric_Value__c>(allQsrMetricValues), QSR_Metric_Value__c.External_ID__c); 
                system.debug('Method --> GenerateQSRReportMarketingByProductFamily'+ NN_BB + '() --> Upserting QSR Value/Row = ' + qsrMetricValuesResult.size());                       
            }            
        }
        catch(DmlException e)
        {
            system.debug('Method --> GenerateQSRReportMarketingByProductFamily' + NN_BB + '() --> DML Exception Occured post conversion DML');
            system.debug(e);
        }  
        
        for(QSR_Metric_Value__c qsrMetricValue : allQsrMetricValues)
        {
            allQsrMetricValueMaps.put(qsrMetricValue.External_Id__c, qsrMetricValue);
        }
        
        /*if(Test.isRunningTest())
        {
            //allOppStageHistory = allOppStageHistoryTest;            
        }
        else*/
        {
            if(isNewBusiness)
            {
                
                return Database.getQueryLocator([Select OpportunityId, Opportunity.Name, Opportunity.Type, Opportunity.CHB_Amount__c,Opportunity.Product_Family__c,Opportunity.Product_Family__r.Name, OldValue, NewValue, 
                                                 IsDeleted, Id, Field, CreatedDate, CreatedById From OpportunityFieldHistory 
                                                 where (Field = 'opportunityCreatedFromLead' OR Field = 'created' OR Field = 'StageName') AND Opportunity.Type = 'New Business' AND 
                                                 IsDeleted = false AND (Createddate >= :ldt AND Createddate <= :tdt)]);
            }
            else 
            {
                return Database.getQueryLocator([Select OpportunityId, Opportunity.Name, Opportunity.Type, Opportunity.CHB_Amount__c,Opportunity.Product_Family__c,Opportunity.Product_Family__r.Name, OldValue, NewValue, 
                                                 IsDeleted, Id, Field, CreatedDate, CreatedById From OpportunityFieldHistory 
                                                 where (Field = 'opportunityCreatedFromLead' OR Field = 'created' OR Field = 'StageName') AND Opportunity.Type != 'New Business' AND 
                                                 IsDeleted = false AND (Createddate >= :ldt AND Createddate <= :tdt)]);                
            }
        }        
    }
    
    //Method to execute the batch
    global void execute(Database.BatchableContext bc, List<sobject> allOppStageHistory){
        
        for(sobject sofh : allOppStageHistory)
        {
            OpportunityFieldHistory ofh = (OpportunityFieldHistory)sofh;
            Datetime odt = ofh.CreatedDate;
            Integer omonth = odt.Month(); //get month
            Integer oyear = odt.Year(); //get year
            
            string lq  = QSRHelper.GetOppQuarter(omonth, oyear, TQ, tyear, tmonth);
            double ofhOppAmt = 0;
            if(ofh.Opportunity.CHB_Amount__c != null)
            {
                ofhOppAmt = ofh.Opportunity.CHB_Amount__c;
            }
            if(ofh.Opportunity.Product_Family__c == null)
            {
                continue;
            }
            QSR_Metric_Opportunity__c qsrMetricOpp = new QSR_Metric_Opportunity__c();
            
            if(ofh.NewValue == Unqualified || ofh.Field == 'opportunityCreatedFromLead' || ofh.Field == 'created')
            {                     
                string qsrMetricValueExtId = 'MKTPF_' + NN_BB + '_UQL_' + ofh.Opportunity.Product_Family__r.Name;
                QSR_Metric_Value__c qsrMetricValue =  allQsrMetricValueMaps.get(qsrMetricValueExtId);
                
                if(lq == CQ)
                {
                    qsrMetricValue.Current_Quarter_Count__c= qsrMetricValue.Current_Quarter_Count__c + 1;
                    qsrMetricValue.Current_Quarter_Amount__c = qsrMetricValue.Current_Quarter_Amount__c + ofhOppAmt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = ofh.OpportunityId;                            
                    qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue.Id;
                    qsrMetricOpp.Quarter__c  = CQ;
                    allQsrMetricOpps.Add(qsrMetricOpp);
                }
                if(lq == LQ1)
                {                    
                    qsrMetricValue.Last_Quarter_Count__c= qsrMetricValue.Last_Quarter_Count__c + 1;
                    qsrMetricValue.Last_Quarter_Amount__c = qsrMetricValue.Last_Quarter_Amount__c + ofhOppAmt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = ofh.OpportunityId;                            
                    qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue.Id;
                    qsrMetricOpp.Quarter__c = LQ1;
                    allQsrMetricOpps.Add(qsrMetricOpp);
                }
                if(lq == LQ2)
                {
                    qsrMetricValue.X2nd_Last_Quarter_Count__c= qsrMetricValue.X2nd_Last_Quarter_Count__c + 1;
                    qsrMetricValue.X2nd_Last_Quarter_Amount__c = qsrMetricValue.X2nd_Last_Quarter_Amount__c + ofhOppAmt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = ofh.OpportunityId;                            
                    qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue.Id;
                    qsrMetricOpp.Quarter__c = LQ2;
                    allQsrMetricOpps.Add(qsrMetricOpp);                    
                }
                if(lq == LQ3)
                {
                    qsrMetricValue.X3rd_Last_Quarter_Count__c= qsrMetricValue.X3rd_Last_Quarter_Count__c + 1;
                    qsrMetricValue.X3rd_Last_Quarter_Amount__c = qsrMetricValue.X3rd_Last_Quarter_Amount__c + ofhOppAmt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = ofh.OpportunityId;                            
                    qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue.Id;
                    qsrMetricOpp.Quarter__c = LQ3;
                    allQsrMetricOpps.Add(qsrMetricOpp);
                }
                if(lq == LQ4)
                {
                    qsrMetricValue.X4th_Last_Quarter_Count__c= qsrMetricValue.X4th_Last_Quarter_Count__c + 1;
                    qsrMetricValue.X4th_Last_Quarter_Amount__c = qsrMetricValue.X4th_Last_Quarter_Amount__c + ofhOppAmt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = ofh.OpportunityId;                            
                    qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue.Id;
                    qsrMetricOpp.Quarter__c = LQ4;
                    allQsrMetricOpps.Add(qsrMetricOpp);
                }
                if(oyear == tyear)
                {
                    qsrMetricValue.Year_To_Date_Count__c= qsrMetricValue.Year_To_Date_Count__c + 1;
                    qsrMetricValue.Year_To_Date_Amount__c = qsrMetricValue.Year_To_Date_Amount__c + ofhOppAmt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = ofh.OpportunityId;                            
                    qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue.Id;
                    qsrMetricOpp.Quarter__c = YTD;
                    allQsrMetricOpps.Add(qsrMetricOpp);
                }
            }
            
            if(ofh.NewValue == Marketing_Qualified)
            {
                string qsrMetricValueExtId = 'MKTPF_' + NN_BB + '_MQL_' + ofh.Opportunity.Product_Family__r.Name;
                QSR_Metric_Value__c qsrMetricValue =  allQsrMetricValueMaps.get(qsrMetricValueExtId);
                
                if(lq == CQ)
                {
                    qsrMetricValue.Current_Quarter_Count__c= qsrMetricValue.Current_Quarter_Count__c + 1;
                    qsrMetricValue.Current_Quarter_Amount__c = qsrMetricValue.Current_Quarter_Amount__c + ofhOppAmt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = ofh.OpportunityId;                            
                    qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue.Id;
                    qsrMetricOpp.Quarter__c = CQ;
                    allQsrMetricOpps.Add(qsrMetricOpp);
                }
                if(lq == LQ1)
                {                    
                    qsrMetricValue.Last_Quarter_Count__c= qsrMetricValue.Last_Quarter_Count__c + 1;
                    qsrMetricValue.Last_Quarter_Amount__c = qsrMetricValue.Last_Quarter_Amount__c + ofhOppAmt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = ofh.OpportunityId;                            
                    qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue.Id;
                    qsrMetricOpp.Quarter__c = LQ1;
                    allQsrMetricOpps.Add(qsrMetricOpp);
                }
                if(lq == LQ2)
                {
                    qsrMetricValue.X2nd_Last_Quarter_Count__c= qsrMetricValue.X2nd_Last_Quarter_Count__c + 1;
                    qsrMetricValue.X2nd_Last_Quarter_Amount__c = qsrMetricValue.X2nd_Last_Quarter_Amount__c + ofhOppAmt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = ofh.OpportunityId;                            
                    qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue.Id;
                    qsrMetricOpp.Quarter__c = LQ2;
                    allQsrMetricOpps.Add(qsrMetricOpp);                    
                }
                if(lq == LQ3)
                {
                    qsrMetricValue.X3rd_Last_Quarter_Count__c= qsrMetricValue.X3rd_Last_Quarter_Count__c + 1;
                    qsrMetricValue.X3rd_Last_Quarter_Amount__c = qsrMetricValue.X3rd_Last_Quarter_Amount__c + ofhOppAmt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = ofh.OpportunityId;                            
                    qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue.Id;
                    qsrMetricOpp.Quarter__c = LQ3;
                    allQsrMetricOpps.Add(qsrMetricOpp);
                }
                if(lq == LQ4)
                {
                    qsrMetricValue.X4th_Last_Quarter_Count__c= qsrMetricValue.X4th_Last_Quarter_Count__c + 1;
                    qsrMetricValue.X4th_Last_Quarter_Amount__c = qsrMetricValue.X4th_Last_Quarter_Amount__c + ofhOppAmt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = ofh.OpportunityId;                            
                    qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue.Id;
                    qsrMetricOpp.Quarter__c = LQ4;
                    allQsrMetricOpps.Add(qsrMetricOpp);
                }
                if(oyear == tyear)
                {
                    qsrMetricValue.Year_To_Date_Count__c= qsrMetricValue.Year_To_Date_Count__c + 1;
                    qsrMetricValue.Year_To_Date_Amount__c = qsrMetricValue.Year_To_Date_Amount__c + ofhOppAmt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = ofh.OpportunityId;                            
                    qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue.Id;
                    qsrMetricOpp.Quarter__c = YTD;
                    allQsrMetricOpps.Add(qsrMetricOpp);
                } 
            }
            
            if(ofh.NewValue == Confirmed_SQL)
            {                        
                string qsrMetricValueExtId = 'MKTPF_' + NN_BB + '_C-SQL_' + ofh.Opportunity.Product_Family__r.Name;
                QSR_Metric_Value__c qsrMetricValue =  allQsrMetricValueMaps.get(qsrMetricValueExtId);
                
                if(lq == CQ)
                {
                    qsrMetricValue.Current_Quarter_Count__c= qsrMetricValue.Current_Quarter_Count__c + 1;
                    qsrMetricValue.Current_Quarter_Amount__c = qsrMetricValue.Current_Quarter_Amount__c + ofhOppAmt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = ofh.OpportunityId;                            
                    qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue.Id;
                    qsrMetricOpp.Quarter__c = CQ;
                    allQsrMetricOpps.Add(qsrMetricOpp);
                }
                if(lq == LQ1)
                {                    
                    qsrMetricValue.Last_Quarter_Count__c= qsrMetricValue.Last_Quarter_Count__c + 1;
                    qsrMetricValue.Last_Quarter_Amount__c = qsrMetricValue.Last_Quarter_Amount__c + ofhOppAmt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = ofh.OpportunityId;                            
                    qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue.Id;
                    qsrMetricOpp.Quarter__c = LQ1;
                    allQsrMetricOpps.Add(qsrMetricOpp);
                }
                if(lq == LQ2)
                {
                    qsrMetricValue.X2nd_Last_Quarter_Count__c= qsrMetricValue.X2nd_Last_Quarter_Count__c + 1;
                    qsrMetricValue.X2nd_Last_Quarter_Amount__c = qsrMetricValue.X2nd_Last_Quarter_Amount__c + ofhOppAmt; 
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = ofh.OpportunityId;                            
                    qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue.Id;
                    qsrMetricOpp.Quarter__c = LQ2; 
                    allQsrMetricOpps.Add(qsrMetricOpp);                  
                }
                if(lq == LQ3)
                {
                    qsrMetricValue.X3rd_Last_Quarter_Count__c= qsrMetricValue.X3rd_Last_Quarter_Count__c + 1;
                    qsrMetricValue.X3rd_Last_Quarter_Amount__c = qsrMetricValue.X3rd_Last_Quarter_Amount__c + ofhOppAmt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = ofh.OpportunityId;                            
                    qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue.Id;
                    qsrMetricOpp.Quarter__c = LQ3;
                    allQsrMetricOpps.Add(qsrMetricOpp);
                }
                if(lq == LQ4)
                {
                    qsrMetricValue.X4th_Last_Quarter_Count__c= qsrMetricValue.X4th_Last_Quarter_Count__c + 1;
                    qsrMetricValue.X4th_Last_Quarter_Amount__c = qsrMetricValue.X4th_Last_Quarter_Amount__c + ofhOppAmt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = ofh.OpportunityId;                            
                    qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue.Id;
                    qsrMetricOpp.Quarter__c = LQ4;
                    allQsrMetricOpps.Add(qsrMetricOpp);
                }
                if(oyear == tyear)
                {
                    qsrMetricValue.Year_To_Date_Count__c= qsrMetricValue.Year_To_Date_Count__c + 1;
                    qsrMetricValue.Year_To_Date_Amount__c = qsrMetricValue.Year_To_Date_Amount__c + ofhOppAmt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = ofh.OpportunityId;                            
                    qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue.Id;
                    qsrMetricOpp.Quarter__c = YTD;
                    allQsrMetricOpps.Add(qsrMetricOpp);
                }
                
            } 
            
        }
    }
    
    //Method to be called after the excute
    global void finish(Database.BatchableContext bc){
        //Add your start code for the other batch job here
        Database.executeBatch(new QSRBatchForMPF2(generationDate, isNewBusiness, allQsrMetricOpps, allQsrMetricValueMaps));
        //Database.executeBatch(new Batch2());
}
    
}