public class QSRReports {
    
    
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
    
    public QSRReports(Date generationDate)
    {
        this.tdt = GetQuarterLastDate(generationDate);
        system.debug('Input Date Quarter - Last Date: ' + tdt);
        tmonth = tdt.Month(); //get month
        system.debug('Input Month: ' + tmonth);
        tyear = tdt.Year(); //get year
        system.debug('Input Year: ' + tyear);
        qsdt = GetQuarterStartDate();
        system.debug('Input Date Quarter - Start Date: ' + qsdt);
        ldt = qsdt.addYears(-1);
        system.debug('Last Date: ' + ldt);
    }
    
    /*---------Marketing Report Region Start--------------*/
    
    public void GenerateQSRReportMarketing(List<OpportunityFieldHistory> allOppStageHistoryTest, boolean isNewBusiness)
    {
        system.debug('Method --> GenerateQSRReportMarketing() --> Start');
        
        system.debug('Input Date: ' + tdt);
        TQ = GetQuarterByMonth(tmonth);
        system.debug('Input Date Quarter: ' +TQ);
        
        List<OpportunityFieldHistory> allOppStageHistory;
        
        string NN_BB = '';
        if(isNewBusiness)
        {
            NN_BB = 'NN';
        }
        else
        {
            NN_BB = 'BB';
        }
        
        if(Test.isRunningTest())
        {
            allOppStageHistory = allOppStageHistoryTest;
            
        }
        else
        {
            if(isNewBusiness)
            {
                allOppStageHistory = [Select OpportunityId, Opportunity.Name, Opportunity.Type, Opportunity.CHB_Amount__c,Opportunity.Product_Family__c,Opportunity.Product_Family__r.Name, OldValue, NewValue, 
                                      IsDeleted, Id, Field, CreatedDate, CreatedById From OpportunityFieldHistory 
                                      where (Field = 'opportunityCreatedFromLead' OR Field = 'created' OR Field = 'StageName') AND Opportunity.Type = 'New Business' AND 
                                      IsDeleted = false AND (Createddate >= :ldt AND Createddate <= :tdt)];
            }
            else 
            {
                allOppStageHistory = [Select OpportunityId, Opportunity.Name, Opportunity.Type, Opportunity.CHB_Amount__c,Opportunity.Product_Family__c,Opportunity.Product_Family__r.Name, OldValue, NewValue, 
                                      IsDeleted, Id, Field, CreatedDate, CreatedById From OpportunityFieldHistory 
                                      where (Field = 'opportunityCreatedFromLead' OR Field = 'created' OR Field = 'StageName') AND Opportunity.Type != 'New Business' AND 
                                      IsDeleted = false AND (Createddate >= :ldt AND Createddate <= :tdt)];
            }
        }
      
        system.debug('Method --> GenerateQSRReportMarketing ' + NN_BB + '() --> Stage History Opps Records = ' + allOppStageHistory.size());
        
        List<Opportunity> createdOpps = new List<Opportunity>();
        List<Opportunity> closedOpps = new List<Opportunity>();
        
        if(isNewBusiness)
        {
            createdOpps = [Select Id, Name, Type, CHB_Amount__c, CreatedDate, CreatedById, StageName, CloseDate, First_Source__c, Last_Source__c, Product_Family__c,
                    Product_Family__r.Name, Product_Family__r.Business_Group__c, Product_Family__r.Business_Group__r.Name From Opportunity where Type = 'New Business' 
                    AND (Createddate >= :ldt AND Createddate <= :tdt)];
            
            closedOpps = [Select Id, Name, Type, CHB_Amount__c, CreatedDate, CreatedById, StageName, CloseDate, First_Source__c, Last_Source__c, Product_Family__c,
                    Product_Family__r.Name, Product_Family__r.Business_Group__c, Product_Family__r.Business_Group__r.Name From Opportunity where Type = 'New Business' 
                    AND StageName like 'Closed%' AND (CloseDate >= :ldt AND CloseDate <= :tdt)];
        }
        else
        {
            createdOpps = [Select Id, Name, Type, CHB_Amount__c, CreatedDate, CreatedById, StageName, CloseDate, First_Source__c, Last_Source__c, Product_Family__c,
                    Product_Family__r.Name, Product_Family__r.Business_Group__c, Product_Family__r.Business_Group__r.Name From Opportunity where Type != 'New Business' 
                    AND (Createddate >= :ldt AND Createddate <= :tdt)];
            
            closedOpps = [Select Id, Name, Type, CHB_Amount__c, CreatedDate, CreatedById, StageName, CloseDate, First_Source__c, Last_Source__c, Product_Family__c,
                    Product_Family__r.Name, Product_Family__r.Business_Group__c, Product_Family__r.Business_Group__r.Name From Opportunity where Type != 'New Business' 
                    AND StageName like 'Closed%' AND (CloseDate >= :ldt AND CloseDate <= :tdt)];
        }
        
        system.debug('Method --> GenerateQSRReportMarketing ' + NN_BB + '() --> createdOpps Records = ' + createdOpps.size());
        system.debug('Method --> GenerateQSRReportMarketing ' + NN_BB + '() --> closedOpps Records = ' + closedOpps.size());
        
        //Map<string, OpportunityFieldHistory> uqlOppStageHistoryMap = new Map<string, OpportunityFieldHistory>();
        QSR_Metric__c qsrMetric = new QSR_Metric__c();
        qsrMetric.External_ID__c = 'MKT_' + NN_BB;
        qsrMetric.Report_Date_Range__c = string.valueOf(tdt) + ' ==> ' + string.valueOf(ldt) + '| Generated On: ' + string.valueOf(Datetime.now()) ;
        if(isNewBusiness)
        {
            qsrMetric.Name = 'Marketing - New Name';
        }
        else
        {
            qsrMetric.Name = 'Marketing - Back to base';            
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
        
        List<QSR_Metric_Value__c> allQsrMetricValues = new List<QSR_Metric_Value__c>();
        List<QSR_Metric_Opportunity__c> allQsrMetricOpps = new List<QSR_Metric_Opportunity__c>();
        
        QSR_Metric_Value__c mktNnUql = new QSR_Metric_Value__c();
        mktNnUql.External_Id__c = 'MKT_' + NN_BB + '_UQL';
        mktNnUql.Name = 'Unqualified';
        mktNnUql.Current_Quarter_Amount__c = 0;
        mktNnUql.Current_Quarter_Count__c = 0;
        mktNnUQL.Last_Quarter_Amount__c = 0;
        mktNnUql.Last_Quarter_Count__c = 0;
        mktNnUQL.X2nd_Last_Quarter_Amount__c = 0;
        mktNnUql.X2nd_Last_Quarter_Count__c = 0;
        mktNnUQL.X3rd_Last_Quarter_Amount__c = 0;
        mktNnUql.X3rd_Last_Quarter_Count__c = 0;
        mktNnUQL.X4th_Last_Quarter_Amount__c = 0;
        mktNnUql.X4th_Last_Quarter_Count__c = 0;
        mktNnUQL.Year_To_Date_Amount__c = 0;
        mktNnUql.Year_To_Date_Count__c = 0; 
        mktNnUql.Sorting_Order__c = 1;
        mktNnUql.Category__c = 'All';
        mktNnUql.QSR_Metric__c = qsrMetric.Id;
        
        mktNnUql.Product_Family_Name__c = 'All';
        mktNnUql.Business_Group_Name__c = 'All';        
        
        allQsrMetricValues.Add(mktNnUql);
        
        QSR_Metric_Value__c mktNnMql = new QSR_Metric_Value__c();
        mktNnMql.External_Id__c = 'MKT_' + NN_BB + '_MQL';
        mktNnMql.Name = 'Marketing Qualified';
        mktNnMql.Current_Quarter_Amount__c = 0;
        mktNnMql.Current_Quarter_Count__c = 0;
        mktNnMql.Last_Quarter_Amount__c = 0;
        mktNnMql.Last_Quarter_Count__c = 0;
        mktNnMql.X2nd_Last_Quarter_Amount__c = 0;
        mktNnMql.X2nd_Last_Quarter_Count__c = 0;
        mktNnMql.X3rd_Last_Quarter_Amount__c = 0;
        mktNnMql.X3rd_Last_Quarter_Count__c = 0;
        mktNnMql.X4th_Last_Quarter_Amount__c = 0;
        mktNnMql.X4th_Last_Quarter_Count__c = 0;
        mktNnMql.Year_To_Date_Amount__c = 0;
        mktNnMql.Year_To_Date_Count__c = 0;
        mktNnMql.Sorting_Order__c = 2;
        mktNnMql.Category__c = 'All';
        mktNnMql.QSR_Metric__c = qsrMetric.Id;
        
        mktNnMql.Product_Family_Name__c = 'All';
        mktNnMql.Business_Group_Name__c = 'All';        
        
        allQsrMetricValues.Add(mktNnMql);
        
        QSR_Metric_Value__c mktNnCSql = new QSR_Metric_Value__c();
        mktNnCSql.External_Id__c = 'MKT_' + NN_BB + '_C-SQL';
        mktNnCSql.Name = 'Confirmed - SQL';
        mktNnCSql.Current_Quarter_Amount__c = 0;
        mktNnCSql.Current_Quarter_Count__c = 0;
        mktNnCSql.Last_Quarter_Amount__c = 0;
        mktNnCSql.Last_Quarter_Count__c = 0;
        mktNnCSql.X2nd_Last_Quarter_Amount__c = 0;
        mktNnCSql.X2nd_Last_Quarter_Count__c = 0;
        mktNnCSql.X3rd_Last_Quarter_Amount__c = 0;
        mktNnCSql.X3rd_Last_Quarter_Count__c = 0;
        mktNnCSql.X4th_Last_Quarter_Amount__c = 0;
        mktNnCSql.X4th_Last_Quarter_Count__c = 0;
        mktNnCSql.Year_To_Date_Amount__c = 0;
        mktNnCSql.Year_To_Date_Count__c = 0;
        mktNnCSql.Sorting_Order__c = 3;
        mktNnCSql.Category__c = 'All';
        mktNnCSql.QSR_Metric__c = qsrMetric.Id;
        
        mktNnCSql.Product_Family_Name__c = 'All';
        mktNnCSql.Business_Group_Name__c = 'All';        
        
        allQsrMetricValues.Add(mktNnCSql);
        
        QSR_Metric_Value__c mktNnOppCreated = new QSR_Metric_Value__c();
        mktNnOppCreated.External_Id__c = 'MKT_' + NN_BB + '_OPP_CREATED';
        mktNnOppCreated.Name = 'Opportunities Created';
        mktNnOppCreated.Current_Quarter_Amount__c = 0;
        mktNnOppCreated.Current_Quarter_Count__c = 0;
        mktNnOppCreated.Last_Quarter_Amount__c = 0;
        mktNnOppCreated.Last_Quarter_Count__c = 0;
        mktNnOppCreated.X2nd_Last_Quarter_Amount__c = 0;
        mktNnOppCreated.X2nd_Last_Quarter_Count__c = 0;
        mktNnOppCreated.X3rd_Last_Quarter_Amount__c = 0;
        mktNnOppCreated.X3rd_Last_Quarter_Count__c = 0;
        mktNnOppCreated.X4th_Last_Quarter_Amount__c = 0;
        mktNnOppCreated.X4th_Last_Quarter_Count__c = 0;
        mktNnOppCreated.Year_To_Date_Amount__c = 0;
        mktNnOppCreated.Year_To_Date_Count__c = 0;
        mktNnOppCreated.Sorting_Order__c = 4;
        mktNnOppCreated.Category__c = 'All';
        mktNnOppCreated.QSR_Metric__c = qsrMetric.Id;
        
        mktNnOppCreated.Product_Family_Name__c = 'All';
        mktNnOppCreated.Business_Group_Name__c = 'All';        
        
        allQsrMetricValues.Add(mktNnOppCreated);
        
        QSR_Metric_Value__c mktNnOppClosedWon = new QSR_Metric_Value__c();
        mktNnOppClosedWon.External_Id__c = 'MKT_' + NN_BB + '_OPP_CLOSED_WON';
        mktNnOppClosedWon.Name = 'Opportunities Closed Won';
        mktNnOppClosedWon.Current_Quarter_Amount__c = 0;
        mktNnOppClosedWon.Current_Quarter_Count__c = 0;
        mktNnOppClosedWon.Last_Quarter_Amount__c = 0;
        mktNnOppClosedWon.Last_Quarter_Count__c = 0;
        mktNnOppClosedWon.X2nd_Last_Quarter_Amount__c = 0;
        mktNnOppClosedWon.X2nd_Last_Quarter_Count__c = 0;
        mktNnOppClosedWon.X3rd_Last_Quarter_Amount__c = 0;
        mktNnOppClosedWon.X3rd_Last_Quarter_Count__c = 0;
        mktNnOppClosedWon.X4th_Last_Quarter_Amount__c = 0;
        mktNnOppClosedWon.X4th_Last_Quarter_Count__c = 0;
        mktNnOppClosedWon.Year_To_Date_Amount__c = 0;
        mktNnOppClosedWon.Year_To_Date_Count__c = 0;
        mktNnOppClosedWon.Sorting_Order__c = 5;
        mktNnOppClosedWon.Category__c = 'All';
        mktNnOppClosedWon.QSR_Metric__c = qsrMetric.Id;
        
        mktNnOppClosedWon.Product_Family_Name__c = 'All';
        mktNnOppClosedWon.Business_Group_Name__c = 'All';        
        
        allQsrMetricValues.Add(mktNnOppClosedWon);
        
        QSR_Metric_Value__c mktNnOppClosedWonGenByMkt = new QSR_Metric_Value__c();
        mktNnOppClosedWonGenByMkt.External_Id__c = 'MKT_' + NN_BB + '_OPP_CLOSED_WON_GEN_BY_MKT';
        mktNnOppClosedWonGenByMkt.Name = 'Opportunities Closed Won - Generated By Marketing';
        mktNnOppClosedWonGenByMkt.Current_Quarter_Amount__c = 0;
        mktNnOppClosedWonGenByMkt.Current_Quarter_Count__c = 0;
        mktNnOppClosedWonGenByMkt.Last_Quarter_Amount__c = 0;
        mktNnOppClosedWonGenByMkt.Last_Quarter_Count__c = 0;
        mktNnOppClosedWonGenByMkt.X2nd_Last_Quarter_Amount__c = 0;
        mktNnOppClosedWonGenByMkt.X2nd_Last_Quarter_Count__c = 0;
        mktNnOppClosedWonGenByMkt.X3rd_Last_Quarter_Amount__c = 0;
        mktNnOppClosedWonGenByMkt.X3rd_Last_Quarter_Count__c = 0;
        mktNnOppClosedWonGenByMkt.X4th_Last_Quarter_Amount__c = 0;
        mktNnOppClosedWonGenByMkt.X4th_Last_Quarter_Count__c = 0;
        mktNnOppClosedWonGenByMkt.Year_To_Date_Amount__c = 0;
        mktNnOppClosedWonGenByMkt.Year_To_Date_Count__c = 0;
        mktNnOppClosedWonGenByMkt.Sorting_Order__c = 6;
        mktNnOppClosedWonGenByMkt.Category__c = 'All';
        mktNnOppClosedWonGenByMkt.QSR_Metric__c = qsrMetric.Id;
        
        mktNnOppClosedWonGenByMkt.Product_Family_Name__c = 'All';
        mktNnOppClosedWonGenByMkt.Business_Group_Name__c = 'All';        
        
        allQsrMetricValues.Add(mktNnOppClosedWonGenByMkt);
        
        QSR_Metric_Value__c mktNnOppClosedWonInfByMkt = new QSR_Metric_Value__c();
        mktNnOppClosedWonInfByMkt.External_Id__c = 'MKT_' + NN_BB + '_OPP_CLOSED_WON_INF_BY_MKT';
        mktNnOppClosedWonInfByMkt.Name = 'Opportunities Closed Won - Influenced By Marketing';
        mktNnOppClosedWonInfByMkt.Current_Quarter_Amount__c = 0;
        mktNnOppClosedWonInfByMkt.Current_Quarter_Count__c = 0;
        mktNnOppClosedWonInfByMkt.Last_Quarter_Amount__c = 0;
        mktNnOppClosedWonInfByMkt.Last_Quarter_Count__c = 0;
        mktNnOppClosedWonInfByMkt.X2nd_Last_Quarter_Amount__c = 0;
        mktNnOppClosedWonInfByMkt.X2nd_Last_Quarter_Count__c = 0;
        mktNnOppClosedWonInfByMkt.X3rd_Last_Quarter_Amount__c = 0;
        mktNnOppClosedWonInfByMkt.X3rd_Last_Quarter_Count__c = 0;
        mktNnOppClosedWonInfByMkt.X4th_Last_Quarter_Amount__c = 0;
        mktNnOppClosedWonInfByMkt.X4th_Last_Quarter_Count__c = 0;
        mktNnOppClosedWonInfByMkt.Year_To_Date_Amount__c = 0;
        mktNnOppClosedWonInfByMkt.Year_To_Date_Count__c = 0;
        mktNnOppClosedWonInfByMkt.Sorting_Order__c = 7;
        mktNnOppClosedWonInfByMkt.Category__c = 'All';
        mktNnOppClosedWonInfByMkt.QSR_Metric__c = qsrMetric.Id;
        
        mktNnOppClosedWonInfByMkt.Product_Family_Name__c = 'All';
        mktNnOppClosedWonInfByMkt.Business_Group_Name__c = 'All';        
        
        allQsrMetricValues.Add(mktNnOppClosedWonInfByMkt);
        
        QSR_Metric_Value__c mktNnOppClosedNurture = new QSR_Metric_Value__c();
        mktNnOppClosedNurture.External_Id__c = 'MKT_' + NN_BB + '_OPP_CLOSED_NURTURE';
        mktNnOppClosedNurture.Name = 'Opportunities Closed - Nurture';
        mktNnOppClosedNurture.Current_Quarter_Amount__c = 0;
        mktNnOppClosedNurture.Current_Quarter_Count__c = 0;
        mktNnOppClosedNurture.Last_Quarter_Amount__c = 0;
        mktNnOppClosedNurture.Last_Quarter_Count__c = 0;
        mktNnOppClosedNurture.X2nd_Last_Quarter_Amount__c = 0;
        mktNnOppClosedNurture.X2nd_Last_Quarter_Count__c = 0;
        mktNnOppClosedNurture.X3rd_Last_Quarter_Amount__c = 0;
        mktNnOppClosedNurture.X3rd_Last_Quarter_Count__c = 0;
        mktNnOppClosedNurture.X4th_Last_Quarter_Amount__c = 0;
        mktNnOppClosedNurture.X4th_Last_Quarter_Count__c = 0;
        mktNnOppClosedNurture.Year_To_Date_Amount__c = 0;
        mktNnOppClosedNurture.Year_To_Date_Count__c = 0;
        mktNnOppClosedNurture.Sorting_Order__c = 8;
        mktNnOppClosedNurture.Category__c = 'All';
        mktNnOppClosedNurture.QSR_Metric__c = qsrMetric.Id;
        
        mktNnOppClosedNurture.Product_Family_Name__c = 'All';
        mktNnOppClosedNurture.Business_Group_Name__c = 'All';        
        
        allQsrMetricValues.Add(mktNnOppClosedNurture);
        
        QSR_Metric_Value__c mktNnOppClosedNotInterested = new QSR_Metric_Value__c();
        mktNnOppClosedNotInterested.External_Id__c = 'MKT_' + NN_BB + '_OPP_CLOSED_INTERESTED';
        mktNnOppClosedNotInterested.Name = 'Opportunities Closed - Not Interested';
        mktNnOppClosedNotInterested.Current_Quarter_Amount__c = 0;
        mktNnOppClosedNotInterested.Current_Quarter_Count__c = 0;
        mktNnOppClosedNotInterested.Last_Quarter_Amount__c = 0;
        mktNnOppClosedNotInterested.Last_Quarter_Count__c = 0;
        mktNnOppClosedNotInterested.X2nd_Last_Quarter_Amount__c = 0;
        mktNnOppClosedNotInterested.X2nd_Last_Quarter_Count__c = 0;
        mktNnOppClosedNotInterested.X3rd_Last_Quarter_Amount__c = 0;
        mktNnOppClosedNotInterested.X3rd_Last_Quarter_Count__c = 0;
        mktNnOppClosedNotInterested.X4th_Last_Quarter_Amount__c = 0;
        mktNnOppClosedNotInterested.X4th_Last_Quarter_Count__c = 0;
        mktNnOppClosedNotInterested.Year_To_Date_Amount__c = 0;
        mktNnOppClosedNotInterested.Year_To_Date_Count__c = 0;
        mktNnOppClosedNotInterested.Sorting_Order__c = 9;
        mktNnOppClosedNotInterested.Category__c = 'All';
        mktNnOppClosedNotInterested.QSR_Metric__c = qsrMetric.Id;
        
        mktNnOppClosedNotInterested.Product_Family_Name__c = 'All';
        mktNnOppClosedNotInterested.Business_Group_Name__c = 'All';        
        
        allQsrMetricValues.Add(mktNnOppClosedNotInterested);
        
        QSR_Metric_Value__c mktNnOppClosedDisqualified = new QSR_Metric_Value__c();
        mktNnOppClosedDisqualified.External_Id__c = 'MKT_' + NN_BB + '_OPP_CLOSED_DISQUALIFIED';
        mktNnOppClosedDisqualified.Name = 'Opportunities Closed - Disqualified';
        mktNnOppClosedDisqualified.Current_Quarter_Amount__c = 0;
        mktNnOppClosedDisqualified.Current_Quarter_Count__c = 0;
        mktNnOppClosedDisqualified.Last_Quarter_Amount__c = 0;
        mktNnOppClosedDisqualified.Last_Quarter_Count__c = 0;
        mktNnOppClosedDisqualified.X2nd_Last_Quarter_Amount__c = 0;
        mktNnOppClosedDisqualified.X2nd_Last_Quarter_Count__c = 0;
        mktNnOppClosedDisqualified.X3rd_Last_Quarter_Amount__c = 0;
        mktNnOppClosedDisqualified.X3rd_Last_Quarter_Count__c = 0;
        mktNnOppClosedDisqualified.X4th_Last_Quarter_Amount__c = 0;
        mktNnOppClosedDisqualified.X4th_Last_Quarter_Count__c = 0;
        mktNnOppClosedDisqualified.Year_To_Date_Amount__c = 0;
        mktNnOppClosedDisqualified.Year_To_Date_Count__c = 0;
        mktNnOppClosedDisqualified.Sorting_Order__c = 10;
        mktNnOppClosedDisqualified.Category__c = 'All';
        mktNnOppClosedDisqualified.QSR_Metric__c = qsrMetric.Id;
        
        mktNnOppClosedDisqualified.Product_Family_Name__c = 'All';
        mktNnOppClosedDisqualified.Business_Group_Name__c = 'All';        
        
        allQsrMetricValues.Add(mktNnOppClosedDisqualified);
        
        try
        {                            
            if(allQsrMetricValues.size() > 0){
                List<Database.UpsertResult> qsrMetricValuesResult = Database.upsert( new List<QSR_Metric_Value__c>(allQsrMetricValues), QSR_Metric_Value__c.External_ID__c);                
                system.debug('Method --> GenerateQSRReportMarketing'+ NN_BB + '() --> Upserting QSR Value/Row = ' + qsrMetricValuesResult.size());                                
            }            
        }
        catch(DmlException e)
        {
            system.debug('Method --> GenerateQSRReportMarketing ' + NN_BB + '() --> DML Exception Occured post conversion DML');
            system.debug(e);
        }  
        
        for(OpportunityFieldHistory ofh : allOppStageHistory)
        {
            Datetime odt = ofh.CreatedDate;
            Integer omonth = odt.Month(); //get month
            Integer oyear = odt.Year(); //get year
            
            string lq  = GetOppQuarter(omonth, oyear);
            double ofhOppAmt = 0;
            if(ofh.Opportunity.CHB_Amount__c != null)
            {
                ofhOppAmt = ofh.Opportunity.CHB_Amount__c;
            }
            
            QSR_Metric_Opportunity__c qsrMetricOpp = new QSR_Metric_Opportunity__c();
            
            if(ofh.NewValue == Unqualified || ofh.Field == 'opportunityCreatedFromLead' || ofh.Field == 'created')
            {                
                if(lq == CQ)
                {
                    mktNnUql.Current_Quarter_Count__c= mktNnUql.Current_Quarter_Count__c + 1;
                    mktNnUql.Current_Quarter_Amount__c = mktNnUql.Current_Quarter_Amount__c + ofhOppAmt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = ofh.OpportunityId;
                    qsrMetricOpp.QSR_Metric_Value__c = mktNnUql.Id;
                    qsrMetricOpp.Quarter__c  = CQ; 
                    allQsrMetricOpps.Add(qsrMetricOpp);
                }
                if(lq == LQ1)
                {                    
                    mktNnUql.Last_Quarter_Count__c= mktNnUql.Last_Quarter_Count__c + 1;
                    mktNnUql.Last_Quarter_Amount__c = mktNnUql.Last_Quarter_Amount__c + ofhOppAmt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = ofh.OpportunityId;
                    qsrMetricOpp.QSR_Metric_Value__c = mktNnUql.Id;
                    qsrMetricOpp.Quarter__c = LQ1;
                    allQsrMetricOpps.Add(qsrMetricOpp);
                }
                if(lq == LQ2)
                {
                    mktNnUql.X2nd_Last_Quarter_Count__c= mktNnUql.X2nd_Last_Quarter_Count__c + 1;
                    mktNnUql.X2nd_Last_Quarter_Amount__c = mktNnUql.X2nd_Last_Quarter_Amount__c + ofhOppAmt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = ofh.OpportunityId;
                    qsrMetricOpp.QSR_Metric_Value__c = mktNnUql.Id;
                    qsrMetricOpp.Quarter__c = LQ2;
                    allQsrMetricOpps.Add(qsrMetricOpp);                    
                }
                if(lq == LQ3)
                {
                    mktNnUql.X3rd_Last_Quarter_Count__c= mktNnUql.X3rd_Last_Quarter_Count__c + 1;
                    mktNnUql.X3rd_Last_Quarter_Amount__c = mktNnUql.X3rd_Last_Quarter_Amount__c + ofhOppAmt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = ofh.OpportunityId;
                    qsrMetricOpp.QSR_Metric_Value__c = mktNnUql.Id;
                    qsrMetricOpp.Quarter__c = LQ3;
                    allQsrMetricOpps.Add(qsrMetricOpp);
                }
                if(lq == LQ4)
                {
                    mktNnUql.X4th_Last_Quarter_Count__c= mktNnUql.X4th_Last_Quarter_Count__c + 1;
                    mktNnUql.X4th_Last_Quarter_Amount__c = mktNnUql.X4th_Last_Quarter_Amount__c + ofhOppAmt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = ofh.OpportunityId;
                    qsrMetricOpp.QSR_Metric_Value__c = mktNnUql.Id;
                    qsrMetricOpp.Quarter__c = LQ4;
                    allQsrMetricOpps.Add(qsrMetricOpp);
                }
                if(oyear == tyear)
                {
                    mktNnUql.Year_To_Date_Count__c= mktNnUql.Year_To_Date_Count__c + 1;
                    mktNnUql.Year_To_Date_Amount__c = mktNnUql.Year_To_Date_Amount__c + ofhOppAmt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = ofh.OpportunityId;
                    qsrMetricOpp.QSR_Metric_Value__c = mktNnUql.Id;
                    qsrMetricOpp.Quarter__c = YTD;
                    allQsrMetricOpps.Add(qsrMetricOpp);
                }
            }
            
            if(ofh.NewValue == Marketing_Qualified)
            {                
                if(lq == CQ)
                {
                    mktNnMql.Current_Quarter_Count__c= mktNnMql.Current_Quarter_Count__c + 1;
                    mktNnMql.Current_Quarter_Amount__c = mktNnMql.Current_Quarter_Amount__c + ofhOppAmt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = ofh.OpportunityId;
                    qsrMetricOpp.QSR_Metric_Value__c = mktNnMql.Id;
                    qsrMetricOpp.Quarter__c = CQ;
                    allQsrMetricOpps.Add(qsrMetricOpp);
                }
                if(lq == LQ1)
                {                    
                    mktNnMql.Last_Quarter_Count__c= mktNnMql.Last_Quarter_Count__c + 1;
                    mktNnMql.Last_Quarter_Amount__c = mktNnMql.Last_Quarter_Amount__c + ofhOppAmt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = ofh.OpportunityId;
                    qsrMetricOpp.QSR_Metric_Value__c = mktNnMql.Id;
                    qsrMetricOpp.Quarter__c = LQ1;
                    allQsrMetricOpps.Add(qsrMetricOpp);
                }
                if(lq == LQ2)
                {
                    mktNnMql.X2nd_Last_Quarter_Count__c= mktNnMql.X2nd_Last_Quarter_Count__c + 1;
                    mktNnMql.X2nd_Last_Quarter_Amount__c = mktNnMql.X2nd_Last_Quarter_Amount__c + ofhOppAmt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = ofh.OpportunityId;
                    qsrMetricOpp.QSR_Metric_Value__c = mktNnMql.Id;
                    qsrMetricOpp.Quarter__c = LQ2;
                    allQsrMetricOpps.Add(qsrMetricOpp);                    
                }
                if(lq == LQ3)
                {
                    mktNnMql.X3rd_Last_Quarter_Count__c= mktNnMql.X3rd_Last_Quarter_Count__c + 1;
                    mktNnMql.X3rd_Last_Quarter_Amount__c = mktNnMql.X3rd_Last_Quarter_Amount__c + ofhOppAmt;
                    qsrMetricOpp.Quarter__c = LQ3;
                    allQsrMetricOpps.Add(qsrMetricOpp);
                }
                if(lq == LQ4)
                {
                    mktNnMql.X4th_Last_Quarter_Count__c= mktNnMql.X4th_Last_Quarter_Count__c + 1;
                    mktNnMql.X4th_Last_Quarter_Amount__c = mktNnMql.X4th_Last_Quarter_Amount__c + ofhOppAmt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = ofh.OpportunityId;
                    qsrMetricOpp.QSR_Metric_Value__c = mktNnMql.Id;
                    qsrMetricOpp.Quarter__c = LQ4;
                    allQsrMetricOpps.Add(qsrMetricOpp);
                }
                if(oyear == tyear)
                {
                    mktNnMql.Year_To_Date_Count__c= mktNnMql.Year_To_Date_Count__c + 1;
                    mktNnMql.Year_To_Date_Amount__c = mktNnMql.Year_To_Date_Amount__c + ofhOppAmt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = ofh.OpportunityId;
                    qsrMetricOpp.QSR_Metric_Value__c = mktNnMql.Id;
                    qsrMetricOpp.Quarter__c = YTD;
                    allQsrMetricOpps.Add(qsrMetricOpp);
                } 
            }
            
            if(ofh.NewValue == Confirmed_SQL)
            {
                
                qsrMetricOpp.QSR_Metric_Value__c = mktNnCSql.Id;
                
                if(lq == CQ)
                {
                    mktNnCSql.Current_Quarter_Count__c= mktNnCSql.Current_Quarter_Count__c + 1;
                    mktNnCSql.Current_Quarter_Amount__c = mktNnCSql.Current_Quarter_Amount__c + ofhOppAmt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = ofh.OpportunityId;
                    qsrMetricOpp.QSR_Metric_Value__c = mktNnCSql.Id;
                    qsrMetricOpp.Quarter__c = CQ;
                    allQsrMetricOpps.Add(qsrMetricOpp);
                }
                if(lq == LQ1)
                {                    
                    mktNnCSql.Last_Quarter_Count__c= mktNnCSql.Last_Quarter_Count__c + 1;
                    mktNnCSql.Last_Quarter_Amount__c = mktNnCSql.Last_Quarter_Amount__c + ofhOppAmt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = ofh.OpportunityId;
                    qsrMetricOpp.QSR_Metric_Value__c = mktNnCSql.Id;
                    qsrMetricOpp.Quarter__c = LQ1;
                    allQsrMetricOpps.Add(qsrMetricOpp);
                }
                if(lq == LQ2)
                {
                    mktNnCSql.X2nd_Last_Quarter_Count__c= mktNnCSql.X2nd_Last_Quarter_Count__c + 1;
                    mktNnCSql.X2nd_Last_Quarter_Amount__c = mktNnCSql.X2nd_Last_Quarter_Amount__c + ofhOppAmt; 
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = ofh.OpportunityId;
                    qsrMetricOpp.QSR_Metric_Value__c = mktNnCSql.Id;
                    qsrMetricOpp.Quarter__c = LQ2;
                    allQsrMetricOpps.Add(qsrMetricOpp);                   
                }
                if(lq == LQ3)
                {
                    mktNnCSql.X3rd_Last_Quarter_Count__c= mktNnCSql.X3rd_Last_Quarter_Count__c + 1;
                    mktNnCSql.X3rd_Last_Quarter_Amount__c = mktNnCSql.X3rd_Last_Quarter_Amount__c + ofhOppAmt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = ofh.OpportunityId;
                    qsrMetricOpp.QSR_Metric_Value__c = mktNnCSql.Id;
                    qsrMetricOpp.Quarter__c = LQ3;
                    allQsrMetricOpps.Add(qsrMetricOpp);
                }
                if(lq == LQ4)
                {
                    mktNnCSql.X4th_Last_Quarter_Count__c= mktNnCSql.X4th_Last_Quarter_Count__c + 1;
                    mktNnCSql.X4th_Last_Quarter_Amount__c = mktNnCSql.X4th_Last_Quarter_Amount__c + ofhOppAmt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = ofh.OpportunityId;
                    qsrMetricOpp.QSR_Metric_Value__c = mktNnCSql.Id;
                    qsrMetricOpp.Quarter__c = LQ4;
                    allQsrMetricOpps.Add(qsrMetricOpp);
                }
                if(oyear == tyear)
                {
                    mktNnCSql.Year_To_Date_Count__c= mktNnCSql.Year_To_Date_Count__c + 1;
                    mktNnCSql.Year_To_Date_Amount__c = mktNnCSql.Year_To_Date_Amount__c + ofhOppAmt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = ofh.OpportunityId;
                    qsrMetricOpp.QSR_Metric_Value__c = mktNnCSql.Id;
                    qsrMetricOpp.Quarter__c = YTD;
                    allQsrMetricOpps.Add(qsrMetricOpp);
                }
                
            } 
        }
        
        
        system.debug('Method --> GenerateQSRReportMarketing ' + NN_BB + '() --> Opps By History = ' +allQsrMetricOpps.size());
        
        //All Opps - NN
        for(Opportunity op : createdOpps)
        {
            //All Opps Created - Quarterwise
            Datetime odt = op.CreatedDate; 
            Integer omonth = odt.Month(); //get month
            Integer oyear = odt.Year(); //get year
            Double amt = 0;
            if(op.CHB_Amount__c != null)
            {
                amt = op.CHB_Amount__c;
            }
            
            string lq  = GetOppQuarter(omonth, oyear);
            
            QSR_Metric_Opportunity__c qsrMetricOpp = new QSR_Metric_Opportunity__c();
                        
            if(lq == CQ)
            {
                mktNnOppCreated.Current_Quarter_Count__c= mktNnOppCreated.Current_Quarter_Count__c + 1;
                mktNnOppCreated.Current_Quarter_Amount__c = mktNnOppCreated.Current_Quarter_Amount__c + amt;
                
                qsrMetricOpp = new QSR_Metric_Opportunity__c();
                qsrMetricOpp.Opportunity__c = op.Id;
                qsrMetricOpp.QSR_Metric_Value__c = mktNnOppCreated.Id;
                qsrMetricOpp.Quarter__c= CQ;
                allQsrMetricOpps.Add(qsrMetricOpp);
            }
            if(lq == LQ1)
            {                    
                mktNnOppCreated.Last_Quarter_Count__c= mktNnOppCreated.Last_Quarter_Count__c + 1;
                mktNnOppCreated.Last_Quarter_Amount__c = mktNnOppCreated.Last_Quarter_Amount__c + amt;
                
                qsrMetricOpp = new QSR_Metric_Opportunity__c();
                qsrMetricOpp.Opportunity__c = op.Id;
                qsrMetricOpp.QSR_Metric_Value__c = mktNnOppCreated.Id;
                qsrMetricOpp.Quarter__c= LQ1;
                allQsrMetricOpps.Add(qsrMetricOpp);
            }
            if(lq == LQ2)
            {
                mktNnOppCreated.X2nd_Last_Quarter_Count__c= mktNnOppCreated.X2nd_Last_Quarter_Count__c + 1;
                mktNnOppCreated.X2nd_Last_Quarter_Amount__c = mktNnOppCreated.X2nd_Last_Quarter_Amount__c + amt;
                
                qsrMetricOpp = new QSR_Metric_Opportunity__c();
                qsrMetricOpp.Opportunity__c = op.Id;
                qsrMetricOpp.QSR_Metric_Value__c = mktNnOppCreated.Id; 
                qsrMetricOpp.Quarter__c= LQ2; 
                allQsrMetricOpps.Add(qsrMetricOpp);                  
            }
            if(lq == LQ3)
            {
                mktNnOppCreated.X3rd_Last_Quarter_Count__c= mktNnOppCreated.X3rd_Last_Quarter_Count__c + 1;
                mktNnOppCreated.X3rd_Last_Quarter_Amount__c = mktNnOppCreated.X3rd_Last_Quarter_Amount__c + amt;
                
                qsrMetricOpp = new QSR_Metric_Opportunity__c();
                qsrMetricOpp.Opportunity__c = op.Id;
                qsrMetricOpp.QSR_Metric_Value__c = mktNnOppCreated.Id;
                qsrMetricOpp.Quarter__c= LQ3;
                allQsrMetricOpps.Add(qsrMetricOpp);
            }
            if(lq == LQ4)
            {
                mktNnOppCreated.X4th_Last_Quarter_Count__c= mktNnOppCreated.X4th_Last_Quarter_Count__c + 1;
                mktNnOppCreated.X4th_Last_Quarter_Amount__c = mktNnOppCreated.X4th_Last_Quarter_Amount__c + amt;
                
                qsrMetricOpp = new QSR_Metric_Opportunity__c();
                qsrMetricOpp.Opportunity__c = op.Id;
                qsrMetricOpp.QSR_Metric_Value__c = mktNnOppCreated.Id;
                qsrMetricOpp.Quarter__c= LQ4;
                allQsrMetricOpps.Add(qsrMetricOpp);
            }
            if(oyear == tyear)
            {
                mktNnOppCreated.Year_To_Date_Count__c = mktNnOppCreated.Year_To_Date_Count__c + 1;
                mktNnOppCreated.Year_To_Date_Amount__c = mktNnOppCreated.Year_To_Date_Amount__c + amt;
                
                qsrMetricOpp = new QSR_Metric_Opportunity__c();
                qsrMetricOpp.Opportunity__c = op.Id;
                qsrMetricOpp.QSR_Metric_Value__c = mktNnOppCreated.Id;
                qsrMetricOpp.Quarter__c= YTD;
                allQsrMetricOpps.Add(qsrMetricOpp);
            }
        }
        
        for(Opportunity op : closedOpps)
        {
        
            //All Opps Closed            
            Datetime ocdt = op.CloseDate; 
            Integer ocmonth = ocdt.Month(); //get month
            Integer ocyear = ocdt.Year(); //get year
            Double cwamt = 0;
            if(op.CHB_Amount__c != null)
            {
                cwamt = op.CHB_Amount__c;
            }
            
            
            QSR_Metric_Opportunity__c qsrMetricOpp = new QSR_Metric_Opportunity__c();
            string ocq  = GetOppQuarter(ocmonth, ocyear);
            
            //All Opps Closed Won - Quarterwise
            if(op.StageName == 'Closed Won')
            {         
                if(ocq == CQ)
                {
                    mktNnOppClosedWon.Current_Quarter_Count__c= mktNnOppClosedWon.Current_Quarter_Count__c + 1;
                    mktNnOppClosedWon.Current_Quarter_Amount__c = mktNnOppClosedWon.Current_Quarter_Amount__c + cwamt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = op.Id;
                    qsrMetricOpp.QSR_Metric_Value__c = mktNnOppClosedWon.Id;
                    qsrMetricOpp.Quarter__c= CQ;
                    allQsrMetricOpps.add(qsrMetricOpp);
                }
                if(ocq == LQ1)
                {                    
                    mktNnOppClosedWon.Last_Quarter_Count__c= mktNnOppClosedWon.Last_Quarter_Count__c + 1;
                    mktNnOppClosedWon.Last_Quarter_Amount__c = mktNnOppClosedWon.Last_Quarter_Amount__c + cwamt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = op.Id;
                    qsrMetricOpp.QSR_Metric_Value__c = mktNnOppClosedWon.Id;
                    qsrMetricOpp.Quarter__c= LQ1;
                    allQsrMetricOpps.add(qsrMetricOpp);
                }
                if(ocq == LQ2)
                {
                    mktNnOppClosedWon.X2nd_Last_Quarter_Count__c= mktNnOppClosedWon.X2nd_Last_Quarter_Count__c + 1;
                    mktNnOppClosedWon.X2nd_Last_Quarter_Amount__c = mktNnOppClosedWon.X2nd_Last_Quarter_Amount__c + cwamt; 
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = op.Id;
                    qsrMetricOpp.QSR_Metric_Value__c = mktNnOppClosedWon.Id;
                    qsrMetricOpp.Quarter__c= LQ2; 
                    allQsrMetricOpps.add(qsrMetricOpp);                  
                }
                if(ocq == LQ3)
                {
                    mktNnOppClosedWon.X3rd_Last_Quarter_Count__c= mktNnOppClosedWon.X3rd_Last_Quarter_Count__c + 1;
                    mktNnOppClosedWon.X3rd_Last_Quarter_Amount__c = mktNnOppClosedWon.X3rd_Last_Quarter_Amount__c + cwamt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = op.Id;
                    qsrMetricOpp.QSR_Metric_Value__c = mktNnOppClosedWon.Id;
                    qsrMetricOpp.Quarter__c= LQ3;
                    allQsrMetricOpps.add(qsrMetricOpp);
                }
                if(ocq == LQ4)
                {
                    mktNnOppClosedWon.X4th_Last_Quarter_Count__c= mktNnOppClosedWon.X4th_Last_Quarter_Count__c + 1;
                    mktNnOppClosedWon.X4th_Last_Quarter_Amount__c = mktNnOppClosedWon.X4th_Last_Quarter_Amount__c + cwamt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = op.Id;
                    qsrMetricOpp.QSR_Metric_Value__c = mktNnOppClosedWon.Id;
                    qsrMetricOpp.Quarter__c= LQ4;
                    allQsrMetricOpps.add(qsrMetricOpp);
                }
                if(ocyear == tyear)
                {
                    mktNnOppClosedWon.Year_To_Date_Count__c = mktNnOppClosedWon.Year_To_Date_Count__c + 1;
                    mktNnOppClosedWon.Year_To_Date_Amount__c = mktNnOppClosedWon.Year_To_Date_Amount__c + cwamt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = op.Id;
                    qsrMetricOpp.QSR_Metric_Value__c = mktNnOppClosedWon.Id;
                    qsrMetricOpp.Quarter__c= YTD;
                    allQsrMetricOpps.add(qsrMetricOpp);
                }
                
                //If Opp Closed Won and Gen by Mkt
                if(IsSourceMarketing(op.First_Source__c))
                {
                    if(ocq == CQ)
                    {
                        mktNnOppClosedWonGenByMkt.Current_Quarter_Count__c= mktNnOppClosedWonGenByMkt.Current_Quarter_Count__c + 1;
                        mktNnOppClosedWonGenByMkt.Current_Quarter_Amount__c = mktNnOppClosedWonGenByMkt.Current_Quarter_Amount__c + cwamt;
                        
                        qsrMetricOpp = new QSR_Metric_Opportunity__c();
                        qsrMetricOpp.Opportunity__c = op.Id;
                        qsrMetricOpp.QSR_Metric_Value__c = mktNnOppClosedWonGenByMkt.Id;
                        qsrMetricOpp.Quarter__c= CQ;
                        allQsrMetricOpps.add(qsrMetricOpp); 
                    }
                    if(ocq == LQ1)
                    {                    
                        mktNnOppClosedWonGenByMkt.Last_Quarter_Count__c= mktNnOppClosedWonGenByMkt.Last_Quarter_Count__c + 1;
                        mktNnOppClosedWonGenByMkt.Last_Quarter_Amount__c = mktNnOppClosedWonGenByMkt.Last_Quarter_Amount__c + cwamt;
                        
                        qsrMetricOpp = new QSR_Metric_Opportunity__c();
                        qsrMetricOpp.Opportunity__c = op.Id;
                        qsrMetricOpp.QSR_Metric_Value__c = mktNnOppClosedWonGenByMkt.Id;
                        qsrMetricOpp.Quarter__c= LQ1;
                        allQsrMetricOpps.add(qsrMetricOpp); 
                    }
                    if(ocq == LQ2)
                    {
                        mktNnOppClosedWonGenByMkt.X2nd_Last_Quarter_Count__c= mktNnOppClosedWonGenByMkt.X2nd_Last_Quarter_Count__c + 1;
                        mktNnOppClosedWonGenByMkt.X2nd_Last_Quarter_Amount__c = mktNnOppClosedWonGenByMkt.X2nd_Last_Quarter_Amount__c + cwamt; 
                        
                        qsrMetricOpp = new QSR_Metric_Opportunity__c();
                        qsrMetricOpp.Opportunity__c = op.Id;
                        qsrMetricOpp.QSR_Metric_Value__c = mktNnOppClosedWonGenByMkt.Id;
                        qsrMetricOpp.Quarter__c= LQ2; 
                        allQsrMetricOpps.add(qsrMetricOpp);                   
                    }
                    if(ocq == LQ3)
                    {
                        mktNnOppClosedWonGenByMkt.X3rd_Last_Quarter_Count__c= mktNnOppClosedWonGenByMkt.X3rd_Last_Quarter_Count__c + 1;
                        mktNnOppClosedWonGenByMkt.X3rd_Last_Quarter_Amount__c = mktNnOppClosedWonGenByMkt.X3rd_Last_Quarter_Amount__c + cwamt;
                        
                        qsrMetricOpp = new QSR_Metric_Opportunity__c();
                        qsrMetricOpp.Opportunity__c = op.Id;
                        qsrMetricOpp.QSR_Metric_Value__c = mktNnOppClosedWonGenByMkt.Id;
                        qsrMetricOpp.Quarter__c= LQ3;
                        allQsrMetricOpps.add(qsrMetricOpp); 
                    }
                    if(ocq == LQ4)
                    {
                        mktNnOppClosedWonGenByMkt.X4th_Last_Quarter_Count__c= mktNnOppClosedWonGenByMkt.X4th_Last_Quarter_Count__c + 1;
                        mktNnOppClosedWonGenByMkt.X4th_Last_Quarter_Amount__c = mktNnOppClosedWonGenByMkt.X4th_Last_Quarter_Amount__c + cwamt;
                        
                        qsrMetricOpp = new QSR_Metric_Opportunity__c();
                        qsrMetricOpp.Opportunity__c = op.Id;
                        qsrMetricOpp.QSR_Metric_Value__c = mktNnOppClosedWonGenByMkt.Id;
                        qsrMetricOpp.Quarter__c= LQ4;
                        allQsrMetricOpps.add(qsrMetricOpp); 
                    }
                    if(ocyear == tyear)
                    {
                        mktNnOppClosedWonGenByMkt.Year_To_Date_Count__c = mktNnOppClosedWonGenByMkt.Year_To_Date_Count__c + 1;
                        mktNnOppClosedWonGenByMkt.Year_To_Date_Amount__c = mktNnOppClosedWonGenByMkt.Year_To_Date_Amount__c + cwamt;
                        
                        qsrMetricOpp = new QSR_Metric_Opportunity__c();
                        qsrMetricOpp.Opportunity__c = op.Id;
                        qsrMetricOpp.QSR_Metric_Value__c = mktNnOppClosedWonGenByMkt.Id;
                        qsrMetricOpp.Quarter__c= YTD;
                        allQsrMetricOpps.add(qsrMetricOpp); 
                    }
                }
                
                //If Opp Closed Won and Inf by Mkt
                if(IsSourceMarketing(op.Last_Source__c))
                {
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    
                    if(ocq == CQ)
                    {
                        mktNnOppClosedWonInfByMkt.Current_Quarter_Count__c= mktNnOppClosedWonInfByMkt.Current_Quarter_Count__c + 1;
                        mktNnOppClosedWonInfByMkt.Current_Quarter_Amount__c = mktNnOppClosedWonInfByMkt.Current_Quarter_Amount__c + cwamt;
                        
                        qsrMetricOpp = new QSR_Metric_Opportunity__c();
                        qsrMetricOpp.Opportunity__c = op.Id;
                        qsrMetricOpp.QSR_Metric_Value__c = mktNnOppClosedWonInfByMkt.Id;
                        qsrMetricOpp.Quarter__c= CQ;
                        allQsrMetricOpps.add(qsrMetricOpp); 
                    }
                    if(ocq == LQ1)
                    {                    
                        mktNnOppClosedWonInfByMkt.Last_Quarter_Count__c= mktNnOppClosedWonInfByMkt.Last_Quarter_Count__c + 1;
                        mktNnOppClosedWonInfByMkt.Last_Quarter_Amount__c = mktNnOppClosedWonInfByMkt.Last_Quarter_Amount__c + cwamt;
                        
                        qsrMetricOpp = new QSR_Metric_Opportunity__c();
                        qsrMetricOpp.Opportunity__c = op.Id;
                        qsrMetricOpp.QSR_Metric_Value__c = mktNnOppClosedWonInfByMkt.Id;
                        qsrMetricOpp.Quarter__c= LQ1;
                        allQsrMetricOpps.add(qsrMetricOpp); 
                    }
                    if(ocq == LQ2)
                    {
                        mktNnOppClosedWonInfByMkt.X2nd_Last_Quarter_Count__c= mktNnOppClosedWonInfByMkt.X2nd_Last_Quarter_Count__c + 1;
                        mktNnOppClosedWonInfByMkt.X2nd_Last_Quarter_Amount__c = mktNnOppClosedWonInfByMkt.X2nd_Last_Quarter_Amount__c + cwamt; 
                        
                        qsrMetricOpp = new QSR_Metric_Opportunity__c();
                        qsrMetricOpp.Opportunity__c = op.Id;
                        qsrMetricOpp.QSR_Metric_Value__c = mktNnOppClosedWonInfByMkt.Id;
                        qsrMetricOpp.Quarter__c= LQ2;   
                        allQsrMetricOpps.add(qsrMetricOpp);                 
                    }
                    if(ocq == LQ3)
                    {
                        mktNnOppClosedWonInfByMkt.X3rd_Last_Quarter_Count__c= mktNnOppClosedWonInfByMkt.X3rd_Last_Quarter_Count__c + 1;
                        mktNnOppClosedWonInfByMkt.X3rd_Last_Quarter_Amount__c = mktNnOppClosedWonInfByMkt.X3rd_Last_Quarter_Amount__c + cwamt;
                        
                        qsrMetricOpp = new QSR_Metric_Opportunity__c();
                        qsrMetricOpp.Opportunity__c = op.Id;
                        qsrMetricOpp.QSR_Metric_Value__c = mktNnOppClosedWonInfByMkt.Id;
                        qsrMetricOpp.Quarter__c= LQ3;
                        allQsrMetricOpps.add(qsrMetricOpp); 
                    }
                    if(ocq == LQ4)
                    {
                        mktNnOppClosedWonInfByMkt.X4th_Last_Quarter_Count__c= mktNnOppClosedWonInfByMkt.X4th_Last_Quarter_Count__c + 1;
                        mktNnOppClosedWonInfByMkt.X4th_Last_Quarter_Amount__c = mktNnOppClosedWonInfByMkt.X4th_Last_Quarter_Amount__c + cwamt;
                        
                        qsrMetricOpp = new QSR_Metric_Opportunity__c();
                        qsrMetricOpp.Opportunity__c = op.Id;
                        qsrMetricOpp.QSR_Metric_Value__c = mktNnOppClosedWonInfByMkt.Id;
                        qsrMetricOpp.Quarter__c= LQ4;
                        allQsrMetricOpps.add(qsrMetricOpp); 
                    }
                    if(ocyear == tyear)
                    {
                        mktNnOppClosedWonInfByMkt.Year_To_Date_Count__c = mktNnOppClosedWonInfByMkt.Year_To_Date_Count__c + 1;
                        mktNnOppClosedWonInfByMkt.Year_To_Date_Amount__c = mktNnOppClosedWonInfByMkt.Year_To_Date_Amount__c + cwamt;
                        
                        qsrMetricOpp = new QSR_Metric_Opportunity__c();
                        qsrMetricOpp.Opportunity__c = op.Id;
                        qsrMetricOpp.QSR_Metric_Value__c = mktNnOppClosedWonInfByMkt.Id;
                        qsrMetricOpp.Quarter__c= YTD;
                        allQsrMetricOpps.add(qsrMetricOpp); 
                    }
                }
            }
            
            //All Opps Closed - Nurture - Quarterwise
            if(op.StageName == 'Closed - Nurture')
            {                         
                if(ocq == CQ)
                {
                    mktNnOppClosedNurture.Current_Quarter_Count__c= mktNnOppClosedNurture.Current_Quarter_Count__c + 1;
                    mktNnOppClosedNurture.Current_Quarter_Amount__c = mktNnOppClosedNurture.Current_Quarter_Amount__c + cwamt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = op.Id;
                    qsrMetricOpp.QSR_Metric_Value__c = mktNnOppClosedNurture.Id;
                    qsrMetricOpp.Quarter__c= CQ;
                    allQsrMetricOpps.add(qsrMetricOpp);
                }
                if(ocq == LQ1)
                {                    
                    mktNnOppClosedNurture.Last_Quarter_Count__c= mktNnOppClosedNurture.Last_Quarter_Count__c + 1;
                    mktNnOppClosedNurture.Last_Quarter_Amount__c = mktNnOppClosedNurture.Last_Quarter_Amount__c + cwamt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = op.Id;
                    qsrMetricOpp.QSR_Metric_Value__c = mktNnOppClosedNurture.Id;
                    qsrMetricOpp.Quarter__c= LQ1;
                    allQsrMetricOpps.add(qsrMetricOpp);
                }
                if(ocq == LQ2)
                {
                    mktNnOppClosedNurture.X2nd_Last_Quarter_Count__c= mktNnOppClosedNurture.X2nd_Last_Quarter_Count__c + 1;
                    mktNnOppClosedNurture.X2nd_Last_Quarter_Amount__c = mktNnOppClosedNurture.X2nd_Last_Quarter_Amount__c + cwamt; 
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = op.Id;
                    qsrMetricOpp.QSR_Metric_Value__c = mktNnOppClosedNurture.Id;
                    qsrMetricOpp.Quarter__c= LQ2; 
                    allQsrMetricOpps.add(qsrMetricOpp);                  
                }
                if(ocq == LQ3)
                {
                    mktNnOppClosedNurture.X3rd_Last_Quarter_Count__c= mktNnOppClosedNurture.X3rd_Last_Quarter_Count__c + 1;
                    mktNnOppClosedNurture.X3rd_Last_Quarter_Amount__c = mktNnOppClosedNurture.X3rd_Last_Quarter_Amount__c + cwamt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = op.Id;
                    qsrMetricOpp.QSR_Metric_Value__c = mktNnOppClosedNurture.Id;
                    qsrMetricOpp.Quarter__c= LQ3;
                    allQsrMetricOpps.add(qsrMetricOpp);
                }
                if(ocq == LQ4)
                {
                    mktNnOppClosedNurture.X4th_Last_Quarter_Count__c= mktNnOppClosedNurture.X4th_Last_Quarter_Count__c + 1;
                    mktNnOppClosedNurture.X4th_Last_Quarter_Amount__c = mktNnOppClosedNurture.X4th_Last_Quarter_Amount__c + cwamt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = op.Id;
                    qsrMetricOpp.QSR_Metric_Value__c = mktNnOppClosedNurture.Id;
                    qsrMetricOpp.Quarter__c= LQ4;
                    allQsrMetricOpps.add(qsrMetricOpp);
                }
                if(ocyear == tyear)
                {
                    mktNnOppClosedNurture.Year_To_Date_Count__c = mktNnOppClosedNurture.Year_To_Date_Count__c + 1;
                    mktNnOppClosedNurture.Year_To_Date_Amount__c = mktNnOppClosedNurture.Year_To_Date_Amount__c + cwamt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = op.Id;
                    qsrMetricOpp.QSR_Metric_Value__c = mktNnOppClosedNurture.Id;
                    qsrMetricOpp.Quarter__c= YTD;
                    allQsrMetricOpps.add(qsrMetricOpp);
                }
            }
            
            //All Opps Closed - Not Interested - Quarterwise
            //Closed - Not Interested
            if(op.StageName == 'Closed - Not Interested')
            {                         
                if(ocq == CQ)
                {
                    mktNnOppClosedNotInterested.Current_Quarter_Count__c= mktNnOppClosedNotInterested.Current_Quarter_Count__c + 1;
                    mktNnOppClosedNotInterested.Current_Quarter_Amount__c = mktNnOppClosedNotInterested.Current_Quarter_Amount__c + cwamt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = op.Id;
                    qsrMetricOpp.QSR_Metric_Value__c = mktNnOppClosedNotInterested.Id;
                    qsrMetricOpp.Quarter__c= CQ;
                    allQsrMetricOpps.add(qsrMetricOpp);
                }
                if(ocq == LQ1)
                {                    
                    mktNnOppClosedNotInterested.Last_Quarter_Count__c= mktNnOppClosedNotInterested.Last_Quarter_Count__c + 1;
                    mktNnOppClosedNotInterested.Last_Quarter_Amount__c = mktNnOppClosedNotInterested.Last_Quarter_Amount__c + cwamt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = op.Id;
                    qsrMetricOpp.QSR_Metric_Value__c = mktNnOppClosedNotInterested.Id;
                    qsrMetricOpp.Quarter__c= LQ1;
                    allQsrMetricOpps.add(qsrMetricOpp);
                }
                if(ocq == LQ2)
                {
                    mktNnOppClosedNotInterested.X2nd_Last_Quarter_Count__c= mktNnOppClosedNotInterested.X2nd_Last_Quarter_Count__c + 1;
                    mktNnOppClosedNotInterested.X2nd_Last_Quarter_Amount__c = mktNnOppClosedNotInterested.X2nd_Last_Quarter_Amount__c + cwamt; 
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = op.Id;
                    qsrMetricOpp.QSR_Metric_Value__c = mktNnOppClosedNotInterested.Id;
                    qsrMetricOpp.Quarter__c= LQ2; 
                    allQsrMetricOpps.add(qsrMetricOpp);                  
                }
                if(ocq == LQ3)
                {
                    mktNnOppClosedNotInterested.X3rd_Last_Quarter_Count__c= mktNnOppClosedNotInterested.X3rd_Last_Quarter_Count__c + 1;
                    mktNnOppClosedNotInterested.X3rd_Last_Quarter_Amount__c = mktNnOppClosedNotInterested.X3rd_Last_Quarter_Amount__c + cwamt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = op.Id;
                    qsrMetricOpp.QSR_Metric_Value__c = mktNnOppClosedNotInterested.Id;
                    qsrMetricOpp.Quarter__c= LQ3;
                    allQsrMetricOpps.add(qsrMetricOpp);
                }
                if(ocq == LQ4)
                {
                    mktNnOppClosedNotInterested.X4th_Last_Quarter_Count__c= mktNnOppClosedNotInterested.X4th_Last_Quarter_Count__c + 1;
                    mktNnOppClosedNotInterested.X4th_Last_Quarter_Amount__c = mktNnOppClosedNotInterested.X4th_Last_Quarter_Amount__c + cwamt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = op.Id;
                    qsrMetricOpp.QSR_Metric_Value__c = mktNnOppClosedNotInterested.Id;
                    qsrMetricOpp.Quarter__c= LQ4;
                    allQsrMetricOpps.add(qsrMetricOpp);
                }
                if(ocyear == tyear)
                {
                    mktNnOppClosedNotInterested.Year_To_Date_Count__c = mktNnOppClosedNotInterested.Year_To_Date_Count__c + 1;
                    mktNnOppClosedNotInterested.Year_To_Date_Amount__c = mktNnOppClosedNotInterested.Year_To_Date_Amount__c + cwamt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = op.Id;
                    qsrMetricOpp.QSR_Metric_Value__c = mktNnOppClosedNotInterested.Id;
                    qsrMetricOpp.Quarter__c= YTD;
                    allQsrMetricOpps.add(qsrMetricOpp);
                }
            }
            
            //All Opps Closed - Disqualified - Quarterwise
            if(op.StageName == 'Closed - Disqualified')
            {         
                
                if(ocq == CQ)
                {
                    mktNnOppClosedDisqualified.Current_Quarter_Count__c= mktNnOppClosedDisqualified.Current_Quarter_Count__c + 1;
                    mktNnOppClosedDisqualified.Current_Quarter_Amount__c = mktNnOppClosedDisqualified.Current_Quarter_Amount__c + cwamt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = op.Id;
                    qsrMetricOpp.QSR_Metric_Value__c = mktNnOppClosedDisqualified.Id;
                    qsrMetricOpp.Quarter__c= CQ;
                    allQsrMetricOpps.add(qsrMetricOpp);
                }
                if(ocq == LQ1)
                {                    
                    mktNnOppClosedDisqualified.Last_Quarter_Count__c= mktNnOppClosedDisqualified.Last_Quarter_Count__c + 1;
                    mktNnOppClosedDisqualified.Last_Quarter_Amount__c = mktNnOppClosedDisqualified.Last_Quarter_Amount__c + cwamt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = op.Id;
                    qsrMetricOpp.QSR_Metric_Value__c = mktNnOppClosedDisqualified.Id;
                    qsrMetricOpp.Quarter__c= LQ1;
                    allQsrMetricOpps.add(qsrMetricOpp);
                }
                if(ocq == LQ2)
                {
                    mktNnOppClosedDisqualified.X2nd_Last_Quarter_Count__c= mktNnOppClosedDisqualified.X2nd_Last_Quarter_Count__c + 1;
                    mktNnOppClosedDisqualified.X2nd_Last_Quarter_Amount__c = mktNnOppClosedDisqualified.X2nd_Last_Quarter_Amount__c + cwamt; 
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = op.Id;
                    qsrMetricOpp.QSR_Metric_Value__c = mktNnOppClosedDisqualified.Id;
                    qsrMetricOpp.Quarter__c= LQ2; 
                    allQsrMetricOpps.add(qsrMetricOpp);                  
                }
                if(ocq == LQ3)
                {
                    mktNnOppClosedDisqualified.X3rd_Last_Quarter_Count__c= mktNnOppClosedDisqualified.X3rd_Last_Quarter_Count__c + 1;
                    mktNnOppClosedDisqualified.X3rd_Last_Quarter_Amount__c = mktNnOppClosedDisqualified.X3rd_Last_Quarter_Amount__c + cwamt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = op.Id;
                    qsrMetricOpp.QSR_Metric_Value__c = mktNnOppClosedDisqualified.Id;
                    qsrMetricOpp.Quarter__c= LQ3;
                    allQsrMetricOpps.add(qsrMetricOpp);
                }
                if(ocq == LQ4)
                {
                    mktNnOppClosedDisqualified.X4th_Last_Quarter_Count__c= mktNnOppClosedDisqualified.X4th_Last_Quarter_Count__c + 1;
                    mktNnOppClosedDisqualified.X4th_Last_Quarter_Amount__c = mktNnOppClosedDisqualified.X4th_Last_Quarter_Amount__c + cwamt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = op.Id;
                    qsrMetricOpp.QSR_Metric_Value__c = mktNnOppClosedDisqualified.Id;
                    qsrMetricOpp.Quarter__c= LQ4;
                    allQsrMetricOpps.add(qsrMetricOpp);
                }
                if(ocyear == tyear)
                {
                    mktNnOppClosedDisqualified.Year_To_Date_Count__c = mktNnOppClosedDisqualified.Year_To_Date_Count__c + 1;
                    mktNnOppClosedDisqualified.Year_To_Date_Amount__c = mktNnOppClosedDisqualified.Year_To_Date_Amount__c + cwamt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = op.Id;
                    qsrMetricOpp.QSR_Metric_Value__c = mktNnOppClosedDisqualified.Id;
                    qsrMetricOpp.Quarter__c= YTD;
                    allQsrMetricOpps.add(qsrMetricOpp);
                }
            }
            
        }
        
        allQsrMetricValues = new List<QSR_Metric_Value__c>();
        allQsrMetricValues.Add(mktNnUql);
        allQsrMetricValues.Add(mktNnMql);
        allQsrMetricValues.Add(mktNnCSql);
        allQsrMetricValues.Add(mktNnOppCreated);
        allQsrMetricValues.Add(mktNnOppClosedWon);
        allQsrMetricValues.Add(mktNnOppClosedWonGenByMkt);
        allQsrMetricValues.Add(mktNnOppClosedWonInfByMkt);
        allQsrMetricValues.Add(mktNnOppClosedNurture);
        allQsrMetricValues.Add(mktNnOppClosedNotInterested);
        allQsrMetricValues.Add(mktNnOppClosedDisqualified);
        
        try
        {                
            if(allQsrMetricValues.size() > 0){
                List<Database.UpsertResult> qsrMetricValuesResult = Database.upsert( new List<QSR_Metric_Value__c>(allQsrMetricValues), QSR_Metric_Value__c.External_ID__c);
                system.debug('Method --> GenerateQSRReportMarketing'+ NN_BB + '() --> Updated Value/Row = ' + qsrMetricValuesResult.size());                                
            }
            
            string forDeleteExistingOpp = 'MKT_' + NN_BB + '%';
            List<QSR_Metric_Opportunity__c> qsrOppForDelete = [select id, name, QSR_Metric_Value__r.external_id__c from QSR_Metric_Opportunity__c where QSR_Metric_Value__r.external_id__c like :forDeleteExistingOpp];            
            if(qsrOppForDelete.size() > 0){
                
                system.debug('Method --> GenerateQSRReportMarketing'+ NN_BB + '() --> Deleting = ' + qsrOppForDelete.size());
                QSRReportsDeletionBatch qsrBatch = new QSRReportsDeletionBatch(new List<QSR_Metric_Opportunity__c>(qsrOppForDelete));                
                Id batchId = Database.executeBatch(qsrBatch, 2000);
                system.debug('Method --> GenerateQSRReportMarketing'+ NN_BB + '() --> Del Started Batch Id = ' + string.valueOf(batchId));
            }
            
            if(allQsrMetricOpps.size() > 0){                 
                
                system.debug('Method --> GenerateQSRReportMarketing'+ NN_BB + '() --> Adding New = ' + allQsrMetricOpps.size());  
                QSRReportsUpdaterBatch qsrBatch = new QSRReportsUpdaterBatch(new List<QSR_Metric_Opportunity__c>(allQsrMetricOpps));                
                Id batchId = Database.executeBatch(qsrBatch, 2000);
                system.debug('Method --> GenerateQSRReportMarketing'+ NN_BB + '() --> Updt Started Batch Id = ' + string.valueOf(batchId));               
            }
        }
        catch(DmlException e)
        {
            system.debug('Method --> GenerateQSRReportMarketing'+ NN_BB + '() --> DML Exception Occured post conversion DML');
            system.debug(e);
        }        
        
        
        system.debug('Method --> GenerateQSRReportMarketing'+ NN_BB + '() --> End');
    }
   
    public void GenerateQSRReportMarketingByProductFamily(List<OpportunityFieldHistory> allOppStageHistoryTest, boolean isNewBusiness)
    {
        system.debug('Method --> GenerateQSRReportMarketingByProductFamily() --> Start');
        
        TQ = GetQuarterByMonth(tmonth);        
        system.debug('Input Date Quarter: ' + TQ);
        
        List<OpportunityFieldHistory> allOppStageHistory;
        
        string NN_BB = '';
        if(isNewBusiness)
        {
            NN_BB = 'NN';
        }
        else
        {
            NN_BB = 'BB';
        }
        
        if(Test.isRunningTest())
        {
            allOppStageHistory = allOppStageHistoryTest;            
        }
        else
        {
            if(isNewBusiness)
            {
                allOppStageHistory = [Select OpportunityId, Opportunity.Name, Opportunity.Type, Opportunity.CHB_Amount__c,Opportunity.Product_Family__c,Opportunity.Product_Family__r.Name, OldValue, NewValue, 
                                      IsDeleted, Id, Field, CreatedDate, CreatedById From OpportunityFieldHistory 
                                      where (Field = 'opportunityCreatedFromLead' OR Field = 'created' OR Field = 'StageName') AND Opportunity.Type = 'New Business' AND 
                                      IsDeleted = false AND (Createddate >= :ldt AND Createddate <= :tdt)];
            }
            else 
            {
                allOppStageHistory = [Select OpportunityId, Opportunity.Name, Opportunity.Type, Opportunity.CHB_Amount__c,Opportunity.Product_Family__c,Opportunity.Product_Family__r.Name, OldValue, NewValue, 
                                      IsDeleted, Id, Field, CreatedDate, CreatedById From OpportunityFieldHistory 
                                      where (Field = 'opportunityCreatedFromLead' OR Field = 'created' OR Field = 'StageName') AND Opportunity.Type != 'New Business' AND 
                                      IsDeleted = false AND (Createddate >= :ldt AND Createddate <= :tdt)]; 
            }
        }
        
        
        system.debug('Method --> GenerateQSRReportMarketing ' + NN_BB + '() --> Stage History Opps Records = ' + allOppStageHistory.size());
        
        List<Opportunity> opps = new List<Opportunity>();
        
        if(isNewBusiness)
        {
            opps = [Select Id, Name, Type, CHB_Amount__c, CreatedDate, CreatedById, StageName, CloseDate, First_Source__c, Last_Source__c, Product_Family__c,
                    Product_Family__r.Name, Product_Family__r.Business_Group__c, Product_Family__r.Business_Group__r.Name From Opportunity where Type = 'New Business' 
                    AND (Createddate >= :ldt AND Createddate <= :tdt)];
        }
        else
        {
            opps = [Select Id, Name, Type, CHB_Amount__c, CreatedDate, CreatedById, StageName, CloseDate, First_Source__c, Last_Source__c, Product_Family__c,
                    Product_Family__r.Name, Product_Family__r.Business_Group__c, Product_Family__r.Business_Group__r.Name From Opportunity where Type != 'New Business' 
                    AND (Createddate >= :ldt AND Createddate <= :tdt)];
        }
        
        system.debug('Method --> GenerateQSRReportMarketing ' + NN_BB + '() --> Opps Records = ' + opps.size());
        
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
        List<QSR_Metric_Opportunity__c> allQsrMetricOpps = new List<QSR_Metric_Opportunity__c>();
        Map<String, QSR_Metric_Value__c> allQsrMetricValueMaps = new  Map<String, QSR_Metric_Value__c>();
        
        
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
        
        for(OpportunityFieldHistory ofh : allOppStageHistory)
        {
            
            Datetime odt = ofh.CreatedDate;
            Integer omonth = odt.Month(); //get month
            Integer oyear = odt.Year(); //get year
            
            string lq  = GetOppQuarter(omonth, oyear);
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
        
        
        system.debug('Method --> GenerateQSRReportMarketingByProductFamily' + NN_BB + '() --> First three rows count = ' +allQsrMetricOpps.size());
        
        //All Opps - 
        for(Opportunity op : opps)
        {
            //All Opps Created - Quarterwise
            Datetime odt = op.CreatedDate; 
            Integer omonth = odt.Month(); //get month
            Integer oyear = odt.Year(); //get year
            Double amt = 0;
            if(op.CHB_Amount__c != null)
            {
                amt = op.CHB_Amount__c;
            }
            
            string lq  = GetOppQuarter(omonth, oyear);
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
            
            //All Opps Closed            
            Datetime ocdt = op.CloseDate; 
            Integer ocmonth = ocdt.Month(); //get month
            Integer ocyear = ocdt.Year(); //get year
            Double cwamt = 0;
            if(op.CHB_Amount__c != null)
            {
                cwamt = op.CHB_Amount__c;
            }
            
            string ocq  = GetOppQuarter(ocmonth, ocyear);
            
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
                if(IsSourceMarketing(op.First_Source__c))
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
                if(IsSourceMarketing(op.Last_Source__c))
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
        
        
        try
        {                
            if(allQsrMetricValues.size() > 0){
                List<Database.UpsertResult> qsrMetricValuesResult = Database.upsert( new List<QSR_Metric_Value__c>(allQsrMetricValueMaps.values()), QSR_Metric_Value__c.External_ID__c);
                system.debug('Method --> GenerateQSRReportMarketingByProductFamily' + NN_BB + '() --> Updated Value/Row = ' + qsrMetricValuesResult.size());                                
            }
            
            string forDeleteExistingOpp = 'MKTPF_' + NN_BB + '%';
            List<QSR_Metric_Opportunity__c> qsrOppForDelete = [select id, name, QSR_Metric_Value__r.external_id__c from QSR_Metric_Opportunity__c where QSR_Metric_Value__r.external_id__c like :forDeleteExistingOpp];            
            if(qsrOppForDelete.size() > 0){
                
                system.debug('Method --> GenerateQSRReportMarketingByProductFamily'+ NN_BB + '() --> Deleting = ' + qsrOppForDelete.size());
                QSRReportsDeletionBatch qsrBatch = new QSRReportsDeletionBatch(new List<QSR_Metric_Opportunity__c>(qsrOppForDelete));                
                Id batchId = Database.executeBatch(qsrBatch, 2000);
                system.debug('Method --> GenerateQSRReportMarketingByProductFamily'+ NN_BB + '() --> Del Started Batch Id = ' + string.valueOf(batchId));
            }
            
            if(allQsrMetricOpps.size() > 0){                   
                
                system.debug('Method --> GenerateQSRReportMarketingByProductFamily'+ NN_BB + '() --> Adding New = ' + allQsrMetricOpps.size());  
                //List<Database.SaveResult> qsrMetricOppsResult = Database.insert( new List<QSR_Metric_Opportunity__c>(allQsrMetricOpps));
                QSRReportsUpdaterBatch qsrBatch = new QSRReportsUpdaterBatch(allQsrMetricOpps);                
                Id batchId = Database.executeBatch(qsrBatch, 2000);
                system.debug('Method --> GenerateQSRReportMarketingByProductFamily'+ NN_BB + '() --> Started Batch Id = ' + string.valueOf(batchId));               
                
            }
            
        }
        catch(DmlException e)
        {
            system.debug('Method --> GenerateQSRReportMarketingByProductFamily' + NN_BB + '() --> DML Exception Occured post conversion DML');
            system.debug(e);
        }        
        
        system.debug('Method --> GenerateQSRReportMarketingByProductFamily' + NN_BB + '() --> End');
    }
    
    /*---------Marketing Report Region End--------------*/
    
    /*---------Sales Report Region Start--------------*/
    
    public void GenerateQSRReportSales(List<OpportunityFieldHistory> allOppStageHistoryTest, boolean isNewBusiness)
    {
        system.debug('Method --> GenerateQSRReportSales() --> Start');
        
        string NN_BB = '';
        if(isNewBusiness)
        {
            NN_BB = 'NN';
        }
        else
        {
            NN_BB = 'BB';
        }
        
        TQ = GetQuarterByMonth(tmonth);
        system.debug('Input Date Quarter: ' +TQ);
        
        List<OpportunityFieldHistory> allOppStageHistory = new List<OpportunityFieldHistory>();
        List<Opportunity> opps = new List<Opportunity>();
        
        if(Test.isRunningTest())
        {
            allOppStageHistory = allOppStageHistoryTest;            
        }
        else
        {
            if(isNewBusiness)
            {
                allOppStageHistory = [Select OpportunityId, Opportunity.Name, Opportunity.Type, Opportunity.CHB_Amount__c,Opportunity.Product_Family__c,Opportunity.Product_Family__r.Name, OldValue, NewValue, 
                                      IsDeleted, Id, Field, CreatedDate, CreatedById From OpportunityFieldHistory 
                                      where Field = 'StageName' AND Opportunity.Type = 'New Business' AND 
                                      IsDeleted = false AND (Createddate >= :ldt AND Createddate <= :tdt)];
            }
            else
            {
                allOppStageHistory = [Select OpportunityId, Opportunity.Name, Opportunity.Type, Opportunity.CHB_Amount__c,Opportunity.Product_Family__c,Opportunity.Product_Family__r.Name, OldValue, NewValue, 
                                      IsDeleted, Id, Field, CreatedDate, CreatedById From OpportunityFieldHistory 
                                      where Field = 'StageName' AND Opportunity.Type != 'New Business' AND 
                                      IsDeleted = false AND (Createddate >= :ldt AND Createddate <= :tdt)];
            }
        }
        
        system.debug('Method --> GenerateQSRReportSales ' + NN_BB + '() --> Stage History Opps Records = ' + allOppStageHistory.size());
        
        if(isNewBusiness)
        {
            opps = [Select Id, Name, Type, CHB_Amount__c, CreatedDate, CreatedById, StageName, CloseDate, First_Source__c, 
                    Last_Source__c, Product_Family__c, Product_Family__r.Name, Product_Family__r.Business_Group__c, 
                    Product_Family__r.Business_Group__r.Name From Opportunity where Type = 'New Business' AND StageName like 'Closed%' AND (CloseDate >= :ldt AND CloseDate <= :tdt)];
        }
        else
        {         
            opps = [Select Id, Name, Type, CHB_Amount__c, CreatedDate, CreatedById, StageName, CloseDate, First_Source__c, 
                    Last_Source__c, Product_Family__c, Product_Family__r.Name, Product_Family__r.Business_Group__c, 
                    Product_Family__r.Business_Group__r.Name From Opportunity where Type != 'New Business' AND StageName like 'Closed%' AND (CloseDate >= :ldt AND CloseDate <= :tdt)];
        }
        
        system.debug('Method --> GenerateQSRReportSales ' + NN_BB + '() --> Opps Records = ' + opps.size());
        
        QSR_Metric__c qsrMetric = new QSR_Metric__c();
        qsrMetric.External_ID__c = 'SALES_' + NN_BB;
        qsrMetric.Report_Date_Range__c = string.valueOf(tdt) + ' ==> ' + string.valueOf(ldt) ;
        if(isNewBusiness)
        {
            qsrMetric.Name = 'Sales - New Name';
        }
        else
        {
            qsrMetric.Name = 'Sales - Back to Base';           
        }
        
        try
        {                                        
            Database.UpsertResult qsrMetricResult = Database.upsert(qsrMetric, QSR_Metric__c.External_ID__c);  
            qsrMetric.Id = qsrMetricResult.getId();
        }
        catch(DmlException e)
        {
            system.debug('Method --> GenerateQSRReportSales' + NN_BB + '() --> DML Exception Occured post conversion DML');
            system.debug(e);
        }
        
        List<QSR_Metric_Value__c> allQsrMetricValues = new List<QSR_Metric_Value__c>();
        List<QSR_Metric_Opportunity__c> allQsrMetricOpps = new List<QSR_Metric_Opportunity__c>();
        
        QSR_Metric_Value__c qsrMetricValue1 = new QSR_Metric_Value__c();
        qsrMetricValue1.External_Id__c = 'SALES_' + NN_BB + '_C-SQL';
        qsrMetricValue1.Name = 'Confirmed Sales Qualified';
        qsrMetricValue1.Current_Quarter_Amount__c = 0;
        qsrMetricValue1.Current_Quarter_Count__c = 0;
        qsrMetricValue1.Last_Quarter_Amount__c = 0;
        qsrMetricValue1.Last_Quarter_Count__c = 0;
        qsrMetricValue1.X2nd_Last_Quarter_Amount__c = 0;
        qsrMetricValue1.X2nd_Last_Quarter_Count__c = 0;
        qsrMetricValue1.X3rd_Last_Quarter_Amount__c = 0;
        qsrMetricValue1.X3rd_Last_Quarter_Count__c = 0;
        qsrMetricValue1.X4th_Last_Quarter_Amount__c = 0;
        qsrMetricValue1.X4th_Last_Quarter_Count__c = 0;
        qsrMetricValue1.Year_To_Date_Amount__c = 0;
        qsrMetricValue1.Year_To_Date_Count__c = 0; 
        qsrMetricValue1.Sorting_Order__c = 1;
        qsrMetricValue1.Category__c = 'All';
        qsrMetricValue1.QSR_Metric__c = qsrMetric.Id;        
        qsrMetricValue1.Product_Family_Name__c = 'All';
        qsrMetricValue1.Business_Group_Name__c = 'All';        
        
        allQsrMetricValues.Add(qsrMetricValue1);
        
        QSR_Metric_Value__c qsrMetricValue2 = new QSR_Metric_Value__c();
        qsrMetricValue2.External_Id__c = 'SALES_' + NN_BB + '_SLI';
        qsrMetricValue2.Name = 'Sales Initiated';
        qsrMetricValue2.Current_Quarter_Amount__c = 0;
        qsrMetricValue2.Current_Quarter_Count__c = 0;
        qsrMetricValue2.Last_Quarter_Amount__c = 0;
        qsrMetricValue2.Last_Quarter_Count__c = 0;
        qsrMetricValue2.X2nd_Last_Quarter_Amount__c = 0;
        qsrMetricValue2.X2nd_Last_Quarter_Count__c = 0;
        qsrMetricValue2.X3rd_Last_Quarter_Amount__c = 0;
        qsrMetricValue2.X3rd_Last_Quarter_Count__c = 0;
        qsrMetricValue2.X4th_Last_Quarter_Amount__c = 0;
        qsrMetricValue2.X4th_Last_Quarter_Count__c = 0;
        qsrMetricValue2.Year_To_Date_Amount__c = 0;
        qsrMetricValue2.Year_To_Date_Count__c = 0;
        qsrMetricValue2.Sorting_Order__c = 2;
        qsrMetricValue2.Category__c = 'All';
        qsrMetricValue2.QSR_Metric__c = qsrMetric.Id;        
        qsrMetricValue2.Product_Family_Name__c = 'All';
        qsrMetricValue2.Business_Group_Name__c = 'All';                
        allQsrMetricValues.Add(qsrMetricValue2);
        
        QSR_Metric_Value__c qsrMetricValue3 = new QSR_Metric_Value__c();
        qsrMetricValue3.External_Id__c = 'SALES_' + NN_BB + '_INPROC';
        qsrMetricValue3.Name = 'In Process';
        qsrMetricValue3.Current_Quarter_Amount__c = 0;
        qsrMetricValue3.Current_Quarter_Count__c = 0;
        qsrMetricValue3.Last_Quarter_Amount__c = 0;
        qsrMetricValue3.Last_Quarter_Count__c = 0;
        qsrMetricValue3.X2nd_Last_Quarter_Amount__c = 0;
        qsrMetricValue3.X2nd_Last_Quarter_Count__c = 0;
        qsrMetricValue3.X3rd_Last_Quarter_Amount__c = 0;
        qsrMetricValue3.X3rd_Last_Quarter_Count__c = 0;
        qsrMetricValue3.X4th_Last_Quarter_Amount__c = 0;
        qsrMetricValue3.X4th_Last_Quarter_Count__c = 0;
        qsrMetricValue3.Year_To_Date_Amount__c = 0;
        qsrMetricValue3.Year_To_Date_Count__c = 0;
        qsrMetricValue3.Sorting_Order__c = 3;
        qsrMetricValue3.Category__c = 'All';
        qsrMetricValue3.QSR_Metric__c = qsrMetric.Id;        
        qsrMetricValue3.Product_Family_Name__c = 'All';
        qsrMetricValue3.Business_Group_Name__c = 'All';        
        allQsrMetricValues.Add(qsrMetricValue3);
        
        QSR_Metric_Value__c qsrMetricValue4 = new QSR_Metric_Value__c();
        qsrMetricValue4.External_Id__c = 'SALES_' + NN_BB + '_DEMO';
        qsrMetricValue4.Name = 'Demo';
        qsrMetricValue4.Current_Quarter_Amount__c = 0;
        qsrMetricValue4.Current_Quarter_Count__c = 0;
        qsrMetricValue4.Last_Quarter_Amount__c = 0;
        qsrMetricValue4.Last_Quarter_Count__c = 0;
        qsrMetricValue4.X2nd_Last_Quarter_Amount__c = 0;
        qsrMetricValue4.X2nd_Last_Quarter_Count__c = 0;
        qsrMetricValue4.X3rd_Last_Quarter_Amount__c = 0;
        qsrMetricValue4.X3rd_Last_Quarter_Count__c = 0;
        qsrMetricValue4.X4th_Last_Quarter_Amount__c = 0;
        qsrMetricValue4.X4th_Last_Quarter_Count__c = 0;
        qsrMetricValue4.Year_To_Date_Amount__c = 0;
        qsrMetricValue4.Year_To_Date_Count__c = 0;
        qsrMetricValue4.Sorting_Order__c = 4;
        qsrMetricValue4.Category__c = 'All';
        qsrMetricValue4.QSR_Metric__c = qsrMetric.Id;        
        qsrMetricValue4.Product_Family_Name__c = 'All';
        qsrMetricValue4.Business_Group_Name__c = 'All';        
        allQsrMetricValues.Add(qsrMetricValue4);
        
        QSR_Metric_Value__c qsrMetricValue5 = new QSR_Metric_Value__c();
        qsrMetricValue5.External_Id__c = 'SALES_' + NN_BB + '_PROP_SUBMIT';
        qsrMetricValue5.Name = 'Proposal Submitted';
        qsrMetricValue5.Current_Quarter_Amount__c = 0;
        qsrMetricValue5.Current_Quarter_Count__c = 0;
        qsrMetricValue5.Last_Quarter_Amount__c = 0;
        qsrMetricValue5.Last_Quarter_Count__c = 0;
        qsrMetricValue5.X2nd_Last_Quarter_Amount__c = 0;
        qsrMetricValue5.X2nd_Last_Quarter_Count__c = 0;
        qsrMetricValue5.X3rd_Last_Quarter_Amount__c = 0;
        qsrMetricValue5.X3rd_Last_Quarter_Count__c = 0;
        qsrMetricValue5.X4th_Last_Quarter_Amount__c = 0;
        qsrMetricValue5.X4th_Last_Quarter_Count__c = 0;
        qsrMetricValue5.Year_To_Date_Amount__c = 0;
        qsrMetricValue5.Year_To_Date_Count__c = 0;
        qsrMetricValue5.Sorting_Order__c = 5;
        qsrMetricValue5.Category__c = 'All';
        qsrMetricValue5.QSR_Metric__c = qsrMetric.Id;        
        qsrMetricValue5.Product_Family_Name__c = 'All';
        qsrMetricValue5.Business_Group_Name__c = 'All';        
        allQsrMetricValues.Add(qsrMetricValue5);
        
        QSR_Metric_Value__c qsrMetricValue6 = new QSR_Metric_Value__c();
        qsrMetricValue6.External_Id__c = 'SALES_' + NN_BB + '_SHORLIST';
        qsrMetricValue6.Name = 'Short Listed';
        qsrMetricValue6.Current_Quarter_Amount__c = 0;
        qsrMetricValue6.Current_Quarter_Count__c = 0;
        qsrMetricValue6.Last_Quarter_Amount__c = 0;
        qsrMetricValue6.Last_Quarter_Count__c = 0;
        qsrMetricValue6.X2nd_Last_Quarter_Amount__c = 0;
        qsrMetricValue6.X2nd_Last_Quarter_Count__c = 0;
        qsrMetricValue6.X3rd_Last_Quarter_Amount__c = 0;
        qsrMetricValue6.X3rd_Last_Quarter_Count__c = 0;
        qsrMetricValue6.X4th_Last_Quarter_Amount__c = 0;
        qsrMetricValue6.X4th_Last_Quarter_Count__c = 0;
        qsrMetricValue6.Year_To_Date_Amount__c = 0;
        qsrMetricValue6.Year_To_Date_Count__c = 0;
        qsrMetricValue6.Sorting_Order__c = 6;
        qsrMetricValue6.Category__c = 'All';
        qsrMetricValue6.QSR_Metric__c = qsrMetric.Id;        
        qsrMetricValue6.Product_Family_Name__c = 'All';
        qsrMetricValue6.Business_Group_Name__c = 'All';        
        allQsrMetricValues.Add(qsrMetricValue6);
        
        QSR_Metric_Value__c qsrMetricValue7 = new QSR_Metric_Value__c();
        qsrMetricValue7.External_Id__c = 'SALES_' + NN_BB + '_CONTR_ISSUED';
        qsrMetricValue7.Name = 'Contracts Issued';
        qsrMetricValue7.Current_Quarter_Amount__c = 0;
        qsrMetricValue7.Current_Quarter_Count__c = 0;
        qsrMetricValue7.Last_Quarter_Amount__c = 0;
        qsrMetricValue7.Last_Quarter_Count__c = 0;
        qsrMetricValue7.X2nd_Last_Quarter_Amount__c = 0;
        qsrMetricValue7.X2nd_Last_Quarter_Count__c = 0;
        qsrMetricValue7.X3rd_Last_Quarter_Amount__c = 0;
        qsrMetricValue7.X3rd_Last_Quarter_Count__c = 0;
        qsrMetricValue7.X4th_Last_Quarter_Amount__c = 0;
        qsrMetricValue7.X4th_Last_Quarter_Count__c = 0;
        qsrMetricValue7.Year_To_Date_Amount__c = 0;
        qsrMetricValue7.Year_To_Date_Count__c = 0;
        qsrMetricValue7.Sorting_Order__c = 7;
        qsrMetricValue7.Category__c = 'All';
        qsrMetricValue7.QSR_Metric__c = qsrMetric.Id;        
        qsrMetricValue7.Product_Family_Name__c = 'All';
        qsrMetricValue7.Business_Group_Name__c = 'All';        
        allQsrMetricValues.Add(qsrMetricValue7);
        
        QSR_Metric_Value__c qsrMetricValue8 = new QSR_Metric_Value__c();
        qsrMetricValue8.External_Id__c = 'SALES_' + NN_BB + '_TOTAL_OPEN';
        qsrMetricValue8.Name = 'Total Open';
        qsrMetricValue8.Current_Quarter_Amount__c = 0;
        qsrMetricValue8.Current_Quarter_Count__c = 0;
        qsrMetricValue8.Last_Quarter_Amount__c = 0;
        qsrMetricValue8.Last_Quarter_Count__c = 0;
        qsrMetricValue8.X2nd_Last_Quarter_Amount__c = 0;
        qsrMetricValue8.X2nd_Last_Quarter_Count__c = 0;
        qsrMetricValue8.X3rd_Last_Quarter_Amount__c = 0;
        qsrMetricValue8.X3rd_Last_Quarter_Count__c = 0;
        qsrMetricValue8.X4th_Last_Quarter_Amount__c = 0;
        qsrMetricValue8.X4th_Last_Quarter_Count__c = 0;
        qsrMetricValue8.Year_To_Date_Amount__c = 0;
        qsrMetricValue8.Year_To_Date_Count__c = 0;
        qsrMetricValue8.Sorting_Order__c = 8;
        qsrMetricValue8.Category__c = 'All';
        qsrMetricValue8.QSR_Metric__c = qsrMetric.Id;        
        qsrMetricValue8.Product_Family_Name__c = 'All';
        qsrMetricValue8.Business_Group_Name__c = 'All';        
        allQsrMetricValues.Add(qsrMetricValue8);
        
        QSR_Metric_Value__c qsrMetricValue9 = new QSR_Metric_Value__c();
        qsrMetricValue9.External_Id__c = 'SALES_' + NN_BB + '_TOTAL_CLOSE';
        qsrMetricValue9.Name = 'Total Closed';
        qsrMetricValue9.Current_Quarter_Amount__c = 0;
        qsrMetricValue9.Current_Quarter_Count__c = 0;
        qsrMetricValue9.Last_Quarter_Amount__c = 0;
        qsrMetricValue9.Last_Quarter_Count__c = 0;
        qsrMetricValue9.X2nd_Last_Quarter_Amount__c = 0;
        qsrMetricValue9.X2nd_Last_Quarter_Count__c = 0;
        qsrMetricValue9.X3rd_Last_Quarter_Amount__c = 0;
        qsrMetricValue9.X3rd_Last_Quarter_Count__c = 0;
        qsrMetricValue9.X4th_Last_Quarter_Amount__c = 0;
        qsrMetricValue9.X4th_Last_Quarter_Count__c = 0;
        qsrMetricValue9.Year_To_Date_Amount__c = 0;
        qsrMetricValue9.Year_To_Date_Count__c = 0;
        qsrMetricValue9.Sorting_Order__c = 9;
        qsrMetricValue9.Category__c = 'All';
        qsrMetricValue9.QSR_Metric__c = qsrMetric.Id;        
        qsrMetricValue9.Product_Family_Name__c = 'All';
        qsrMetricValue9.Business_Group_Name__c = 'All';        
        allQsrMetricValues.Add(qsrMetricValue9);
        
        QSR_Metric_Value__c qsrMetricValue10 = new QSR_Metric_Value__c();
        qsrMetricValue10.External_Id__c = 'SALES_' + NN_BB + '_CLOSE_WON';
        qsrMetricValue10.Name = 'Closed Won';
        qsrMetricValue10.Current_Quarter_Amount__c = 0;
        qsrMetricValue10.Current_Quarter_Count__c = 0;
        qsrMetricValue10.Last_Quarter_Amount__c = 0;
        qsrMetricValue10.Last_Quarter_Count__c = 0;
        qsrMetricValue10.X2nd_Last_Quarter_Amount__c = 0;
        qsrMetricValue10.X2nd_Last_Quarter_Count__c = 0;
        qsrMetricValue10.X3rd_Last_Quarter_Amount__c = 0;
        qsrMetricValue10.X3rd_Last_Quarter_Count__c = 0;
        qsrMetricValue10.X4th_Last_Quarter_Amount__c = 0;
        qsrMetricValue10.X4th_Last_Quarter_Count__c = 0;
        qsrMetricValue10.Year_To_Date_Amount__c = 0;
        qsrMetricValue10.Year_To_Date_Count__c = 0;
        qsrMetricValue10.Sorting_Order__c = 10;
        qsrMetricValue10.Category__c = 'All';
        qsrMetricValue10.QSR_Metric__c = qsrMetric.Id;        
        qsrMetricValue10.Product_Family_Name__c = 'All';
        qsrMetricValue10.Business_Group_Name__c = 'All';        
        allQsrMetricValues.Add(qsrMetricValue10);
        
        QSR_Metric_Value__c qsrMetricValue11 = new QSR_Metric_Value__c();
        qsrMetricValue11.External_Id__c = 'SALES_' + NN_BB + '_CLOSE_LOST';
        qsrMetricValue11.Name = 'Closed Lost';
        qsrMetricValue11.Current_Quarter_Amount__c = 0;
        qsrMetricValue11.Current_Quarter_Count__c = 0;
        qsrMetricValue11.Last_Quarter_Amount__c = 0;
        qsrMetricValue11.Last_Quarter_Count__c = 0;
        qsrMetricValue11.X2nd_Last_Quarter_Amount__c = 0;
        qsrMetricValue11.X2nd_Last_Quarter_Count__c = 0;
        qsrMetricValue11.X3rd_Last_Quarter_Amount__c = 0;
        qsrMetricValue11.X3rd_Last_Quarter_Count__c = 0;
        qsrMetricValue11.X4th_Last_Quarter_Amount__c = 0;
        qsrMetricValue11.X4th_Last_Quarter_Count__c = 0;
        qsrMetricValue11.Year_To_Date_Amount__c = 0;
        qsrMetricValue11.Year_To_Date_Count__c = 0;
        qsrMetricValue11.Sorting_Order__c = 11;
        qsrMetricValue11.Category__c = 'All';
        qsrMetricValue11.QSR_Metric__c = qsrMetric.Id;        
        qsrMetricValue11.Product_Family_Name__c = 'All';
        qsrMetricValue11.Business_Group_Name__c = 'All';        
        allQsrMetricValues.Add(qsrMetricValue11);
        
        QSR_Metric_Value__c qsrMetricValue12 = new QSR_Metric_Value__c();
        qsrMetricValue12.External_Id__c = 'SALES_' + NN_BB + '_CLOSE_NO_DEC';
        qsrMetricValue12.Name = 'Closed No Decision';
        qsrMetricValue12.Current_Quarter_Amount__c = 0;
        qsrMetricValue12.Current_Quarter_Count__c = 0;
        qsrMetricValue12.Last_Quarter_Amount__c = 0;
        qsrMetricValue12.Last_Quarter_Count__c = 0;
        qsrMetricValue12.X2nd_Last_Quarter_Amount__c = 0;
        qsrMetricValue12.X2nd_Last_Quarter_Count__c = 0;
        qsrMetricValue12.X3rd_Last_Quarter_Amount__c = 0;
        qsrMetricValue12.X3rd_Last_Quarter_Count__c = 0;
        qsrMetricValue12.X4th_Last_Quarter_Amount__c = 0;
        qsrMetricValue12.X4th_Last_Quarter_Count__c = 0;
        qsrMetricValue12.Year_To_Date_Amount__c = 0;
        qsrMetricValue12.Year_To_Date_Count__c = 0;
        qsrMetricValue12.Sorting_Order__c = 12;
        qsrMetricValue12.Category__c = 'All';
        qsrMetricValue12.QSR_Metric__c = qsrMetric.Id;        
        qsrMetricValue12.Product_Family_Name__c = 'All';
        qsrMetricValue12.Business_Group_Name__c = 'All';        
        allQsrMetricValues.Add(qsrMetricValue12);
        
        QSR_Metric_Value__c qsrMetricValue13 = new QSR_Metric_Value__c();
        qsrMetricValue13.External_Id__c = 'SALES_' + NN_BB + '_CLOSE_DISQUALIFIED';
        qsrMetricValue13.Name = 'Closed Disqualified';
        qsrMetricValue13.Current_Quarter_Amount__c = 0;
        qsrMetricValue13.Current_Quarter_Count__c = 0;
        qsrMetricValue13.Last_Quarter_Amount__c = 0;
        qsrMetricValue13.Last_Quarter_Count__c = 0;
        qsrMetricValue13.X2nd_Last_Quarter_Amount__c = 0;
        qsrMetricValue13.X2nd_Last_Quarter_Count__c = 0;
        qsrMetricValue13.X3rd_Last_Quarter_Amount__c = 0;
        qsrMetricValue13.X3rd_Last_Quarter_Count__c = 0;
        qsrMetricValue13.X4th_Last_Quarter_Amount__c = 0;
        qsrMetricValue13.X4th_Last_Quarter_Count__c = 0;
        qsrMetricValue13.Year_To_Date_Amount__c = 0;
        qsrMetricValue13.Year_To_Date_Count__c = 0;
        qsrMetricValue13.Sorting_Order__c = 13;
        qsrMetricValue13.Category__c = 'All';
        qsrMetricValue13.QSR_Metric__c = qsrMetric.Id;        
        qsrMetricValue13.Product_Family_Name__c = 'All';
        qsrMetricValue13.Business_Group_Name__c = 'All';        
        allQsrMetricValues.Add(qsrMetricValue13);
        
        try
        {                            
            if(allQsrMetricValues.size() > 0){
                List<Database.UpsertResult> qsrMetricValuesResult = Database.upsert( new List<QSR_Metric_Value__c>(allQsrMetricValues), QSR_Metric_Value__c.External_ID__c);
                system.debug('Method --> GenerateQSRReportSales'+ NN_BB + '() --> Upserting QSR Value/Row = ' + qsrMetricValuesResult.size());
            }            
        }
        catch(DmlException e)
        {
            system.debug('Method --> GenerateQSRReportSales' + NN_BB + '() --> DML Exception Occured post conversion DML');
            system.debug(e);
        }  
        
        for(OpportunityFieldHistory ofh : allOppStageHistory)
        {
            Datetime odt = ofh.CreatedDate;
            Integer omonth = odt.Month(); //get month
            Integer oyear = odt.Year(); //get year
            
            string lq  = GetOppQuarter(omonth, oyear);
            double ofhOppAmt = 0;
            if(ofh.Opportunity.CHB_Amount__c != null)
            {
                ofhOppAmt = ofh.Opportunity.CHB_Amount__c;
            }
            
            if(ofh.NewValue == Confirmed_SQL)
            {
                QSR_Metric_Opportunity__c qsrMetricOpp = new QSR_Metric_Opportunity__c();
                
                if(lq == CQ)
                {
                    qsrMetricValue1.Current_Quarter_Count__c= qsrMetricValue1.Current_Quarter_Count__c + 1;
                    qsrMetricValue1.Current_Quarter_Amount__c = qsrMetricValue1.Current_Quarter_Amount__c + ofhOppAmt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = ofh.OpportunityId;
                    qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue1.Id;
                    
                    qsrMetricOpp.Quarter__c  = CQ;
                    allQsrMetricOpps.Add(qsrMetricOpp);
                }
                if(lq == LQ1)
                {                    
                    qsrMetricValue1.Last_Quarter_Count__c= qsrMetricValue1.Last_Quarter_Count__c + 1;
                    qsrMetricValue1.Last_Quarter_Amount__c = qsrMetricValue1.Last_Quarter_Amount__c + ofhOppAmt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = ofh.OpportunityId;
                    qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue1.Id;
                    qsrMetricOpp.Quarter__c = LQ1;
                    allQsrMetricOpps.Add(qsrMetricOpp);
                }
                if(lq == LQ2)
                {
                    qsrMetricValue1.X2nd_Last_Quarter_Count__c= qsrMetricValue1.X2nd_Last_Quarter_Count__c + 1;
                    qsrMetricValue1.X2nd_Last_Quarter_Amount__c = qsrMetricValue1.X2nd_Last_Quarter_Amount__c + ofhOppAmt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = ofh.OpportunityId;
                    qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue1.Id;
                    qsrMetricOpp.Quarter__c = LQ2;  
                    allQsrMetricOpps.Add(qsrMetricOpp);                  
                }
                if(lq == LQ3)
                {
                    qsrMetricValue1.X3rd_Last_Quarter_Count__c= qsrMetricValue1.X3rd_Last_Quarter_Count__c + 1;
                    qsrMetricValue1.X3rd_Last_Quarter_Amount__c = qsrMetricValue1.X3rd_Last_Quarter_Amount__c + ofhOppAmt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = ofh.OpportunityId;
                    qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue1.Id;
                    qsrMetricOpp.Quarter__c = LQ3;
                    allQsrMetricOpps.Add(qsrMetricOpp);
                }
                if(lq == LQ4)
                {
                    qsrMetricValue1.X4th_Last_Quarter_Count__c= qsrMetricValue1.X4th_Last_Quarter_Count__c + 1;
                    qsrMetricValue1.X4th_Last_Quarter_Amount__c = qsrMetricValue1.X4th_Last_Quarter_Amount__c + ofhOppAmt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = ofh.OpportunityId;
                    qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue1.Id;
                    qsrMetricOpp.Quarter__c = LQ4;
                    allQsrMetricOpps.Add(qsrMetricOpp);
                }
                if(oyear == tyear)
                {
                    qsrMetricValue1.Year_To_Date_Count__c= qsrMetricValue1.Year_To_Date_Count__c + 1;
                    qsrMetricValue1.Year_To_Date_Amount__c = qsrMetricValue1.Year_To_Date_Amount__c + ofhOppAmt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = ofh.OpportunityId;
                    qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue1.Id;
                    qsrMetricOpp.Quarter__c = YTD;
                    allQsrMetricOpps.Add(qsrMetricOpp);
                }
            }
            
            if(ofh.NewValue == Sales_Initiated)
            {             
                QSR_Metric_Opportunity__c qsrMetricOpp = new QSR_Metric_Opportunity__c();
                
                if(lq == CQ)
                {
                    qsrMetricValue2.Current_Quarter_Count__c= qsrMetricValue2.Current_Quarter_Count__c + 1;
                    qsrMetricValue2.Current_Quarter_Amount__c = qsrMetricValue2.Current_Quarter_Amount__c + ofhOppAmt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = ofh.OpportunityId;
                    qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue2.Id;
                    qsrMetricOpp.Quarter__c = CQ;
                    allQsrMetricOpps.Add(qsrMetricOpp);
                }
                if(lq == LQ1)
                {                    
                    qsrMetricValue2.Last_Quarter_Count__c= qsrMetricValue2.Last_Quarter_Count__c + 1;
                    qsrMetricValue2.Last_Quarter_Amount__c = qsrMetricValue2.Last_Quarter_Amount__c + ofhOppAmt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = ofh.OpportunityId;
                    qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue2.Id;
                    qsrMetricOpp.Quarter__c = LQ1;
                    allQsrMetricOpps.Add(qsrMetricOpp);
                }
                if(lq == LQ2)
                {
                    qsrMetricValue2.X2nd_Last_Quarter_Count__c= qsrMetricValue2.X2nd_Last_Quarter_Count__c + 1;
                    qsrMetricValue2.X2nd_Last_Quarter_Amount__c = qsrMetricValue2.X2nd_Last_Quarter_Amount__c + ofhOppAmt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = ofh.OpportunityId;
                    qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue2.Id;
                    qsrMetricOpp.Quarter__c = LQ2;
                    allQsrMetricOpps.Add(qsrMetricOpp);                    
                }
                if(lq == LQ3)
                {
                    qsrMetricValue2.X3rd_Last_Quarter_Count__c= qsrMetricValue2.X3rd_Last_Quarter_Count__c + 1;
                    qsrMetricValue2.X3rd_Last_Quarter_Amount__c = qsrMetricValue2.X3rd_Last_Quarter_Amount__c + ofhOppAmt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = ofh.OpportunityId;
                    qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue2.Id;
                    qsrMetricOpp.Quarter__c = LQ3;
                    allQsrMetricOpps.Add(qsrMetricOpp);
                }
                if(lq == LQ4)
                {
                    qsrMetricValue2.X4th_Last_Quarter_Count__c= qsrMetricValue2.X4th_Last_Quarter_Count__c + 1;
                    qsrMetricValue2.X4th_Last_Quarter_Amount__c = qsrMetricValue2.X4th_Last_Quarter_Amount__c + ofhOppAmt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = ofh.OpportunityId;
                    qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue2.Id;
                    qsrMetricOpp.Quarter__c = LQ4;
                    allQsrMetricOpps.Add(qsrMetricOpp);
                }
                if(oyear == tyear)
                {
                    qsrMetricValue2.Year_To_Date_Count__c= qsrMetricValue2.Year_To_Date_Count__c + 1;
                    qsrMetricValue2.Year_To_Date_Amount__c = qsrMetricValue2.Year_To_Date_Amount__c + ofhOppAmt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = ofh.OpportunityId;
                    qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue2.Id;
                    qsrMetricOpp.Quarter__c = YTD;
                    allQsrMetricOpps.Add(qsrMetricOpp);
                } 
            }
            
            if(ofh.NewValue == In_Process)
            {                                
                QSR_Metric_Opportunity__c qsrMetricOpp = new QSR_Metric_Opportunity__c();
                
                if(lq == CQ)
                {
                    qsrMetricValue3.Current_Quarter_Count__c= qsrMetricValue3.Current_Quarter_Count__c + 1;
                    qsrMetricValue3.Current_Quarter_Amount__c = qsrMetricValue3.Current_Quarter_Amount__c + ofhOppAmt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = ofh.OpportunityId;
                    qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue3.Id;
                    qsrMetricOpp.Quarter__c = CQ;
                    allQsrMetricOpps.Add(qsrMetricOpp);
                }
                if(lq == LQ1)
                {                    
                    qsrMetricValue3.Last_Quarter_Count__c= qsrMetricValue3.Last_Quarter_Count__c + 1;
                    qsrMetricValue3.Last_Quarter_Amount__c = qsrMetricValue3.Last_Quarter_Amount__c + ofhOppAmt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = ofh.OpportunityId;
                    qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue3.Id;
                    qsrMetricOpp.Quarter__c = LQ1;
                    allQsrMetricOpps.Add(qsrMetricOpp);
                }
                if(lq == LQ2)
                {
                    qsrMetricValue3.X2nd_Last_Quarter_Count__c= qsrMetricValue3.X2nd_Last_Quarter_Count__c + 1;
                    qsrMetricValue3.X2nd_Last_Quarter_Amount__c = qsrMetricValue3.X2nd_Last_Quarter_Amount__c + ofhOppAmt; 
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = ofh.OpportunityId;
                    qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue3.Id;
                    qsrMetricOpp.Quarter__c = LQ2; 
                    allQsrMetricOpps.Add(qsrMetricOpp);                  
                }
                if(lq == LQ3)
                {
                    qsrMetricValue3.X3rd_Last_Quarter_Count__c= qsrMetricValue3.X3rd_Last_Quarter_Count__c + 1;
                    qsrMetricValue3.X3rd_Last_Quarter_Amount__c = qsrMetricValue3.X3rd_Last_Quarter_Amount__c + ofhOppAmt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = ofh.OpportunityId;
                    qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue3.Id;
                    qsrMetricOpp.Quarter__c = LQ3;
                    allQsrMetricOpps.Add(qsrMetricOpp);
                }
                if(lq == LQ4)
                {
                    qsrMetricValue3.X4th_Last_Quarter_Count__c= qsrMetricValue3.X4th_Last_Quarter_Count__c + 1;
                    qsrMetricValue3.X4th_Last_Quarter_Amount__c = qsrMetricValue3.X4th_Last_Quarter_Amount__c + ofhOppAmt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = ofh.OpportunityId;
                    qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue3.Id;
                    qsrMetricOpp.Quarter__c = LQ4;
                    allQsrMetricOpps.Add(qsrMetricOpp);
                }
                if(oyear == tyear)
                {
                    qsrMetricValue3.Year_To_Date_Count__c= qsrMetricValue3.Year_To_Date_Count__c + 1;
                    qsrMetricValue3.Year_To_Date_Amount__c = qsrMetricValue3.Year_To_Date_Amount__c + ofhOppAmt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = ofh.OpportunityId;
                    qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue3.Id;
                    qsrMetricOpp.Quarter__c = YTD;
                    allQsrMetricOpps.Add(qsrMetricOpp);
                }               
            } 
            
            if(ofh.NewValue == Demo)
            {              
                QSR_Metric_Opportunity__c qsrMetricOpp = new QSR_Metric_Opportunity__c();
                
                if(lq == CQ)
                {
                    qsrMetricValue4.Current_Quarter_Count__c= qsrMetricValue4.Current_Quarter_Count__c + 1;
                    qsrMetricValue4.Current_Quarter_Amount__c = qsrMetricValue4.Current_Quarter_Amount__c + ofhOppAmt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = ofh.OpportunityId;
                    qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue4.Id;
                    qsrMetricOpp.Quarter__c = CQ;
                    allQsrMetricOpps.Add(qsrMetricOpp);
                }
                if(lq == LQ1)
                {                    
                    qsrMetricValue4.Last_Quarter_Count__c= qsrMetricValue4.Last_Quarter_Count__c + 1;
                    qsrMetricValue4.Last_Quarter_Amount__c = qsrMetricValue4.Last_Quarter_Amount__c + ofhOppAmt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = ofh.OpportunityId;
                    qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue4.Id;
                    qsrMetricOpp.Quarter__c = LQ1;
                    allQsrMetricOpps.Add(qsrMetricOpp);
                }
                if(lq == LQ2)
                {
                    qsrMetricValue4.X2nd_Last_Quarter_Count__c= qsrMetricValue4.X2nd_Last_Quarter_Count__c + 1;
                    qsrMetricValue4.X2nd_Last_Quarter_Amount__c = qsrMetricValue4.X2nd_Last_Quarter_Amount__c + ofhOppAmt; 
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = ofh.OpportunityId;
                    qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue4.Id;
                    qsrMetricOpp.Quarter__c = LQ2;  
                    allQsrMetricOpps.Add(qsrMetricOpp);                 
                }
                if(lq == LQ3)
                {
                    qsrMetricValue4.X3rd_Last_Quarter_Count__c= qsrMetricValue4.X3rd_Last_Quarter_Count__c + 1;
                    qsrMetricValue4.X3rd_Last_Quarter_Amount__c = qsrMetricValue4.X3rd_Last_Quarter_Amount__c + ofhOppAmt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = ofh.OpportunityId;
                    qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue4.Id;
                    qsrMetricOpp.Quarter__c = LQ3;
                    allQsrMetricOpps.Add(qsrMetricOpp);
                }
                if(lq == LQ4)
                {
                    qsrMetricValue4.X4th_Last_Quarter_Count__c= qsrMetricValue4.X4th_Last_Quarter_Count__c + 1;
                    qsrMetricValue4.X4th_Last_Quarter_Amount__c = qsrMetricValue4.X4th_Last_Quarter_Amount__c + ofhOppAmt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = ofh.OpportunityId;
                    qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue4.Id;
                    qsrMetricOpp.Quarter__c = LQ4;
                    allQsrMetricOpps.Add(qsrMetricOpp);
                }
                if(oyear == tyear)
                {
                    qsrMetricValue4.Year_To_Date_Count__c= qsrMetricValue4.Year_To_Date_Count__c + 1;
                    qsrMetricValue4.Year_To_Date_Amount__c = qsrMetricValue4.Year_To_Date_Amount__c + ofhOppAmt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = ofh.OpportunityId;
                    qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue4.Id;
                    qsrMetricOpp.Quarter__c = YTD;
                    allQsrMetricOpps.Add(qsrMetricOpp);
                }               
            } 
            
            if(ofh.NewValue == Proposal_Submitted)
            {
                QSR_Metric_Opportunity__c qsrMetricOpp = new QSR_Metric_Opportunity__c();
                
                if(lq == CQ)
                {
                    qsrMetricValue5.Current_Quarter_Count__c= qsrMetricValue5.Current_Quarter_Count__c + 1;
                    qsrMetricValue5.Current_Quarter_Amount__c = qsrMetricValue5.Current_Quarter_Amount__c + ofhOppAmt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = ofh.OpportunityId;
                    qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue5.Id;
                    qsrMetricOpp.Quarter__c = CQ;
                    allQsrMetricOpps.Add(qsrMetricOpp);
                }
                if(lq == LQ1)
                {                    
                    qsrMetricValue5.Last_Quarter_Count__c= qsrMetricValue5.Last_Quarter_Count__c + 1;
                    qsrMetricValue5.Last_Quarter_Amount__c = qsrMetricValue5.Last_Quarter_Amount__c + ofhOppAmt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = ofh.OpportunityId;
                    qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue5.Id;
                    qsrMetricOpp.Quarter__c = LQ1;
                    allQsrMetricOpps.Add(qsrMetricOpp);
                }
                if(lq == LQ2)
                {
                    qsrMetricValue5.X2nd_Last_Quarter_Count__c= qsrMetricValue5.X2nd_Last_Quarter_Count__c + 1;
                    qsrMetricValue5.X2nd_Last_Quarter_Amount__c = qsrMetricValue5.X2nd_Last_Quarter_Amount__c + ofhOppAmt; 
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = ofh.OpportunityId;
                    qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue5.Id;
                    qsrMetricOpp.Quarter__c = LQ2;
                    allQsrMetricOpps.Add(qsrMetricOpp);                   
                }
                if(lq == LQ3)
                {
                    qsrMetricValue5.X3rd_Last_Quarter_Count__c= qsrMetricValue5.X3rd_Last_Quarter_Count__c + 1;
                    qsrMetricValue5.X3rd_Last_Quarter_Amount__c = qsrMetricValue5.X3rd_Last_Quarter_Amount__c + ofhOppAmt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = ofh.OpportunityId;
                    qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue5.Id;
                    qsrMetricOpp.Quarter__c = LQ3;
                    allQsrMetricOpps.Add(qsrMetricOpp);
                }
                if(lq == LQ4)
                {
                    qsrMetricValue5.X4th_Last_Quarter_Count__c= qsrMetricValue5.X4th_Last_Quarter_Count__c + 1;
                    qsrMetricValue5.X4th_Last_Quarter_Amount__c = qsrMetricValue5.X4th_Last_Quarter_Amount__c + ofhOppAmt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = ofh.OpportunityId;
                    qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue5.Id;
                    qsrMetricOpp.Quarter__c = LQ4;
                    allQsrMetricOpps.Add(qsrMetricOpp);
                }
                if(oyear == tyear)
                {
                    qsrMetricValue5.Year_To_Date_Count__c= qsrMetricValue5.Year_To_Date_Count__c + 1;
                    qsrMetricValue5.Year_To_Date_Amount__c = qsrMetricValue5.Year_To_Date_Amount__c + ofhOppAmt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = ofh.OpportunityId;
                    qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue5.Id;
                    qsrMetricOpp.Quarter__c = YTD;
                    allQsrMetricOpps.Add(qsrMetricOpp);
                }              
            }
            
            if(ofh.NewValue == Short_Listed)
            {
                QSR_Metric_Opportunity__c qsrMetricOpp = new QSR_Metric_Opportunity__c();
                
                if(lq == CQ)
                {
                    qsrMetricValue6.Current_Quarter_Count__c= qsrMetricValue6.Current_Quarter_Count__c + 1;
                    qsrMetricValue6.Current_Quarter_Amount__c = qsrMetricValue6.Current_Quarter_Amount__c + ofhOppAmt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = ofh.OpportunityId;
                    qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue6.Id;
                    qsrMetricOpp.Quarter__c = CQ;
                    allQsrMetricOpps.Add(qsrMetricOpp);
                }
                if(lq == LQ1)
                {                    
                    qsrMetricValue6.Last_Quarter_Count__c= qsrMetricValue6.Last_Quarter_Count__c + 1;
                    qsrMetricValue6.Last_Quarter_Amount__c = qsrMetricValue6.Last_Quarter_Amount__c + ofhOppAmt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = ofh.OpportunityId;
                    qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue6.Id;
                    qsrMetricOpp.Quarter__c = LQ1;
                    allQsrMetricOpps.Add(qsrMetricOpp);
                }
                if(lq == LQ2)
                {
                    qsrMetricValue6.X2nd_Last_Quarter_Count__c= qsrMetricValue6.X2nd_Last_Quarter_Count__c + 1;
                    qsrMetricValue6.X2nd_Last_Quarter_Amount__c = qsrMetricValue6.X2nd_Last_Quarter_Amount__c + ofhOppAmt; 
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = ofh.OpportunityId;
                    qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue6.Id;
                    qsrMetricOpp.Quarter__c = LQ2;
                    allQsrMetricOpps.Add(qsrMetricOpp);                   
                }
                if(lq == LQ3)
                {
                    qsrMetricValue6.X3rd_Last_Quarter_Count__c= qsrMetricValue6.X3rd_Last_Quarter_Count__c + 1;
                    qsrMetricValue6.X3rd_Last_Quarter_Amount__c = qsrMetricValue6.X3rd_Last_Quarter_Amount__c + ofhOppAmt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = ofh.OpportunityId;
                    qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue6.Id;
                    qsrMetricOpp.Quarter__c = LQ3;
                    allQsrMetricOpps.Add(qsrMetricOpp);
                }
                if(lq == LQ4)
                {
                    qsrMetricValue6.X4th_Last_Quarter_Count__c= qsrMetricValue6.X4th_Last_Quarter_Count__c + 1;
                    qsrMetricValue6.X4th_Last_Quarter_Amount__c = qsrMetricValue6.X4th_Last_Quarter_Amount__c + ofhOppAmt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = ofh.OpportunityId;
                    qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue6.Id;
                    qsrMetricOpp.Quarter__c = LQ4;
                    allQsrMetricOpps.Add(qsrMetricOpp);
                }
                if(oyear == tyear)
                {
                    qsrMetricValue6.Year_To_Date_Count__c= qsrMetricValue6.Year_To_Date_Count__c + 1;
                    qsrMetricValue6.Year_To_Date_Amount__c = qsrMetricValue6.Year_To_Date_Amount__c + ofhOppAmt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = ofh.OpportunityId;
                    qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue6.Id;
                    qsrMetricOpp.Quarter__c = YTD;
                    allQsrMetricOpps.Add(qsrMetricOpp);
                }               
            }
            
            if(ofh.NewValue == Contract_Issued)
            {
                QSR_Metric_Opportunity__c qsrMetricOpp = new QSR_Metric_Opportunity__c();
                
                qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue7.Id;
                
                if(lq == CQ)
                {
                    qsrMetricValue7.Current_Quarter_Count__c= qsrMetricValue7.Current_Quarter_Count__c + 1;
                    qsrMetricValue7.Current_Quarter_Amount__c = qsrMetricValue7.Current_Quarter_Amount__c + ofhOppAmt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = ofh.OpportunityId;
                    qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue7.Id;
                    qsrMetricOpp.Quarter__c = CQ;
                    allQsrMetricOpps.Add(qsrMetricOpp);
                }
                if(lq == LQ1)
                {                    
                    qsrMetricValue7.Last_Quarter_Count__c= qsrMetricValue7.Last_Quarter_Count__c + 1;
                    qsrMetricValue7.Last_Quarter_Amount__c = qsrMetricValue7.Last_Quarter_Amount__c + ofhOppAmt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = ofh.OpportunityId;
                    qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue7.Id;
                    qsrMetricOpp.Quarter__c = LQ1;
                    allQsrMetricOpps.Add(qsrMetricOpp);
                }
                if(lq == LQ2)
                {
                    qsrMetricValue7.X2nd_Last_Quarter_Count__c= qsrMetricValue7.X2nd_Last_Quarter_Count__c + 1;
                    qsrMetricValue7.X2nd_Last_Quarter_Amount__c = qsrMetricValue7.X2nd_Last_Quarter_Amount__c + ofhOppAmt; 
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = ofh.OpportunityId;
                    qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue7.Id;
                    qsrMetricOpp.Quarter__c = LQ2; 
                    allQsrMetricOpps.Add(qsrMetricOpp);                  
                }
                if(lq == LQ3)
                {
                    qsrMetricValue7.X3rd_Last_Quarter_Count__c= qsrMetricValue7.X3rd_Last_Quarter_Count__c + 1;
                    qsrMetricValue7.X3rd_Last_Quarter_Amount__c = qsrMetricValue7.X3rd_Last_Quarter_Amount__c + ofhOppAmt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = ofh.OpportunityId;
                    qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue7.Id;
                    qsrMetricOpp.Quarter__c = LQ3;
                    allQsrMetricOpps.Add(qsrMetricOpp);
                }
                if(lq == LQ4)
                {
                    qsrMetricValue7.X4th_Last_Quarter_Count__c= qsrMetricValue7.X4th_Last_Quarter_Count__c + 1;
                    qsrMetricValue7.X4th_Last_Quarter_Amount__c = qsrMetricValue7.X4th_Last_Quarter_Amount__c + ofhOppAmt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = ofh.OpportunityId;
                    qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue7.Id;
                    qsrMetricOpp.Quarter__c = LQ4;
                    allQsrMetricOpps.Add(qsrMetricOpp);
                }
                if(oyear == tyear)
                {
                    qsrMetricValue7.Year_To_Date_Count__c= qsrMetricValue7.Year_To_Date_Count__c + 1;
                    qsrMetricValue7.Year_To_Date_Amount__c = qsrMetricValue7.Year_To_Date_Amount__c + ofhOppAmt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = ofh.OpportunityId;
                    qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue7.Id;
                    qsrMetricOpp.Quarter__c = YTD;
                    allQsrMetricOpps.Add(qsrMetricOpp);
                }               
            }
        }
        
        
        system.debug('Method --> GenerateQSRReportSales' + NN_BB + '() --> All Opp Counts from History = ' + allQsrMetricOpps.size());
        
        //All Opps
        for(Opportunity op : opps)
        {
            //All Opps Closed            
            Datetime ocdt = op.CloseDate; 
            Integer ocmonth = ocdt.Month(); //get month
            Integer ocyear = ocdt.Year(); //get year
            Double cwamt = 0;
            if(op.CHB_Amount__c != null)
            {
                cwamt = op.CHB_Amount__c;
            }
            
            string ocq  = GetOppQuarter(ocmonth, ocyear);
            
            
            if(op.StageName == Closed_Won)
            {         
                QSR_Metric_Opportunity__c qsrMetricOpp = new QSR_Metric_Opportunity__c();
                
                if(ocq == CQ)
                {
                    qsrMetricValue10.Current_Quarter_Count__c= qsrMetricValue10.Current_Quarter_Count__c + 1;
                    qsrMetricValue10.Current_Quarter_Amount__c = qsrMetricValue10.Current_Quarter_Amount__c + cwamt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = op.Id;
                    qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue10.Id;
                    qsrMetricOpp.Quarter__c= CQ;
                    allQsrMetricOpps.Add(qsrMetricOpp);
                }
                if(ocq == LQ1)
                {                    
                    qsrMetricValue10.Last_Quarter_Count__c= qsrMetricValue10.Last_Quarter_Count__c + 1;
                    qsrMetricValue10.Last_Quarter_Amount__c = qsrMetricValue10.Last_Quarter_Amount__c + cwamt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = op.Id;
                    qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue10.Id;
                    qsrMetricOpp.Quarter__c= LQ1;
                    allQsrMetricOpps.Add(qsrMetricOpp);
                }
                if(ocq == LQ2)
                {
                    qsrMetricValue10.X2nd_Last_Quarter_Count__c= qsrMetricValue10.X2nd_Last_Quarter_Count__c + 1;
                    qsrMetricValue10.X2nd_Last_Quarter_Amount__c = qsrMetricValue10.X2nd_Last_Quarter_Amount__c + cwamt; 
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = op.Id;
                    qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue10.Id;
                    qsrMetricOpp.Quarter__c= LQ2; 
                    allQsrMetricOpps.Add(qsrMetricOpp);                  
                }
                if(ocq == LQ3)
                {
                    qsrMetricValue10.X3rd_Last_Quarter_Count__c= qsrMetricValue10.X3rd_Last_Quarter_Count__c + 1;
                    qsrMetricValue10.X3rd_Last_Quarter_Amount__c = qsrMetricValue10.X3rd_Last_Quarter_Amount__c + cwamt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = op.Id;
                    qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue10.Id;
                    qsrMetricOpp.Quarter__c= LQ3;
                    allQsrMetricOpps.Add(qsrMetricOpp);
                }
                if(ocq == LQ4)
                {
                    qsrMetricValue10.X4th_Last_Quarter_Count__c= qsrMetricValue10.X4th_Last_Quarter_Count__c + 1;
                    qsrMetricValue10.X4th_Last_Quarter_Amount__c = qsrMetricValue10.X4th_Last_Quarter_Amount__c + cwamt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = op.Id;
                    qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue10.Id;
                    qsrMetricOpp.Quarter__c= LQ4;
                    allQsrMetricOpps.Add(qsrMetricOpp);
                }
                if(ocyear == tyear)
                {
                    qsrMetricValue10.Year_To_Date_Count__c = qsrMetricValue10.Year_To_Date_Count__c + 1;
                    qsrMetricValue10.Year_To_Date_Amount__c = qsrMetricValue10.Year_To_Date_Amount__c + cwamt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = op.Id;
                    qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue10.Id;
                    qsrMetricOpp.Quarter__c= YTD;
                    allQsrMetricOpps.Add(qsrMetricOpp);
                }
            }           
            
            if(op.StageName == Closed_Lost)
            {         
                QSR_Metric_Opportunity__c qsrMetricOpp = new QSR_Metric_Opportunity__c();
                
                if(ocq == CQ)
                {
                    qsrMetricValue11.Current_Quarter_Count__c= qsrMetricValue11.Current_Quarter_Count__c + 1;
                    qsrMetricValue11.Current_Quarter_Amount__c = qsrMetricValue11.Current_Quarter_Amount__c + cwamt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = op.Id;
                    qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue11.Id;
                    qsrMetricOpp.Quarter__c= CQ;
                    allQsrMetricOpps.Add(qsrMetricOpp);
                }
                if(ocq == LQ1)
                {                    
                    qsrMetricValue11.Last_Quarter_Count__c= qsrMetricValue11.Last_Quarter_Count__c + 1;
                    qsrMetricValue11.Last_Quarter_Amount__c = qsrMetricValue11.Last_Quarter_Amount__c + cwamt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = op.Id;
                    qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue11.Id;
                    qsrMetricOpp.Quarter__c= LQ1;
                    allQsrMetricOpps.Add(qsrMetricOpp);
                }
                if(ocq == LQ2)
                {
                    qsrMetricValue11.X2nd_Last_Quarter_Count__c= qsrMetricValue11.X2nd_Last_Quarter_Count__c + 1;
                    qsrMetricValue11.X2nd_Last_Quarter_Amount__c = qsrMetricValue11.X2nd_Last_Quarter_Amount__c + cwamt; 
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = op.Id;
                    qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue11.Id;
                    qsrMetricOpp.Quarter__c= LQ2;  
                    allQsrMetricOpps.Add(qsrMetricOpp);                 
                }
                if(ocq == LQ3)
                {
                    qsrMetricValue11.X3rd_Last_Quarter_Count__c= qsrMetricValue11.X3rd_Last_Quarter_Count__c + 1;
                    qsrMetricValue11.X3rd_Last_Quarter_Amount__c = qsrMetricValue11.X3rd_Last_Quarter_Amount__c + cwamt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = op.Id;
                    qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue11.Id;
                    qsrMetricOpp.Quarter__c= LQ3;
                    allQsrMetricOpps.Add(qsrMetricOpp);
                }
                if(ocq == LQ4)
                {
                    qsrMetricValue11.X4th_Last_Quarter_Count__c= qsrMetricValue11.X4th_Last_Quarter_Count__c + 1;
                    qsrMetricValue11.X4th_Last_Quarter_Amount__c = qsrMetricValue11.X4th_Last_Quarter_Amount__c + cwamt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = op.Id;
                    qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue11.Id;
                    qsrMetricOpp.Quarter__c= LQ4;
                    allQsrMetricOpps.Add(qsrMetricOpp);
                }
                if(ocyear == tyear)
                {
                    qsrMetricValue11.Year_To_Date_Count__c = qsrMetricValue11.Year_To_Date_Count__c + 1;
                    qsrMetricValue11.Year_To_Date_Amount__c = qsrMetricValue11.Year_To_Date_Amount__c + cwamt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = op.Id;
                    qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue11.Id;
                    qsrMetricOpp.Quarter__c= YTD;
                    allQsrMetricOpps.Add(qsrMetricOpp);
                }
            }
            
            if(op.StageName == Closed_No_Decision)
            {         
                QSR_Metric_Opportunity__c qsrMetricOpp = new QSR_Metric_Opportunity__c();
                
                if(ocq == CQ)
                {
                    qsrMetricValue12.Current_Quarter_Count__c= qsrMetricValue12.Current_Quarter_Count__c + 1;
                    qsrMetricValue12.Current_Quarter_Amount__c = qsrMetricValue12.Current_Quarter_Amount__c + cwamt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = op.Id;
                    qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue12.Id;
                    qsrMetricOpp.Quarter__c= CQ;
                    allQsrMetricOpps.Add(qsrMetricOpp);
                }
                if(ocq == LQ1)
                {                    
                    qsrMetricValue12.Last_Quarter_Count__c= qsrMetricValue12.Last_Quarter_Count__c + 1;
                    qsrMetricValue12.Last_Quarter_Amount__c = qsrMetricValue12.Last_Quarter_Amount__c + cwamt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = op.Id;
                    qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue12.Id;
                    qsrMetricOpp.Quarter__c= LQ1;
                    allQsrMetricOpps.Add(qsrMetricOpp);
                }
                if(ocq == LQ2)
                {
                    qsrMetricValue12.X2nd_Last_Quarter_Count__c= qsrMetricValue12.X2nd_Last_Quarter_Count__c + 1;
                    qsrMetricValue12.X2nd_Last_Quarter_Amount__c = qsrMetricValue12.X2nd_Last_Quarter_Amount__c + cwamt; 
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = op.Id;
                    qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue12.Id;
                    qsrMetricOpp.Quarter__c= LQ2; 
                    allQsrMetricOpps.Add(qsrMetricOpp);                  
                }
                if(ocq == LQ3)
                {
                    qsrMetricValue12.X3rd_Last_Quarter_Count__c= qsrMetricValue12.X3rd_Last_Quarter_Count__c + 1;
                    qsrMetricValue12.X3rd_Last_Quarter_Amount__c = qsrMetricValue12.X3rd_Last_Quarter_Amount__c + cwamt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = op.Id;
                    qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue12.Id;
                    qsrMetricOpp.Quarter__c= LQ3;
                    allQsrMetricOpps.Add(qsrMetricOpp);
                }
                if(ocq == LQ4)
                {
                    qsrMetricValue12.X4th_Last_Quarter_Count__c= qsrMetricValue12.X4th_Last_Quarter_Count__c + 1;
                    qsrMetricValue12.X4th_Last_Quarter_Amount__c = qsrMetricValue12.X4th_Last_Quarter_Amount__c + cwamt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = op.Id;
                    qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue12.Id;
                    qsrMetricOpp.Quarter__c= LQ4;
                    allQsrMetricOpps.Add(qsrMetricOpp);
                }
                if(ocyear == tyear)
                {
                    qsrMetricValue12.Year_To_Date_Count__c = qsrMetricValue12.Year_To_Date_Count__c + 1;
                    qsrMetricValue12.Year_To_Date_Amount__c = qsrMetricValue12.Year_To_Date_Amount__c + cwamt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = op.Id;
                    qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue12.Id;
                    qsrMetricOpp.Quarter__c= YTD;
                    allQsrMetricOpps.Add(qsrMetricOpp);
                }
            }
            
            if(op.StageName == Closed_Disqualified)
            {         
                QSR_Metric_Opportunity__c qsrMetricOpp = new QSR_Metric_Opportunity__c();
                
                if(ocq == CQ)
                {
                    qsrMetricValue13.Current_Quarter_Count__c= qsrMetricValue13.Current_Quarter_Count__c + 1;
                    qsrMetricValue13.Current_Quarter_Amount__c = qsrMetricValue13.Current_Quarter_Amount__c + cwamt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = op.Id;
                    qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue13.Id;
                    qsrMetricOpp.Quarter__c= CQ;
                    allQsrMetricOpps.Add(qsrMetricOpp);
                }
                if(ocq == LQ1)
                {                    
                    qsrMetricValue13.Last_Quarter_Count__c= qsrMetricValue13.Last_Quarter_Count__c + 1;
                    qsrMetricValue13.Last_Quarter_Amount__c = qsrMetricValue13.Last_Quarter_Amount__c + cwamt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = op.Id;
                    qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue13.Id;
                    qsrMetricOpp.Quarter__c= LQ1;
                    allQsrMetricOpps.Add(qsrMetricOpp);
                }
                if(ocq == LQ2)
                {
                    qsrMetricValue13.X2nd_Last_Quarter_Count__c= qsrMetricValue13.X2nd_Last_Quarter_Count__c + 1;
                    qsrMetricValue13.X2nd_Last_Quarter_Amount__c = qsrMetricValue13.X2nd_Last_Quarter_Amount__c + cwamt; 
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = op.Id;
                    qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue13.Id;
                    qsrMetricOpp.Quarter__c= LQ2; 
                    allQsrMetricOpps.Add(qsrMetricOpp);                  
                }
                if(ocq == LQ3)
                {
                    qsrMetricValue13.X3rd_Last_Quarter_Count__c= qsrMetricValue13.X3rd_Last_Quarter_Count__c + 1;
                    qsrMetricValue13.X3rd_Last_Quarter_Amount__c = qsrMetricValue13.X3rd_Last_Quarter_Amount__c + cwamt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = op.Id;
                    qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue13.Id;
                    qsrMetricOpp.Quarter__c= LQ3;
                    allQsrMetricOpps.Add(qsrMetricOpp);
                }
                if(ocq == LQ4)
                {
                    qsrMetricValue13.X4th_Last_Quarter_Count__c= qsrMetricValue13.X4th_Last_Quarter_Count__c + 1;
                    qsrMetricValue13.X4th_Last_Quarter_Amount__c = qsrMetricValue13.X4th_Last_Quarter_Amount__c + cwamt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = op.Id;
                    qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue13.Id;
                    qsrMetricOpp.Quarter__c= LQ4;
                    allQsrMetricOpps.Add(qsrMetricOpp);
                }
                if(ocyear == tyear)
                {
                    qsrMetricValue13.Year_To_Date_Count__c = qsrMetricValue13.Year_To_Date_Count__c + 1;
                    qsrMetricValue13.Year_To_Date_Amount__c = qsrMetricValue13.Year_To_Date_Amount__c + cwamt;
                    
                    qsrMetricOpp = new QSR_Metric_Opportunity__c();
                    qsrMetricOpp.Opportunity__c = op.Id;
                    qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue13.Id;
                    qsrMetricOpp.Quarter__c= YTD;
                    allQsrMetricOpps.Add(qsrMetricOpp);
                }
            }
            
        }
        
        allQsrMetricValues = new List<QSR_Metric_Value__c>();
        allQsrMetricValues.Add(qsrMetricValue1);
        allQsrMetricValues.Add(qsrMetricValue2);
        allQsrMetricValues.Add(qsrMetricValue3);
        allQsrMetricValues.Add(qsrMetricValue4);
        allQsrMetricValues.Add(qsrMetricValue5);
        allQsrMetricValues.Add(qsrMetricValue6);
        allQsrMetricValues.Add(qsrMetricValue7);
        allQsrMetricValues.Add(qsrMetricValue8);
        allQsrMetricValues.Add(qsrMetricValue9);
        allQsrMetricValues.Add(qsrMetricValue10);
        allQsrMetricValues.Add(qsrMetricValue11);
        allQsrMetricValues.Add(qsrMetricValue12);
        allQsrMetricValues.Add(qsrMetricValue13);
        
        try
        {                
            if(allQsrMetricValues.size() > 0){
                List<Database.UpsertResult> qsrMetricValuesResult = Database.upsert( new List<QSR_Metric_Value__c>(allQsrMetricValues), QSR_Metric_Value__c.External_ID__c);
                system.debug('Method --> GenerateQSRReportSales' + NN_BB + '() --> Updated Value/Row = ' + qsrMetricValuesResult.size());                                
            }
            
            string forDeleteExistingOpp = 'SALES_' + NN_BB + '%';
            List<QSR_Metric_Opportunity__c> qsrOppForDelete = [select id, name, QSR_Metric_Value__r.external_id__c from QSR_Metric_Opportunity__c where QSR_Metric_Value__r.external_id__c like :forDeleteExistingOpp];
            if(qsrOppForDelete.size() > 0){
                system.debug('Method --> GenerateQSRReportSales'+ NN_BB + '() --> Deleting = ' + qsrOppForDelete.size());
                QSRReportsDeletionBatch qsrBatch = new QSRReportsDeletionBatch(new List<QSR_Metric_Opportunity__c>(qsrOppForDelete));                
                Id batchId = Database.executeBatch(qsrBatch, 2000);
                system.debug('Method --> GenerateQSRReportSales'+ NN_BB + '() --> Del Started Batch Id = ' + string.valueOf(batchId));
            }
            
            if(allQsrMetricOpps.size() > 0){                
                system.debug('Method --> GenerateQSRReportSales'+ NN_BB + '() --> Adding New = ' + allQsrMetricOpps.size());  
                //List<Database.SaveResult> qsrMetricOppsResult = Database.insert( new List<QSR_Metric_Opportunity__c>(allQsrMetricOpps));
                QSRReportsUpdaterBatch qsrBatch = new QSRReportsUpdaterBatch(allQsrMetricOpps);                
                Id batchId = Database.executeBatch(qsrBatch, 2000);
                system.debug('Method --> GenerateQSRReportSales'+ NN_BB + '() --> Started Batch Id = ' + string.valueOf(batchId)); 
            }
            
        }
        catch(DmlException e)
        {
            system.debug('Method --> GenerateQSRReportSales' + NN_BB + '() --> DML Exception Occured post conversion DML');
            system.debug(e);
        }        
        
        
        system.debug('Method --> GenerateQSRReportSales' + NN_BB + '() --> End');
    }
    
    public void GenerateQSRReportSalesByProductFamily(List<OpportunityFieldHistory> allOppStageHistoryTest, boolean isNewBusiness)
    {
        system.debug('Method --> GenerateQSRReportSalesByProductFamily() --> Start');
        
        TQ = GetQuarterByMonth(tmonth);
        system.debug('Input Date Quarter: ' + TQ);
        
        string NN_BB = '';
        if(isNewBusiness)
        {
            NN_BB = 'NN';
        }
        else
        {
            NN_BB = 'BB';
        }
        
        List<OpportunityFieldHistory> allOppStageHistory = new List<OpportunityFieldHistory>();
        List<Opportunity> opps = new List<Opportunity>();
        
        if(Test.isRunningTest())
        {
            allOppStageHistory = allOppStageHistoryTest;            
        }
        else
        {
            if(isNewBusiness)
            {
                allOppStageHistory = [Select OpportunityId, Opportunity.Name, Opportunity.Type, Opportunity.CHB_Amount__c,Opportunity.Product_Family__c,Opportunity.Product_Family__r.Name, OldValue, NewValue, 
                                      IsDeleted, Id, Field, CreatedDate, CreatedById From OpportunityFieldHistory 
                                      where Field = 'StageName' AND Opportunity.Type = 'New Business' AND 
                                      IsDeleted = false AND (Createddate >= :ldt AND Createddate <= :tdt)];
            }
            else
            {
                allOppStageHistory = [Select OpportunityId, Opportunity.Name, Opportunity.Type, Opportunity.CHB_Amount__c,Opportunity.Product_Family__c,Opportunity.Product_Family__r.Name, OldValue, NewValue, 
                                      IsDeleted, Id, Field, CreatedDate, CreatedById From OpportunityFieldHistory 
                                      where Field = 'StageName' AND Opportunity.Type != 'New Business' AND 
                                      IsDeleted = false AND (Createddate >= :ldt AND Createddate <= :tdt)];
            }
        }
        
        system.debug('Method --> GenerateQSRReportSalesByProductFamily ' + NN_BB + '() --> Stage History Opps Records = ' + allOppStageHistory.size());
        
        if(isNewBusiness)
        {
            opps = [Select Id, Name, Type, CHB_Amount__c, CreatedDate, CreatedById, StageName, CloseDate, First_Source__c, 
                    Last_Source__c, Product_Family__c, Product_Family__r.Name, Product_Family__r.Business_Group__c, 
                    Product_Family__r.Business_Group__r.Name From Opportunity where Type = 'New Business' AND (CloseDate >= :ldt AND CloseDate <= :tdt)];
        }
        else
        {         
            opps = [Select Id, Name, Type, CHB_Amount__c, CreatedDate, CreatedById, StageName, CloseDate, First_Source__c, 
                    Last_Source__c, Product_Family__c, Product_Family__r.Name, Product_Family__r.Business_Group__c, 
                    Product_Family__r.Business_Group__r.Name From Opportunity where Type != 'New Business' AND (CloseDate >= :ldt AND CloseDate <= :tdt)];
        }
        
        system.debug('Method --> GenerateQSRReportSalesByProductFamily ' + NN_BB + '() --> Opps Records = ' + opps.size());
        
        QSR_Metric__c qsrMetric = new QSR_Metric__c();
        qsrMetric.External_ID__c = 'SALESPF_' + NN_BB;
        qsrMetric.Report_Date_Range__c = string.valueOf(tdt) + ' ==> ' + string.valueOf(ldt) + '| Generated On: ' + string.valueOf(Datetime.now()) ;
        if(isNewBusiness)
        {
            qsrMetric.Name = 'Sales By Product Family - New Name';
        }
        else
        {
            qsrMetric.Name = 'Sales By Product Family - Back to Base';           
        }
        
        try
        {                                        
            Database.UpsertResult qsrMetricResult = Database.upsert(qsrMetric, QSR_Metric__c.External_ID__c);  
            qsrMetric.Id = qsrMetricResult.getId();
        }
        catch(DmlException e)
        {
            system.debug('Method --> GenerateQSRReportSalesByProductFamily' + NN_BB + '() --> DML Exception Occured post conversion DML');
            system.debug(e);
        }
        
        List<Product_Family__c> prodFamilies =  [Select Id, Name, Business_Group__c, Business_Group__r.Name From Product_Family__c];
        
        List<QSR_Metric_Value__c> allQsrMetricValues = new List<QSR_Metric_Value__c>();
        List<QSR_Metric_Opportunity__c> allQsrMetricOpps = new List<QSR_Metric_Opportunity__c>();
        Map<String, QSR_Metric_Value__c> allQsrMetricValueMaps = new  Map<String, QSR_Metric_Value__c>();
        
        for(Product_Family__c pf : prodFamilies)
        {                                   
            QSR_Metric_Value__c qsrMetricValue1 = new QSR_Metric_Value__c();
            qsrMetricValue1.External_Id__c = 'SALESPF_' + NN_BB + '_C-SQL'+ '_' + pf.Name;
            qsrMetricValue1.Name = 'Confirmed Sales Qualified';
            qsrMetricValue1.Current_Quarter_Amount__c = 0;
            qsrMetricValue1.Current_Quarter_Count__c = 0;
            qsrMetricValue1.Last_Quarter_Amount__c = 0;
            qsrMetricValue1.Last_Quarter_Count__c = 0;
            qsrMetricValue1.X2nd_Last_Quarter_Amount__c = 0;
            qsrMetricValue1.X2nd_Last_Quarter_Count__c = 0;
            qsrMetricValue1.X3rd_Last_Quarter_Amount__c = 0;
            qsrMetricValue1.X3rd_Last_Quarter_Count__c = 0;
            qsrMetricValue1.X4th_Last_Quarter_Amount__c = 0;
            qsrMetricValue1.X4th_Last_Quarter_Count__c = 0;
            qsrMetricValue1.Year_To_Date_Amount__c = 0;
            qsrMetricValue1.Year_To_Date_Count__c = 0; 
            qsrMetricValue1.Sorting_Order__c = 1;
            qsrMetricValue1.Category__c = 'Product Families';
            qsrMetricValue1.QSR_Metric__c = qsrMetric.Id;   
            
            qsrMetricValue1.Product_Family__c = pf.Id;
            qsrMetricValue1.Product_Family_Name__c = pf.Name;
            qsrMetricValue1.Business_Group__c = pf.Business_Group__c;
            if(pf.Business_Group__c != null)
            {
                qsrMetricValue1.Business_Group_Name__c = pf.Business_Group__r.Name;
            }
            
            allQsrMetricValues.Add(qsrMetricValue1);
            
            QSR_Metric_Value__c qsrMetricValue2 = new QSR_Metric_Value__c();
            qsrMetricValue2.External_Id__c = 'SALESPF_' + NN_BB + '_SLI'+ '_' + pf.Name;
            qsrMetricValue2.Name = 'Sales Initiated';
            qsrMetricValue2.Current_Quarter_Amount__c = 0;
            qsrMetricValue2.Current_Quarter_Count__c = 0;
            qsrMetricValue2.Last_Quarter_Amount__c = 0;
            qsrMetricValue2.Last_Quarter_Count__c = 0;
            qsrMetricValue2.X2nd_Last_Quarter_Amount__c = 0;
            qsrMetricValue2.X2nd_Last_Quarter_Count__c = 0;
            qsrMetricValue2.X3rd_Last_Quarter_Amount__c = 0;
            qsrMetricValue2.X3rd_Last_Quarter_Count__c = 0;
            qsrMetricValue2.X4th_Last_Quarter_Amount__c = 0;
            qsrMetricValue2.X4th_Last_Quarter_Count__c = 0;
            qsrMetricValue2.Year_To_Date_Amount__c = 0;
            qsrMetricValue2.Year_To_Date_Count__c = 0;
            qsrMetricValue2.Sorting_Order__c = 2;
            qsrMetricValue2.Category__c = 'Product Families';
            qsrMetricValue2.QSR_Metric__c = qsrMetric.Id;   
            
            qsrMetricValue2.Product_Family__c = pf.Id;
            qsrMetricValue2.Product_Family_Name__c = pf.Name;
            qsrMetricValue2.Business_Group__c = pf.Business_Group__c;
            if(pf.Business_Group__c != null)
            {
                qsrMetricValue2.Business_Group_Name__c = pf.Business_Group__r.Name;
            }               
            allQsrMetricValues.Add(qsrMetricValue2);
            
            QSR_Metric_Value__c qsrMetricValue3 = new QSR_Metric_Value__c();
            qsrMetricValue3.External_Id__c = 'SALESPF_' + NN_BB + '_INPROC'+ '_' + pf.Name;
            qsrMetricValue3.Name = 'In Process';
            qsrMetricValue3.Current_Quarter_Amount__c = 0;
            qsrMetricValue3.Current_Quarter_Count__c = 0;
            qsrMetricValue3.Last_Quarter_Amount__c = 0;
            qsrMetricValue3.Last_Quarter_Count__c = 0;
            qsrMetricValue3.X2nd_Last_Quarter_Amount__c = 0;
            qsrMetricValue3.X2nd_Last_Quarter_Count__c = 0;
            qsrMetricValue3.X3rd_Last_Quarter_Amount__c = 0;
            qsrMetricValue3.X3rd_Last_Quarter_Count__c = 0;
            qsrMetricValue3.X4th_Last_Quarter_Amount__c = 0;
            qsrMetricValue3.X4th_Last_Quarter_Count__c = 0;
            qsrMetricValue3.Year_To_Date_Amount__c = 0;
            qsrMetricValue3.Year_To_Date_Count__c = 0;
            qsrMetricValue3.Sorting_Order__c = 3;
            qsrMetricValue3.Category__c = 'Product Families';
            qsrMetricValue3.QSR_Metric__c = qsrMetric.Id;   
            
            qsrMetricValue3.Product_Family__c = pf.Id;
            qsrMetricValue3.Product_Family_Name__c = pf.Name;
            qsrMetricValue3.Business_Group__c = pf.Business_Group__c;
            if(pf.Business_Group__c != null)
            {
                qsrMetricValue3.Business_Group_Name__c = pf.Business_Group__r.Name;
            }       
            allQsrMetricValues.Add(qsrMetricValue3);
            
            QSR_Metric_Value__c qsrMetricValue4 = new QSR_Metric_Value__c();
            qsrMetricValue4.External_Id__c = 'SALESPF_' + NN_BB + '_DEMO'+ '_' + pf.Name;
            qsrMetricValue4.Name = 'Demo';
            qsrMetricValue4.Current_Quarter_Amount__c = 0;
            qsrMetricValue4.Current_Quarter_Count__c = 0;
            qsrMetricValue4.Last_Quarter_Amount__c = 0;
            qsrMetricValue4.Last_Quarter_Count__c = 0;
            qsrMetricValue4.X2nd_Last_Quarter_Amount__c = 0;
            qsrMetricValue4.X2nd_Last_Quarter_Count__c = 0;
            qsrMetricValue4.X3rd_Last_Quarter_Amount__c = 0;
            qsrMetricValue4.X3rd_Last_Quarter_Count__c = 0;
            qsrMetricValue4.X4th_Last_Quarter_Amount__c = 0;
            qsrMetricValue4.X4th_Last_Quarter_Count__c = 0;
            qsrMetricValue4.Year_To_Date_Amount__c = 0;
            qsrMetricValue4.Year_To_Date_Count__c = 0;
            qsrMetricValue4.Sorting_Order__c = 4;
            qsrMetricValue4.Category__c = 'Product Families';
            qsrMetricValue4.QSR_Metric__c = qsrMetric.Id;   
            
            qsrMetricValue4.Product_Family__c = pf.Id;
            qsrMetricValue4.Product_Family_Name__c = pf.Name;
            qsrMetricValue4.Business_Group__c = pf.Business_Group__c;
            if(pf.Business_Group__c != null)
            {
                qsrMetricValue4.Business_Group_Name__c = pf.Business_Group__r.Name;
            }        
            allQsrMetricValues.Add(qsrMetricValue4);
            
            QSR_Metric_Value__c qsrMetricValue5 = new QSR_Metric_Value__c();
            qsrMetricValue5.External_Id__c = 'SALESPF_' + NN_BB + '_PROP_SUBMIT'+ '_' + pf.Name;
            qsrMetricValue5.Name = 'Proposal Submitted';
            qsrMetricValue5.Current_Quarter_Amount__c = 0;
            qsrMetricValue5.Current_Quarter_Count__c = 0;
            qsrMetricValue5.Last_Quarter_Amount__c = 0;
            qsrMetricValue5.Last_Quarter_Count__c = 0;
            qsrMetricValue5.X2nd_Last_Quarter_Amount__c = 0;
            qsrMetricValue5.X2nd_Last_Quarter_Count__c = 0;
            qsrMetricValue5.X3rd_Last_Quarter_Amount__c = 0;
            qsrMetricValue5.X3rd_Last_Quarter_Count__c = 0;
            qsrMetricValue5.X4th_Last_Quarter_Amount__c = 0;
            qsrMetricValue5.X4th_Last_Quarter_Count__c = 0;
            qsrMetricValue5.Year_To_Date_Amount__c = 0;
            qsrMetricValue5.Year_To_Date_Count__c = 0;
            qsrMetricValue5.Sorting_Order__c = 5;
            qsrMetricValue5.Category__c = 'Product Families';
            qsrMetricValue5.QSR_Metric__c = qsrMetric.Id;   
            
            qsrMetricValue5.Product_Family__c = pf.Id;
            qsrMetricValue5.Product_Family_Name__c = pf.Name;
            qsrMetricValue5.Business_Group__c = pf.Business_Group__c;
            if(pf.Business_Group__c != null)
            {
                qsrMetricValue5.Business_Group_Name__c = pf.Business_Group__r.Name;
            }     
            allQsrMetricValues.Add(qsrMetricValue5);
            
            QSR_Metric_Value__c qsrMetricValue6 = new QSR_Metric_Value__c();
            qsrMetricValue6.External_Id__c = 'SALESPF_' + NN_BB + '_SHORLIST'+ '_' + pf.Name;
            qsrMetricValue6.Name = 'Short Listed';
            qsrMetricValue6.Current_Quarter_Amount__c = 0;
            qsrMetricValue6.Current_Quarter_Count__c = 0;
            qsrMetricValue6.Last_Quarter_Amount__c = 0;
            qsrMetricValue6.Last_Quarter_Count__c = 0;
            qsrMetricValue6.X2nd_Last_Quarter_Amount__c = 0;
            qsrMetricValue6.X2nd_Last_Quarter_Count__c = 0;
            qsrMetricValue6.X3rd_Last_Quarter_Amount__c = 0;
            qsrMetricValue6.X3rd_Last_Quarter_Count__c = 0;
            qsrMetricValue6.X4th_Last_Quarter_Amount__c = 0;
            qsrMetricValue6.X4th_Last_Quarter_Count__c = 0;
            qsrMetricValue6.Year_To_Date_Amount__c = 0;
            qsrMetricValue6.Year_To_Date_Count__c = 0;
            qsrMetricValue6.Sorting_Order__c = 6;
            qsrMetricValue6.Category__c = 'Product Families';
            qsrMetricValue6.QSR_Metric__c = qsrMetric.Id;   
            
            qsrMetricValue6.Product_Family__c = pf.Id;
            qsrMetricValue6.Product_Family_Name__c = pf.Name;
            qsrMetricValue6.Business_Group__c = pf.Business_Group__c;
            if(pf.Business_Group__c != null)
            {
                qsrMetricValue6.Business_Group_Name__c = pf.Business_Group__r.Name;
            }        
            allQsrMetricValues.Add(qsrMetricValue6);
            
            QSR_Metric_Value__c qsrMetricValue7 = new QSR_Metric_Value__c();
            qsrMetricValue7.External_Id__c = 'SALESPF_' + NN_BB + '_CONTR_ISSUED'+ '_' + pf.Name;
            qsrMetricValue7.Name = 'Contracts Issued';
            qsrMetricValue7.Current_Quarter_Amount__c = 0;
            qsrMetricValue7.Current_Quarter_Count__c = 0;
            qsrMetricValue7.Last_Quarter_Amount__c = 0;
            qsrMetricValue7.Last_Quarter_Count__c = 0;
            qsrMetricValue7.X2nd_Last_Quarter_Amount__c = 0;
            qsrMetricValue7.X2nd_Last_Quarter_Count__c = 0;
            qsrMetricValue7.X3rd_Last_Quarter_Amount__c = 0;
            qsrMetricValue7.X3rd_Last_Quarter_Count__c = 0;
            qsrMetricValue7.X4th_Last_Quarter_Amount__c = 0;
            qsrMetricValue7.X4th_Last_Quarter_Count__c = 0;
            qsrMetricValue7.Year_To_Date_Amount__c = 0;
            qsrMetricValue7.Year_To_Date_Count__c = 0;
            qsrMetricValue7.Sorting_Order__c = 7;
            qsrMetricValue7.Category__c = 'Product Families';
            qsrMetricValue7.QSR_Metric__c = qsrMetric.Id;   
            
            qsrMetricValue7.Product_Family__c = pf.Id;
            qsrMetricValue7.Product_Family_Name__c = pf.Name;
            qsrMetricValue7.Business_Group__c = pf.Business_Group__c;
            if(pf.Business_Group__c != null)
            {
                qsrMetricValue7.Business_Group_Name__c = pf.Business_Group__r.Name;
            }        
            allQsrMetricValues.Add(qsrMetricValue7);
            
            QSR_Metric_Value__c qsrMetricValue8 = new QSR_Metric_Value__c();
            qsrMetricValue8.External_Id__c = 'SALESPF_' + NN_BB + '_TOTAL_OPEN'+ '_' + pf.Name;
            qsrMetricValue8.Name = 'Total Open';
            qsrMetricValue8.Current_Quarter_Amount__c = 0;
            qsrMetricValue8.Current_Quarter_Count__c = 0;
            qsrMetricValue8.Last_Quarter_Amount__c = 0;
            qsrMetricValue8.Last_Quarter_Count__c = 0;
            qsrMetricValue8.X2nd_Last_Quarter_Amount__c = 0;
            qsrMetricValue8.X2nd_Last_Quarter_Count__c = 0;
            qsrMetricValue8.X3rd_Last_Quarter_Amount__c = 0;
            qsrMetricValue8.X3rd_Last_Quarter_Count__c = 0;
            qsrMetricValue8.X4th_Last_Quarter_Amount__c = 0;
            qsrMetricValue8.X4th_Last_Quarter_Count__c = 0;
            qsrMetricValue8.Year_To_Date_Amount__c = 0;
            qsrMetricValue8.Year_To_Date_Count__c = 0;
            qsrMetricValue8.Sorting_Order__c = 8;
            qsrMetricValue8.Category__c = 'Product Families';
            qsrMetricValue8.QSR_Metric__c = qsrMetric.Id;   
            
            qsrMetricValue8.Product_Family__c = pf.Id;
            qsrMetricValue8.Product_Family_Name__c = pf.Name;
            qsrMetricValue8.Business_Group__c = pf.Business_Group__c;
            if(pf.Business_Group__c != null)
            {
                qsrMetricValue8.Business_Group_Name__c = pf.Business_Group__r.Name;
            }        
            allQsrMetricValues.Add(qsrMetricValue8);
            
            QSR_Metric_Value__c qsrMetricValue9 = new QSR_Metric_Value__c();
            qsrMetricValue9.External_Id__c = 'SALESPF_' + NN_BB + '_TOTAL_CLOSE'+ '_' + pf.Name;
            qsrMetricValue9.Name = 'Total Closed';
            qsrMetricValue9.Current_Quarter_Amount__c = 0;
            qsrMetricValue9.Current_Quarter_Count__c = 0;
            qsrMetricValue9.Last_Quarter_Amount__c = 0;
            qsrMetricValue9.Last_Quarter_Count__c = 0;
            qsrMetricValue9.X2nd_Last_Quarter_Amount__c = 0;
            qsrMetricValue9.X2nd_Last_Quarter_Count__c = 0;
            qsrMetricValue9.X3rd_Last_Quarter_Amount__c = 0;
            qsrMetricValue9.X3rd_Last_Quarter_Count__c = 0;
            qsrMetricValue9.X4th_Last_Quarter_Amount__c = 0;
            qsrMetricValue9.X4th_Last_Quarter_Count__c = 0;
            qsrMetricValue9.Year_To_Date_Amount__c = 0;
            qsrMetricValue9.Year_To_Date_Count__c = 0;
            qsrMetricValue9.Sorting_Order__c = 9;
            qsrMetricValue9.Category__c = 'Product Families';
            qsrMetricValue9.QSR_Metric__c = qsrMetric.Id;   
            
            qsrMetricValue9.Product_Family__c = pf.Id;
            qsrMetricValue9.Product_Family_Name__c = pf.Name;
            qsrMetricValue9.Business_Group__c = pf.Business_Group__c;
            if(pf.Business_Group__c != null)
            {
                qsrMetricValue9.Business_Group_Name__c = pf.Business_Group__r.Name;
            }        
            allQsrMetricValues.Add(qsrMetricValue9);
            
            QSR_Metric_Value__c qsrMetricValue10 = new QSR_Metric_Value__c();
            qsrMetricValue10.External_Id__c = 'SALESPF_' + NN_BB + '_CLOSE_WON'+ '_' + pf.Name;
            qsrMetricValue10.Name = 'Closed Won';
            qsrMetricValue10.Current_Quarter_Amount__c = 0;
            qsrMetricValue10.Current_Quarter_Count__c = 0;
            qsrMetricValue10.Last_Quarter_Amount__c = 0;
            qsrMetricValue10.Last_Quarter_Count__c = 0;
            qsrMetricValue10.X2nd_Last_Quarter_Amount__c = 0;
            qsrMetricValue10.X2nd_Last_Quarter_Count__c = 0;
            qsrMetricValue10.X3rd_Last_Quarter_Amount__c = 0;
            qsrMetricValue10.X3rd_Last_Quarter_Count__c = 0;
            qsrMetricValue10.X4th_Last_Quarter_Amount__c = 0;
            qsrMetricValue10.X4th_Last_Quarter_Count__c = 0;
            qsrMetricValue10.Year_To_Date_Amount__c = 0;
            qsrMetricValue10.Year_To_Date_Count__c = 0;
            qsrMetricValue10.Sorting_Order__c = 10;
            qsrMetricValue10.Category__c = 'Product Families';
            qsrMetricValue10.QSR_Metric__c = qsrMetric.Id;   
            
            qsrMetricValue10.Product_Family__c = pf.Id;
            qsrMetricValue10.Product_Family_Name__c = pf.Name;
            qsrMetricValue10.Business_Group__c = pf.Business_Group__c;
            if(pf.Business_Group__c != null)
            {
                qsrMetricValue10.Business_Group_Name__c = pf.Business_Group__r.Name;
            }
            allQsrMetricValues.Add(qsrMetricValue10);
            
            QSR_Metric_Value__c qsrMetricValue11 = new QSR_Metric_Value__c();
            qsrMetricValue11.External_Id__c = 'SALESPF_' + NN_BB + '_CLOSE_LOST'+ '_' + pf.Name;
            qsrMetricValue11.Name = 'Closed Lost';
            qsrMetricValue11.Current_Quarter_Amount__c = 0;
            qsrMetricValue11.Current_Quarter_Count__c = 0;
            qsrMetricValue11.Last_Quarter_Amount__c = 0;
            qsrMetricValue11.Last_Quarter_Count__c = 0;
            qsrMetricValue11.X2nd_Last_Quarter_Amount__c = 0;
            qsrMetricValue11.X2nd_Last_Quarter_Count__c = 0;
            qsrMetricValue11.X3rd_Last_Quarter_Amount__c = 0;
            qsrMetricValue11.X3rd_Last_Quarter_Count__c = 0;
            qsrMetricValue11.X4th_Last_Quarter_Amount__c = 0;
            qsrMetricValue11.X4th_Last_Quarter_Count__c = 0;
            qsrMetricValue11.Year_To_Date_Amount__c = 0;
            qsrMetricValue11.Year_To_Date_Count__c = 0;
            qsrMetricValue11.Sorting_Order__c = 11; 
            qsrMetricValue11.Category__c = 'Product Families';
            qsrMetricValue11.QSR_Metric__c = qsrMetric.Id;   
            
            qsrMetricValue11.Product_Family__c = pf.Id;
            qsrMetricValue11.Product_Family_Name__c = pf.Name;
            qsrMetricValue11.Business_Group__c = pf.Business_Group__c;
            if(pf.Business_Group__c != null)
            {
                qsrMetricValue11.Business_Group_Name__c = pf.Business_Group__r.Name;
            }       
            allQsrMetricValues.Add(qsrMetricValue11);
            
            QSR_Metric_Value__c qsrMetricValue12 = new QSR_Metric_Value__c();
            qsrMetricValue12.External_Id__c = 'SALESPF_' + NN_BB + '_CLOSE_NO_DEC'+ '_' + pf.Name;
            qsrMetricValue12.Name = 'Closed No Decision';
            qsrMetricValue12.Current_Quarter_Amount__c = 0;
            qsrMetricValue12.Current_Quarter_Count__c = 0;
            qsrMetricValue12.Last_Quarter_Amount__c = 0;
            qsrMetricValue12.Last_Quarter_Count__c = 0;
            qsrMetricValue12.X2nd_Last_Quarter_Amount__c = 0;
            qsrMetricValue12.X2nd_Last_Quarter_Count__c = 0;
            qsrMetricValue12.X3rd_Last_Quarter_Amount__c = 0;
            qsrMetricValue12.X3rd_Last_Quarter_Count__c = 0;
            qsrMetricValue12.X4th_Last_Quarter_Amount__c = 0;
            qsrMetricValue12.X4th_Last_Quarter_Count__c = 0;
            qsrMetricValue12.Year_To_Date_Amount__c = 0;
            qsrMetricValue12.Year_To_Date_Count__c = 0;
            qsrMetricValue12.Sorting_Order__c = 12; 
            qsrMetricValue12.Category__c = 'Product Families';
            qsrMetricValue12.QSR_Metric__c = qsrMetric.Id;   
            
            qsrMetricValue12.Product_Family__c = pf.Id;
            qsrMetricValue12.Product_Family_Name__c = pf.Name;
            qsrMetricValue12.Business_Group__c = pf.Business_Group__c;
            if(pf.Business_Group__c != null)
            {
                qsrMetricValue12.Business_Group_Name__c = pf.Business_Group__r.Name;
            }       
            allQsrMetricValues.Add(qsrMetricValue12);
            
            QSR_Metric_Value__c qsrMetricValue13 = new QSR_Metric_Value__c();
            qsrMetricValue13.External_Id__c = 'SALESPF_' + NN_BB + '_CLOSE_DISQUALIFIED'+ '_' + pf.Name;
            qsrMetricValue13.Name = 'Closed Disqualified';
            qsrMetricValue13.Current_Quarter_Amount__c = 0;
            qsrMetricValue13.Current_Quarter_Count__c = 0;
            qsrMetricValue13.Last_Quarter_Amount__c = 0;
            qsrMetricValue13.Last_Quarter_Count__c = 0;
            qsrMetricValue13.X2nd_Last_Quarter_Amount__c = 0;
            qsrMetricValue13.X2nd_Last_Quarter_Count__c = 0;
            qsrMetricValue13.X3rd_Last_Quarter_Amount__c = 0;
            qsrMetricValue13.X3rd_Last_Quarter_Count__c = 0;
            qsrMetricValue13.X4th_Last_Quarter_Amount__c = 0;
            qsrMetricValue13.X4th_Last_Quarter_Count__c = 0;
            qsrMetricValue13.Year_To_Date_Amount__c = 0;
            qsrMetricValue13.Year_To_Date_Count__c = 0;
            qsrMetricValue13.Sorting_Order__c = 13; 
            qsrMetricValue13.Category__c = 'Product Families';
            qsrMetricValue13.QSR_Metric__c = qsrMetric.Id;   
            
            qsrMetricValue13.Product_Family__c = pf.Id;
            qsrMetricValue13.Product_Family_Name__c = pf.Name;
            qsrMetricValue13.Business_Group__c = pf.Business_Group__c;
            if(pf.Business_Group__c != null)
            {
                qsrMetricValue13.Business_Group_Name__c = pf.Business_Group__r.Name;
            }      
            allQsrMetricValues.Add(qsrMetricValue13);
            
        }
        try
        {                            
            if(allQsrMetricValues.size() > 0){
                List<Database.UpsertResult> qsrMetricValuesResult = Database.upsert( new List<QSR_Metric_Value__c>(allQsrMetricValues), QSR_Metric_Value__c.External_ID__c);                
                system.debug('Method --> GenerateQSRReportSalesByProductFamily'+ NN_BB + '() --> Upserting QSR Value/Row = ' + qsrMetricValuesResult.size());
            }            
        }
        catch(DmlException e)
        {
            system.debug('Method --> GenerateQSRReportSalesByProductFamily' + NN_BB + '() --> DML Exception Occured post conversion DML');
            system.debug(e);
        }  
        
        for(QSR_Metric_Value__c qsrMetricValue : allQsrMetricValues)
        {
            allQsrMetricValueMaps.put(qsrMetricValue.External_Id__c, qsrMetricValue);
        }
        
        for(OpportunityFieldHistory ofh : allOppStageHistory)
        {
            Datetime odt = ofh.CreatedDate;
            Integer omonth = odt.Month(); //get month
            Integer oyear = odt.Year(); //get year
            
            string lq  = GetOppQuarter(omonth, oyear);
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
            
            if(ofh.NewValue == Confirmed_SQL)
            {
                string qsrMetricValueExtId = 'SALESPF_' + NN_BB + '_C-SQL_' + ofh.Opportunity.Product_Family__r.Name;
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
            
            if(ofh.NewValue == Sales_Initiated)
            {                    
                string qsrMetricValueExtId = 'SALESPF_' + NN_BB + '_SLI_' + ofh.Opportunity.Product_Family__r.Name;
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
            
            if(ofh.NewValue == In_Process)
            {
                string qsrMetricValueExtId = 'SALESPF_' + NN_BB + '_INPROC_' + ofh.Opportunity.Product_Family__r.Name;
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
            
            if(ofh.NewValue == Demo)
            {
                string qsrMetricValueExtId = 'SALESPF_' + NN_BB + '_DEMO_' + ofh.Opportunity.Product_Family__r.Name;
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
            
            if(ofh.NewValue == Proposal_Submitted)
            {
                string qsrMetricValueExtId = 'SALESPF_' + NN_BB + '_PROP_SUBMIT_' + ofh.Opportunity.Product_Family__r.Name;
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
            
            if(ofh.NewValue == Short_Listed)
            {
                string qsrMetricValueExtId = 'SALESPF_' + NN_BB + '_SHORLIST_' + ofh.Opportunity.Product_Family__r.Name;
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
            
            if(ofh.NewValue == Contract_Issued)
            {
                string qsrMetricValueExtId = 'SALESPF_' + NN_BB + '_CONTR_ISSUED_' + ofh.Opportunity.Product_Family__r.Name;
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
        
        
        system.debug('Method --> GenerateQSRReportSalesByProductFamily' + NN_BB + '() --> All Opp Counts from History = ' + allQsrMetricOpps.size());
        
        //All Opps
        for(Opportunity op : opps)
        {     
            //All Opps Closed            
            Datetime ocdt = op.CloseDate; 
            Integer ocmonth = ocdt.Month(); //get month
            Integer ocyear = ocdt.Year(); //get year
            Double cwamt = 0;
            if(op.CHB_Amount__c != null)
            {
                cwamt = op.CHB_Amount__c;
            }
            
            string ocq  = GetOppQuarter(ocmonth, ocyear);
            if(op.Product_Family__c == null)
            {
                continue;
            }
            QSR_Metric_Opportunity__c qsrMetricOpp = new QSR_Metric_Opportunity__c();
            
            if(op.StageName == Closed_Won)
            {         
                string qsrMetricValueExtId = 'SALESPF_' + NN_BB + '_CLOSE_WON_' + op.Product_Family__r.Name;
                QSR_Metric_Value__c qsrMetricValue =  allQsrMetricValueMaps.get(qsrMetricValueExtId); 
                
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
            
            if(op.StageName == Closed_Lost)
            {         
                string qsrMetricValueExtId = 'SALESPF_' + NN_BB + '_CLOSE_LOST_' + op.Product_Family__r.Name;
                QSR_Metric_Value__c qsrMetricValue =  allQsrMetricValueMaps.get(qsrMetricValueExtId);
                
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
            
            if(op.StageName == Closed_No_Decision)
            {         
                string qsrMetricValueExtId = 'SALESPF_' + NN_BB + '_CLOSE_NO_DEC_' + op.Product_Family__r.Name;
                QSR_Metric_Value__c qsrMetricValue =  allQsrMetricValueMaps.get(qsrMetricValueExtId);
                
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
            
            if(op.StageName == Closed_Disqualified)
            {         
                string qsrMetricValueExtId = 'SALESPF_' + NN_BB + '_CLOSE_DISQUALIFIED_' + op.Product_Family__r.Name;
                QSR_Metric_Value__c qsrMetricValue =  allQsrMetricValueMaps.get(qsrMetricValueExtId);
                
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
        
        try
        {                
            if(allQsrMetricValues.size() > 0){
                List<Database.UpsertResult> qsrMetricValuesResult = Database.upsert( new List<QSR_Metric_Value__c>(allQsrMetricValueMaps.values()), QSR_Metric_Value__c.External_ID__c);
                system.debug('Method --> GenerateQSRReportSalesByProductFamily' + NN_BB + '() --> Updated Value/Row = ' + qsrMetricValuesResult.size());                                
            }
            
            string forDeleteExistingOpp = 'SALESPF_' + NN_BB + '%';
            List<QSR_Metric_Opportunity__c> qsrOppForDelete = [select id, name, QSR_Metric_Value__r.external_id__c from QSR_Metric_Opportunity__c where QSR_Metric_Value__r.external_id__c like :forDeleteExistingOpp];
            if(qsrOppForDelete.size() > 0){
                system.debug('Method --> GenerateQSRReportSalesByProductFamily'+ NN_BB + '() --> Deleting = ' + qsrOppForDelete.size());
                QSRReportsDeletionBatch qsrBatch = new QSRReportsDeletionBatch(new List<QSR_Metric_Opportunity__c>(qsrOppForDelete));                
                Id batchId = Database.executeBatch(qsrBatch, 2000);
                system.debug('Method --> GenerateQSRReportSalesByProductFamily'+ NN_BB + '() --> Del Started Batch Id = ' + string.valueOf(batchId));
            }
            
            if(allQsrMetricOpps.size() > 0)
            {                   
                
                system.debug('Method --> GenerateQSRReportSalesByProductFamily'+ NN_BB + '() --> Adding New = ' + allQsrMetricOpps.size());  
                //List<Database.SaveResult> qsrMetricOppsResult = Database.insert( new List<QSR_Metric_Opportunity__c>(allQsrMetricOpps));
                QSRReportsUpdaterBatch qsrBatch = new QSRReportsUpdaterBatch(allQsrMetricOpps);                
                Id batchId = Database.executeBatch(qsrBatch, 2000);
                system.debug('Method --> GenerateQSRReportSalesByProductFamily'+ NN_BB + '() --> Started Batch Id = ' + string.valueOf(batchId)); 
            }                
        }
        catch(DmlException e)
        {
            system.debug('Method --> GenerateQSRReportSalesByProductFamily' + NN_BB + '() --> DML Exception Occured post conversion DML');
            system.debug(e);
        }        
        
        
        
        system.debug('Method --> GenerateQSRReportSalesByProductFamily' + NN_BB + '() --> End');
    }
    
    /*---------Sales Report Region End----------------*/
    
    /*---------Booking by Sales Person Report Region Start--------------*/
    
    public void GenerateQSRReportBookingsBySalesPerson(boolean isNewBusiness)
    {
        system.debug('Method --> GenerateQSRReportBookingsBySalesPerson() --> Start');
        
        string NN_BB = '';        
        List<Opportunity> opps = new List<Opportunity>();
        
        if(isNewBusiness)
        {
            NN_BB = 'NN';
            opps = [Select Id, Name, Type, Owner.Name,CHB_Maintenance_Amount__c, CHB_License_Amount__c ,CHB_Amount__c, CreatedDate, 
                    CreatedById, StageName, CloseDate, First_Source__c, Last_Source__c, Product_Family__c, Product_Family__r.Name, 
                    Product_Family__r.Business_Group__c, Product_Family__r.Business_Group__r.Name From Opportunity where Type = 'New Business' 
                    AND StageName = 'Closed Won' AND (CloseDate >= :ldt AND CloseDate <= :tdt)];
        }
        else
        {
            NN_BB = 'BB';
            opps = [Select Id, Name, Type, Owner.Name,CHB_Maintenance_Amount__c, CHB_License_Amount__c ,CHB_Amount__c, CreatedDate, 
                    CreatedById, StageName, CloseDate, First_Source__c, Last_Source__c, Product_Family__c, Product_Family__r.Name, 
                    Product_Family__r.Business_Group__c, Product_Family__r.Business_Group__r.Name From Opportunity where Type != 'New Business' 
                    AND StageName = 'Closed Won' AND (CloseDate >= :ldt AND CloseDate <= :tdt)];
        }
        
        TQ = GetQuarterByMonth(tmonth);
        system.debug('Inout Date Quarter: ' +TQ);
        system.debug('Method --> GenerateQSRReportBookingsBySalesPerson' + NN_BB + '() --> Opps to Iterate = ' + opps.size());
        
        QSR_Metric__c qsrMetric = new QSR_Metric__c();
        qsrMetric.External_ID__c = 'BOOKINGS_SALES_PERSON_' + NN_BB;
        qsrMetric.Report_Date_Range__c = string.valueOf(tdt) + ' ==> ' + string.valueOf(ldt) + '| Generated On: ' + string.valueOf(Datetime.now()) ;
        if(isNewBusiness)
        {
            qsrMetric.Name = 'Bookings by Sales Person - New Name';
        }
        else
        {
            qsrMetric.Name = 'Bookings by Sales Person - Back to Base';           
        }
        
        try
        {                                        
            Database.UpsertResult qsrMetricResult = Database.upsert(qsrMetric, QSR_Metric__c.External_ID__c);  
            qsrMetric.Id = qsrMetricResult.getId();
        }
        catch(DmlException e)
        {
            system.debug('Method --> GenerateQSRReportBookingsBySalesPerson' + NN_BB + '() --> DML Exception Occured post conversion DML');
            system.debug(e);
        }
        
        List<User> allUsers =  [Select Id, Name From User];
        
        
        
        List<QSR_Metric_Value__c> allQsrMetricValues = new List<QSR_Metric_Value__c>();
        List<QSR_Metric_Opportunity__c> allQsrMetricOpps = new List<QSR_Metric_Opportunity__c>();
        
        Map<String, QSR_Metric_Value__c> allQsrMetricValueMaps = new  Map<String, QSR_Metric_Value__c>();
        
        for(User curr_user : allUsers)
        {
            QSR_Metric_Value__c qsrMetricValue1 = new QSR_Metric_Value__c();
            qsrMetricValue1.External_Id__c = 'BOOKINGS_SALES_PERSON_' + NN_BB + '_LIC_' + curr_user.Name;
            qsrMetricValue1.Name = 'License Bookings';
            qsrMetricValue1.Current_Quarter_Amount__c = 0;
            qsrMetricValue1.Current_Quarter_Count__c = 0;
            qsrMetricValue1.Last_Quarter_Amount__c = 0;
            qsrMetricValue1.Last_Quarter_Count__c = 0;
            qsrMetricValue1.X2nd_Last_Quarter_Amount__c = 0;
            qsrMetricValue1.X2nd_Last_Quarter_Count__c = 0;
            qsrMetricValue1.X3rd_Last_Quarter_Amount__c = 0;
            qsrMetricValue1.X3rd_Last_Quarter_Count__c = 0;
            qsrMetricValue1.X4th_Last_Quarter_Amount__c = 0;
            qsrMetricValue1.X4th_Last_Quarter_Count__c = 0;
            qsrMetricValue1.Year_To_Date_Amount__c = 0;
            qsrMetricValue1.Year_To_Date_Count__c = 0; 
            qsrMetricValue1.Sorting_Order__c = 1;
            qsrMetricValue1.Category__c = 'All';
            qsrMetricValue1.QSR_Metric__c = qsrMetric.Id;        
            qsrMetricValue1.Product_Family_Name__c = 'All';
            qsrMetricValue1.Business_Group_Name__c = 'All';        
            qsrMetricValue1.Sales_Person__c = curr_user.Name;
            
            allQsrMetricValues.Add(qsrMetricValue1);
            
            
            QSR_Metric_Value__c qsrMetricValue2 = new QSR_Metric_Value__c();
            qsrMetricValue2.External_Id__c = 'BOOKINGS_SALES_PERSON_' + NN_BB + '_MNT_' + curr_user.Name;
            qsrMetricValue2.Name = 'Maintenance Bookings';
            qsrMetricValue2.Current_Quarter_Amount__c = 0;
            qsrMetricValue2.Current_Quarter_Count__c = 0;
            qsrMetricValue2.Last_Quarter_Amount__c = 0;
            qsrMetricValue2.Last_Quarter_Count__c = 0;
            qsrMetricValue2.X2nd_Last_Quarter_Amount__c = 0;
            qsrMetricValue2.X2nd_Last_Quarter_Count__c = 0;
            qsrMetricValue2.X3rd_Last_Quarter_Amount__c = 0;
            qsrMetricValue2.X3rd_Last_Quarter_Count__c = 0;
            qsrMetricValue2.X4th_Last_Quarter_Amount__c = 0;
            qsrMetricValue2.X4th_Last_Quarter_Count__c = 0;
            qsrMetricValue2.Year_To_Date_Amount__c = 0;
            qsrMetricValue2.Year_To_Date_Count__c = 0; 
            qsrMetricValue2.Sorting_Order__c = 1;
            qsrMetricValue2.Category__c = 'All';
            qsrMetricValue2.QSR_Metric__c = qsrMetric.Id;        
            qsrMetricValue2.Product_Family_Name__c = 'All';
            qsrMetricValue2.Business_Group_Name__c = 'All';   
            qsrMetricValue2.Sales_Person__c = curr_user.Name;       
            
            allQsrMetricValues.Add(qsrMetricValue2);
            
            QSR_Metric_Value__c qsrMetricValue3 = new QSR_Metric_Value__c();
            qsrMetricValue3.External_Id__c = 'BOOKINGS_SALES_PERSON_' + NN_BB + '_TOTAL_' + curr_user.Name;
            qsrMetricValue3.Name = 'Total Bookings';
            qsrMetricValue3.Current_Quarter_Amount__c = 0;
            qsrMetricValue3.Current_Quarter_Count__c = 0;
            qsrMetricValue3.Last_Quarter_Amount__c = 0;
            qsrMetricValue3.Last_Quarter_Count__c = 0;
            qsrMetricValue3.X2nd_Last_Quarter_Amount__c = 0;
            qsrMetricValue3.X2nd_Last_Quarter_Count__c = 0;
            qsrMetricValue3.X3rd_Last_Quarter_Amount__c = 0;
            qsrMetricValue3.X3rd_Last_Quarter_Count__c = 0;
            qsrMetricValue3.X4th_Last_Quarter_Amount__c = 0;
            qsrMetricValue3.X4th_Last_Quarter_Count__c = 0;
            qsrMetricValue3.Year_To_Date_Amount__c = 0;
            qsrMetricValue3.Year_To_Date_Count__c = 0; 
            qsrMetricValue3.Sorting_Order__c = 1;
            qsrMetricValue3.Category__c = 'All';
            qsrMetricValue3.QSR_Metric__c = qsrMetric.Id;        
            qsrMetricValue3.Product_Family_Name__c = 'All';
            qsrMetricValue3.Business_Group_Name__c = 'All';     
            qsrMetricValue3.Sales_Person__c = curr_user.Name;
            
            allQsrMetricValues.Add(qsrMetricValue3);
            
            
        }
        
        try
        {                            
            if(allQsrMetricValues.size() > 0){
                List<Database.UpsertResult> qsrMetricValuesResult = Database.upsert( new List<QSR_Metric_Value__c>(allQsrMetricValues), QSR_Metric_Value__c.External_ID__c);                
                system.debug('Method --> GenerateQSRReportBookingsBySalesPerson'+ NN_BB + '() --> Upserting QSR Value/Row = ' + qsrMetricValuesResult.size());    
            }            
        }
        catch(DmlException e)
        {
            system.debug('Method --> GenerateQSRReportBookingsBySalesPerson' + NN_BB + '() --> DML Exception Occured post conversion DML');
            system.debug(e);
            return;
        }  
        
        for(QSR_Metric_Value__c allQsrMetricValue : allQsrMetricValues)
        {
            allQsrMetricValueMaps.put(allQsrMetricValue.External_Id__c, allQsrMetricValue);
        }
        
        
        for(Opportunity op : opps)
        {
            //All Opps Created - Quarterwise
            Datetime odt = op.CloseDate; 
            Integer omonth = odt.Month(); //get month
            Integer oyear = odt.Year(); //get year
            Double amt = 0;
            if(op.CHB_License_Amount__c != null)
            {
                amt = op.CHB_License_Amount__c;
            }
            
            string lq  = GetOppQuarter(omonth, oyear);
            if(op.Product_Family__c == null)
            {
                continue;
            }
            string qsrMetricValueExtId = 'BOOKINGS_SALES_PERSON_' + NN_BB + '_LIC_' + op.Owner.Name;
            QSR_Metric_Value__c qsrMetricValue =  allQsrMetricValueMaps.get(qsrMetricValueExtId);
            
            QSR_Metric_Opportunity__c qsrMetricOpp = new QSR_Metric_Opportunity__c();
            
            if(lq == CQ)
            {
                qsrMetricValue.Current_Quarter_Count__c= qsrMetricValue.Current_Quarter_Count__c + 1;
                qsrMetricValue.Current_Quarter_Amount__c = qsrMetricValue.Current_Quarter_Amount__c + amt;
                
                qsrMetricOpp = new QSR_Metric_Opportunity__c();
                qsrMetricOpp.Opportunity__c = op.Id;
                qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue.Id;
                qsrMetricOpp.Quarter__c= CQ;                
                allQsrMetricOpps.add(qsrMetricOpp);
            }
            if(lq == LQ1)
            {                    
                qsrMetricValue.Last_Quarter_Count__c= qsrMetricValue.Last_Quarter_Count__c + 1;
                qsrMetricValue.Last_Quarter_Amount__c = qsrMetricValue.Last_Quarter_Amount__c + amt;
                
                qsrMetricOpp = new QSR_Metric_Opportunity__c();
                qsrMetricOpp.Opportunity__c = op.Id;
                qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue.Id;
                qsrMetricOpp.Quarter__c= LQ1;
                allQsrMetricOpps.add(qsrMetricOpp);
            }
            if(lq == LQ2)
            {
                qsrMetricValue.X2nd_Last_Quarter_Count__c= qsrMetricValue.X2nd_Last_Quarter_Count__c + 1;
                qsrMetricValue.X2nd_Last_Quarter_Amount__c = qsrMetricValue.X2nd_Last_Quarter_Amount__c + amt;
                
                qsrMetricOpp = new QSR_Metric_Opportunity__c();
                qsrMetricOpp.Opportunity__c = op.Id;
                qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue.Id; 
                qsrMetricOpp.Quarter__c= LQ2;  
                allQsrMetricOpps.add(qsrMetricOpp);                 
            }
            if(lq == LQ3)
            {
                qsrMetricValue.X3rd_Last_Quarter_Count__c= qsrMetricValue.X3rd_Last_Quarter_Count__c + 1;
                qsrMetricValue.X3rd_Last_Quarter_Amount__c = qsrMetricValue.X3rd_Last_Quarter_Amount__c + amt;
                
                qsrMetricOpp = new QSR_Metric_Opportunity__c();
                qsrMetricOpp.Opportunity__c = op.Id;
                qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue.Id;
                qsrMetricOpp.Quarter__c= LQ3;
                allQsrMetricOpps.add(qsrMetricOpp);
            }
            if(lq == LQ4)
            {
                qsrMetricValue.X4th_Last_Quarter_Count__c= qsrMetricValue.X4th_Last_Quarter_Count__c + 1;
                qsrMetricValue.X4th_Last_Quarter_Amount__c = qsrMetricValue.X4th_Last_Quarter_Amount__c + amt;
                
                qsrMetricOpp = new QSR_Metric_Opportunity__c();
                qsrMetricOpp.Opportunity__c = op.Id;
                qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue.Id;
                qsrMetricOpp.Quarter__c= LQ4;
                allQsrMetricOpps.add(qsrMetricOpp);
            }
            if(oyear == tyear)
            {
                qsrMetricValue.Year_To_Date_Count__c = qsrMetricValue.Year_To_Date_Count__c + 1;
                qsrMetricValue.Year_To_Date_Amount__c = qsrMetricValue.Year_To_Date_Amount__c + amt;
                
                qsrMetricOpp = new QSR_Metric_Opportunity__c();
                qsrMetricOpp.Opportunity__c = op.Id;
                qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue.Id;
                qsrMetricOpp.Quarter__c= YTD;
                allQsrMetricOpps.add(qsrMetricOpp);
            }
            
            
            amt = 0;
            if(op.CHB_Maintenance_Amount__c != null)
            {
                amt = op.CHB_Maintenance_Amount__c;
            }
            
            qsrMetricValueExtId = 'BOOKINGS_SALES_PERSON_' + NN_BB + '_MNT_' + op.Owner.Name;
            qsrMetricValue =  allQsrMetricValueMaps.get(qsrMetricValueExtId);
            
            qsrMetricOpp = new QSR_Metric_Opportunity__c();
            
            if(lq == CQ)
            {
                qsrMetricValue.Current_Quarter_Count__c= qsrMetricValue.Current_Quarter_Count__c + 1;
                qsrMetricValue.Current_Quarter_Amount__c = qsrMetricValue.Current_Quarter_Amount__c + amt;
                
                qsrMetricOpp = new QSR_Metric_Opportunity__c();
                qsrMetricOpp.Opportunity__c = op.Id;
                qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue.Id;
                qsrMetricOpp.Quarter__c= CQ;
                allQsrMetricOpps.add(qsrMetricOpp);
            }
            if(lq == LQ1)
            {                    
                qsrMetricValue.Last_Quarter_Count__c= qsrMetricValue.Last_Quarter_Count__c + 1;
                qsrMetricValue.Last_Quarter_Amount__c = qsrMetricValue.Last_Quarter_Amount__c + amt;
                
                qsrMetricOpp = new QSR_Metric_Opportunity__c();
                qsrMetricOpp.Opportunity__c = op.Id;
                qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue.Id;
                qsrMetricOpp.Quarter__c= LQ1;
                allQsrMetricOpps.add(qsrMetricOpp);
            }
            if(lq == LQ2)
            {
                qsrMetricValue.X2nd_Last_Quarter_Count__c= qsrMetricValue.X2nd_Last_Quarter_Count__c + 1;
                qsrMetricValue.X2nd_Last_Quarter_Amount__c = qsrMetricValue.X2nd_Last_Quarter_Amount__c + amt; 
                
                qsrMetricOpp = new QSR_Metric_Opportunity__c();
                qsrMetricOpp.Opportunity__c = op.Id;
                qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue.Id;
                qsrMetricOpp.Quarter__c= LQ2;  
                allQsrMetricOpps.add(qsrMetricOpp);                 
            }
            if(lq == LQ3)
            {
                qsrMetricValue.X3rd_Last_Quarter_Count__c= qsrMetricValue.X3rd_Last_Quarter_Count__c + 1;
                qsrMetricValue.X3rd_Last_Quarter_Amount__c = qsrMetricValue.X3rd_Last_Quarter_Amount__c + amt;
                
                qsrMetricOpp = new QSR_Metric_Opportunity__c();
                qsrMetricOpp.Opportunity__c = op.Id;
                qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue.Id;
                qsrMetricOpp.Quarter__c= LQ3;
                allQsrMetricOpps.add(qsrMetricOpp);
            }
            if(lq == LQ4)
            {
                qsrMetricValue.X4th_Last_Quarter_Count__c= qsrMetricValue.X4th_Last_Quarter_Count__c + 1;
                qsrMetricValue.X4th_Last_Quarter_Amount__c = qsrMetricValue.X4th_Last_Quarter_Amount__c + amt;
                
                qsrMetricOpp = new QSR_Metric_Opportunity__c();
                qsrMetricOpp.Opportunity__c = op.Id;
                qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue.Id;
                qsrMetricOpp.Quarter__c= LQ4;
                allQsrMetricOpps.add(qsrMetricOpp);
            }
            if(oyear == tyear)
            {
                qsrMetricValue.Year_To_Date_Count__c = qsrMetricValue.Year_To_Date_Count__c + 1;
                qsrMetricValue.Year_To_Date_Amount__c = qsrMetricValue.Year_To_Date_Amount__c + amt;
                
                qsrMetricOpp = new QSR_Metric_Opportunity__c();
                qsrMetricOpp.Opportunity__c = op.Id;
                qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue.Id;
                qsrMetricOpp.Quarter__c= YTD;
                allQsrMetricOpps.add(qsrMetricOpp);
            }
            
            amt = 0;
            if(op.CHB_License_Amount__c != null)
            {
                amt = op.CHB_License_Amount__c;
            }
            if(op.CHB_Maintenance_Amount__c != null)
            {
                amt = amt + op.CHB_Maintenance_Amount__c;
            }
            
            qsrMetricValueExtId = 'BOOKINGS_SALES_PERSON_' + NN_BB + '_TOTAL_' + op.Owner.Name;
            qsrMetricValue =  allQsrMetricValueMaps.get(qsrMetricValueExtId);
            
            qsrMetricOpp = new QSR_Metric_Opportunity__c();
            
            if(lq == CQ)
            {
                qsrMetricValue.Current_Quarter_Count__c= qsrMetricValue.Current_Quarter_Count__c + 1;
                qsrMetricValue.Current_Quarter_Amount__c = qsrMetricValue.Current_Quarter_Amount__c + amt;
                
                qsrMetricOpp = new QSR_Metric_Opportunity__c();
                qsrMetricOpp.Opportunity__c = op.Id;
                qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue.Id;
                qsrMetricOpp.Quarter__c= CQ;
                allQsrMetricOpps.add(qsrMetricOpp);
            }
            if(lq == LQ1)
            {                    
                qsrMetricValue.Last_Quarter_Count__c= qsrMetricValue.Last_Quarter_Count__c + 1;
                qsrMetricValue.Last_Quarter_Amount__c = qsrMetricValue.Last_Quarter_Amount__c + amt;
                
                qsrMetricOpp = new QSR_Metric_Opportunity__c();
                qsrMetricOpp.Opportunity__c = op.Id;
                qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue.Id;
                qsrMetricOpp.Quarter__c= LQ1;
                allQsrMetricOpps.add(qsrMetricOpp);
            }
            if(lq == LQ2)
            {
                qsrMetricValue.X2nd_Last_Quarter_Count__c= qsrMetricValue.X2nd_Last_Quarter_Count__c + 1;
                qsrMetricValue.X2nd_Last_Quarter_Amount__c = qsrMetricValue.X2nd_Last_Quarter_Amount__c + amt; 
                
                qsrMetricOpp = new QSR_Metric_Opportunity__c();
                qsrMetricOpp.Opportunity__c = op.Id;
                qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue.Id;
                qsrMetricOpp.Quarter__c= LQ2;  
                allQsrMetricOpps.add(qsrMetricOpp);                 
            }
            if(lq == LQ3)
            {
                qsrMetricValue.X3rd_Last_Quarter_Count__c= qsrMetricValue.X3rd_Last_Quarter_Count__c + 1;
                qsrMetricValue.X3rd_Last_Quarter_Amount__c = qsrMetricValue.X3rd_Last_Quarter_Amount__c + amt;
                
                qsrMetricOpp = new QSR_Metric_Opportunity__c();
                qsrMetricOpp.Opportunity__c = op.Id;
                qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue.Id;
                qsrMetricOpp.Quarter__c= LQ3;
                allQsrMetricOpps.add(qsrMetricOpp);
            }
            if(lq == LQ4)
            {
                qsrMetricValue.X4th_Last_Quarter_Count__c= qsrMetricValue.X4th_Last_Quarter_Count__c + 1;
                qsrMetricValue.X4th_Last_Quarter_Amount__c = qsrMetricValue.X4th_Last_Quarter_Amount__c + amt;
                
                qsrMetricOpp = new QSR_Metric_Opportunity__c();
                qsrMetricOpp.Opportunity__c = op.Id;
                qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue.Id;
                qsrMetricOpp.Quarter__c= LQ4;
                allQsrMetricOpps.add(qsrMetricOpp);
            }
            if(oyear == tyear)
            {
                qsrMetricValue.Year_To_Date_Count__c = qsrMetricValue.Year_To_Date_Count__c + 1;
                qsrMetricValue.Year_To_Date_Amount__c = qsrMetricValue.Year_To_Date_Amount__c + amt;
                
                qsrMetricOpp = new QSR_Metric_Opportunity__c();
                qsrMetricOpp.Opportunity__c = op.Id;
                qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue.Id;
                qsrMetricOpp.Quarter__c= YTD;
                allQsrMetricOpps.add(qsrMetricOpp);
            }
            
        }
        
        try
        {                
            if(allQsrMetricValueMaps.size() > 0){
                List<Database.UpsertResult> qsrMetricValuesResult = Database.upsert( new List<QSR_Metric_Value__c>(allQsrMetricValueMaps.values()), QSR_Metric_Value__c.External_ID__c);
                system.debug('Method --> GenerateQSRReportBookingsBySalesPerson' + NN_BB + '() --> Updated Value/Row = ' + qsrMetricValuesResult.size());                                
            }
            
            string forDeleteExistingOpp = 'BOOKINGS_SALES_PERSON_' + NN_BB + '%';
            List<QSR_Metric_Opportunity__c> qsrOppForDelete = [select id, name, QSR_Metric_Value__r.external_id__c from QSR_Metric_Opportunity__c where QSR_Metric_Value__r.external_id__c like :forDeleteExistingOpp];
            if(qsrOppForDelete.size() > 0){
                system.debug('Method --> GenerateQSRReportBookingsBySalesPerson'+ NN_BB + '() --> Deleting = ' + qsrOppForDelete.size());
                QSRReportsDeletionBatch qsrBatch = new QSRReportsDeletionBatch(new List<QSR_Metric_Opportunity__c>(qsrOppForDelete));                
                Id batchId = Database.executeBatch(qsrBatch, 2000);
                system.debug('Method --> GenerateQSRReportBookingsBySalesPerson'+ NN_BB + '() --> Del Started Batch Id = ' + string.valueOf(batchId));
            }
            
            if(allQsrMetricOpps.size() > 0){                
                system.debug('Method --> GenerateQSRReportBookingsBySalesPerson'+ NN_BB + '() --> Adding New = ' + allQsrMetricOpps.size());  
                //List<Database.SaveResult> qsrMetricOppsResult = Database.insert( new List<QSR_Metric_Opportunity__c>(allQsrMetricOpps));
                QSRReportsUpdaterBatch qsrBatch = new QSRReportsUpdaterBatch(allQsrMetricOpps);                
                Id batchId = Database.executeBatch(qsrBatch, 2000);
                system.debug('Method --> GenerateQSRReportBookingsBySalesPerson'+ NN_BB + '() --> Started Batch Id = ' + string.valueOf(batchId)); 
            }
        }
        catch(DmlException e)
        {
            system.debug('Method --> GenerateQSRReportBookingsBySalesPerson' + NN_BB + '() --> DML Exception Occured post conversion DML');
            system.debug(e);
        }  
    }
    
    public void GenerateQSRReportPSGBookingsBySalesPerson(boolean isNewBusiness)
    {
        system.debug('Method --> GenerateQSRReportPSGBookingsBySalesPerson() --> Start');
        
        system.debug('Input Date: ' + tdt);
        string NN_BB = '';        
        List<Opportunity> opps = new List<Opportunity>();
        
        if(isNewBusiness)
        {
            NN_BB = 'NN';
            opps = [Select Id, Name, Type, Owner.Name, CHB_PSG_Amount__c, CHB_Maintenance_Amount__c, CHB_License_Amount__c ,CHB_Amount__c, CreatedDate, 
                    CreatedById, StageName, CloseDate, First_Source__c, Last_Source__c, Product_Family__c, Product_Family__r.Name, 
                    Product_Family__r.Business_Group__c, Product_Family__r.Business_Group__r.Name From Opportunity where Type = 'New Business' 
                    AND StageName = 'Closed Won' AND (CloseDate >= :ldt AND CloseDate <= :tdt)];
        }
        else
        {
            NN_BB = 'BB';
            opps = [Select Id, Name, Type, Owner.Name,CHB_PSG_Amount__c, CHB_Maintenance_Amount__c, CHB_License_Amount__c ,CHB_Amount__c, CreatedDate, 
                    CreatedById, StageName, CloseDate, First_Source__c, Last_Source__c, Product_Family__c, Product_Family__r.Name, 
                    Product_Family__r.Business_Group__c, Product_Family__r.Business_Group__r.Name From Opportunity where Type != 'New Business' 
                    AND StageName = 'Closed Won' AND (CloseDate >= :ldt AND CloseDate <= :tdt)];
        }
        
        TQ = GetQuarterByMonth(tmonth);
        system.debug('Inout Date Quarter: ' +TQ);
        system.debug('Method --> GenerateQSRReportPSGBookingsBySalesPerson' + NN_BB + '() --> Opps to Iterate = ' + opps.size());
        
        QSR_Metric__c qsrMetric = new QSR_Metric__c();
        qsrMetric.External_ID__c = 'PSG_SALES_PERSON_' + NN_BB;
        qsrMetric.Report_Date_Range__c = string.valueOf(tdt) + ' ==> ' + string.valueOf(ldt) + '| Generated On: ' + string.valueOf(Datetime.now()) ;
        if(isNewBusiness)
        {
            qsrMetric.Name = 'PSG Bookings By Sales Person  - New Name';
        }
        else
        {
            qsrMetric.Name = 'PSG Bookings By Sales Person - Back to Base';           
        }
        
        try
        {                                        
            Database.UpsertResult qsrMetricResult = Database.upsert(qsrMetric, QSR_Metric__c.External_ID__c);  
            qsrMetric.Id = qsrMetricResult.getId();
        }
        catch(DmlException e)
        {
            system.debug('Method --> GenerateQSRReportPSGBookingsBySalesPerson' + NN_BB + '() --> DML Exception Occured post conversion DML');
            system.debug(e);
        }
        
        List<User> allUsers =  [Select Id, Name From User];
        
        List<QSR_Metric_Value__c> allQsrMetricValues = new List<QSR_Metric_Value__c>();
        List<QSR_Metric_Opportunity__c> allQsrMetricOpps = new List<QSR_Metric_Opportunity__c>();
        
        Map<String, QSR_Metric_Value__c> allQsrMetricValueMaps = new  Map<String, QSR_Metric_Value__c>();
        
        for(User curr_user : allUsers)
        {
            QSR_Metric_Value__c qsrMetricValue1 = new QSR_Metric_Value__c();
            qsrMetricValue1.External_Id__c = 'PSG_SALES_PERSON_' + NN_BB + '_PSG_' + curr_user.Name;
            qsrMetricValue1.Name = 'PSG Bookings';
            qsrMetricValue1.Current_Quarter_Amount__c = 0;
            qsrMetricValue1.Current_Quarter_Count__c = 0;
            qsrMetricValue1.Last_Quarter_Amount__c = 0;
            qsrMetricValue1.Last_Quarter_Count__c = 0;
            qsrMetricValue1.X2nd_Last_Quarter_Amount__c = 0;
            qsrMetricValue1.X2nd_Last_Quarter_Count__c = 0;
            qsrMetricValue1.X3rd_Last_Quarter_Amount__c = 0;
            qsrMetricValue1.X3rd_Last_Quarter_Count__c = 0;
            qsrMetricValue1.X4th_Last_Quarter_Amount__c = 0;
            qsrMetricValue1.X4th_Last_Quarter_Count__c = 0;
            qsrMetricValue1.Year_To_Date_Amount__c = 0;
            qsrMetricValue1.Year_To_Date_Count__c = 0; 
            qsrMetricValue1.Sorting_Order__c = 1;
            qsrMetricValue1.Category__c = 'All';
            qsrMetricValue1.QSR_Metric__c = qsrMetric.Id;        
            qsrMetricValue1.Product_Family_Name__c = 'All';
            qsrMetricValue1.Business_Group_Name__c = 'All';        
            qsrMetricValue1.Sales_Person__c = curr_user.Name;
            
            allQsrMetricValues.Add(qsrMetricValue1);
            
        }
        
        try
        {                            
            if(allQsrMetricValues.size() > 0){
                List<Database.UpsertResult> qsrMetricValuesResult = Database.upsert( new List<QSR_Metric_Value__c>(allQsrMetricValues), QSR_Metric_Value__c.External_ID__c);                
                system.debug('Method --> GenerateQSRReportPSGBookingsBySalesPerson'+ NN_BB + '() --> Upserting QSR Value/Row = ' + qsrMetricValuesResult.size());  
            }            
        }
        catch(DmlException e)
        {
            system.debug('Method --> GenerateQSRReportPSGBookingsBySalesPerson' + NN_BB + '() --> DML Exception Occured post conversion DML');
            system.debug(e);
            return;
        }  
        
        for(QSR_Metric_Value__c allQsrMetricValue : allQsrMetricValues)
        {
            allQsrMetricValueMaps.put(allQsrMetricValue.External_Id__c, allQsrMetricValue);
        }
        
        
        for(Opportunity op : opps)
        {
            //All Opps Created - Quarterwise
            Datetime odt = op.CloseDate; 
            Integer omonth = odt.Month(); //get month
            Integer oyear = odt.Year(); //get year
            Double amt = 0;
            if(op.CHB_PSG_Amount__c != null)
            {
                amt = op.CHB_PSG_Amount__c;
            }
            
            string lq  = GetOppQuarter(omonth, oyear);
            if(op.Product_Family__c == null)
            {
                continue;
            }
            string qsrMetricValueExtId = 'PSG_SALES_PERSON_' + NN_BB + '_PSG_' + op.Owner.Name;
            QSR_Metric_Value__c qsrMetricValue =  allQsrMetricValueMaps.get(qsrMetricValueExtId);
            
            QSR_Metric_Opportunity__c qsrMetricOpp = new QSR_Metric_Opportunity__c();
            
            if(lq == CQ)
            {
                qsrMetricValue.Current_Quarter_Count__c= qsrMetricValue.Current_Quarter_Count__c + 1;
                qsrMetricValue.Current_Quarter_Amount__c = qsrMetricValue.Current_Quarter_Amount__c + amt;
                
                qsrMetricOpp = new QSR_Metric_Opportunity__c();
                qsrMetricOpp.Opportunity__c = op.Id;
                qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue.Id;
                qsrMetricOpp.Quarter__c= CQ;                
                allQsrMetricOpps.add(qsrMetricOpp);
            }
            if(lq == LQ1)
            {                    
                qsrMetricValue.Last_Quarter_Count__c= qsrMetricValue.Last_Quarter_Count__c + 1;
                qsrMetricValue.Last_Quarter_Amount__c = qsrMetricValue.Last_Quarter_Amount__c + amt;
                
                qsrMetricOpp = new QSR_Metric_Opportunity__c();
                qsrMetricOpp.Opportunity__c = op.Id;
                qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue.Id;
                qsrMetricOpp.Quarter__c= LQ1;
                allQsrMetricOpps.add(qsrMetricOpp);
            }
            if(lq == LQ2)
            {
                qsrMetricValue.X2nd_Last_Quarter_Count__c= qsrMetricValue.X2nd_Last_Quarter_Count__c + 1;
                qsrMetricValue.X2nd_Last_Quarter_Amount__c = qsrMetricValue.X2nd_Last_Quarter_Amount__c + amt;
                
                qsrMetricOpp = new QSR_Metric_Opportunity__c();
                qsrMetricOpp.Opportunity__c = op.Id;
                qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue.Id; 
                qsrMetricOpp.Quarter__c= LQ2;  
                allQsrMetricOpps.add(qsrMetricOpp);                 
            }
            if(lq == LQ3)
            {
                qsrMetricValue.X3rd_Last_Quarter_Count__c= qsrMetricValue.X3rd_Last_Quarter_Count__c + 1;
                qsrMetricValue.X3rd_Last_Quarter_Amount__c = qsrMetricValue.X3rd_Last_Quarter_Amount__c + amt;
                
                qsrMetricOpp = new QSR_Metric_Opportunity__c();
                qsrMetricOpp.Opportunity__c = op.Id;
                qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue.Id;
                qsrMetricOpp.Quarter__c= LQ3;
                allQsrMetricOpps.add(qsrMetricOpp);
            }
            if(lq == LQ4)
            {
                qsrMetricValue.X4th_Last_Quarter_Count__c= qsrMetricValue.X4th_Last_Quarter_Count__c + 1;
                qsrMetricValue.X4th_Last_Quarter_Amount__c = qsrMetricValue.X4th_Last_Quarter_Amount__c + amt;
                
                qsrMetricOpp = new QSR_Metric_Opportunity__c();
                qsrMetricOpp.Opportunity__c = op.Id;
                qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue.Id;
                qsrMetricOpp.Quarter__c= LQ4;
                allQsrMetricOpps.add(qsrMetricOpp);
            }
            if(oyear == tyear)
            {
                qsrMetricValue.Year_To_Date_Count__c = qsrMetricValue.Year_To_Date_Count__c + 1;
                qsrMetricValue.Year_To_Date_Amount__c = qsrMetricValue.Year_To_Date_Amount__c + amt;
                
                qsrMetricOpp = new QSR_Metric_Opportunity__c();
                qsrMetricOpp.Opportunity__c = op.Id;
                qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue.Id;
                qsrMetricOpp.Quarter__c= YTD;
                allQsrMetricOpps.add(qsrMetricOpp);
            }
            
        }
        
        try
        {                
            if(allQsrMetricValueMaps.size() > 0){
                List<Database.UpsertResult> qsrMetricValuesResult = Database.upsert( new List<QSR_Metric_Value__c>(allQsrMetricValueMaps.values()), QSR_Metric_Value__c.External_ID__c);
                system.debug('Method --> GenerateQSRReportPSGBookingsBySalesPerson' + NN_BB + '() --> Updated Value/Row = ' + qsrMetricValuesResult.size());                                
            }
            
            string forDeleteExistingOpp = 'PSG_SALES_PERSON_' + NN_BB + '%';
            List<QSR_Metric_Opportunity__c> qsrOppForDelete = [select id, name, QSR_Metric_Value__r.external_id__c from QSR_Metric_Opportunity__c where QSR_Metric_Value__r.external_id__c like :forDeleteExistingOpp];
            if(qsrOppForDelete.size() > 0){
                system.debug('Method --> GenerateQSRReportPSGBookingsBySalesPerson'+ NN_BB + '() --> Deleting = ' + qsrOppForDelete.size());
                QSRReportsDeletionBatch qsrBatch = new QSRReportsDeletionBatch(new List<QSR_Metric_Opportunity__c>(qsrOppForDelete));                
                Id batchId = Database.executeBatch(qsrBatch, 2000);
                system.debug('Method --> GenerateQSRReportPSGBookingsBySalesPerson'+ NN_BB + '() --> Del Started Batch Id = ' + string.valueOf(batchId));
            }
            
            if(allQsrMetricOpps.size() > 0){
                system.debug('Method --> GenerateQSRReportPSGBookingsBySalesPerson'+ NN_BB + '() --> Adding New = ' + allQsrMetricOpps.size());  
                //List<Database.SaveResult> qsrMetricOppsResult = Database.insert( new List<QSR_Metric_Opportunity__c>(allQsrMetricOpps));
                QSRReportsUpdaterBatch qsrBatch = new QSRReportsUpdaterBatch(allQsrMetricOpps);                
                Id batchId = Database.executeBatch(qsrBatch, 2000);
                system.debug('Method --> GenerateQSRReportPSGBookingsBySalesPerson'+ NN_BB + '() --> Started Batch Id = ' + string.valueOf(batchId)); 
            }
        }
        catch(DmlException e)
        {
            system.debug('Method --> GenerateQSRReportPSGBookingsBySalesPerson' + NN_BB + '() --> DML Exception Occured post conversion DML');
            system.debug(e);
        }  
    }
    
    /*---------Booking by Sales Person Report Region End----------------*/
    
    
    /*---------Bookings by Product Family Report Region Start--------------*/
    
    public void GenerateQSRReportBookingsByProductFamily(boolean isNewBusiness)
    {
        system.debug('Method --> GenerateQSRReportSalesPerson() --> Start');
        
        string NN_BB = '';        
        List<Opportunity> opps = new List<Opportunity>();
        
        if(isNewBusiness)
        {
            NN_BB = 'NN';
            opps = [Select Id, Name, Type, Owner.Name,CHB_Maintenance_Amount__c, CHB_License_Amount__c ,CHB_Amount__c, CreatedDate, 
                    CreatedById, StageName, CloseDate, First_Source__c, Last_Source__c, Product_Family__c, Product_Family__r.Name, 
                    Product_Family__r.Business_Group__c, Product_Family__r.Business_Group__r.Name From Opportunity where Type = 'New Business' 
                    AND StageName = 'Closed Won' AND (CloseDate >= :ldt AND CloseDate <= :tdt)];
        }
        else
        {
            NN_BB = 'BB';
            opps = [Select Id, Name, Type, Owner.Name,CHB_Maintenance_Amount__c, CHB_License_Amount__c ,CHB_Amount__c, CreatedDate, 
                    CreatedById, StageName, CloseDate, First_Source__c, Last_Source__c, Product_Family__c, Product_Family__r.Name, 
                    Product_Family__r.Business_Group__c, Product_Family__r.Business_Group__r.Name From Opportunity where Type != 'New Business' 
                    AND StageName = 'Closed Won' AND (CloseDate >= :ldt AND CloseDate <= :tdt)];
        }
        
        TQ = GetQuarterByMonth(tmonth);
        system.debug('Inout Date Quarter: ' +TQ);
        system.debug('Method --> GenerateQSRReportBookingsByProductFamily_' + NN_BB + '() --> Opps to Iterate = ' + opps.size());
        
        QSR_Metric__c qsrMetric = new QSR_Metric__c();
        qsrMetric.External_ID__c = 'BOOKINGS_BY_PRODUCT_FAMILY_' + NN_BB;
        qsrMetric.Report_Date_Range__c = string.valueOf(tdt) + ' ==> ' + string.valueOf(ldt) + '| Generated On: ' + string.valueOf(Datetime.now()) ;
        if(isNewBusiness)
        {
            qsrMetric.Name = 'Booking By Product Family - New Name';
        }
        else
        {
            qsrMetric.Name = 'Booking By Product Family - Back to Base';           
        }
        
        try
        {                                        
            Database.UpsertResult qsrMetricResult = Database.upsert(qsrMetric, QSR_Metric__c.External_ID__c);  
            qsrMetric.Id = qsrMetricResult.getId();
        }
        catch(DmlException e)
        {
            system.debug('Method --> GenerateQSRReportBookingsByProductFamily_' + NN_BB + '() --> DML Exception Occured post conversion DML');
            system.debug(e);
        }
        
        List<Product_Family__c> prodFamilies =  [Select Id, Name, Business_Group__c, Business_Group__r.Name From Product_Family__c];
        
        List<QSR_Metric_Value__c> allQsrMetricValues = new List<QSR_Metric_Value__c>();
        List<QSR_Metric_Opportunity__c> allQsrMetricOpps = new List<QSR_Metric_Opportunity__c>();
        
        Map<String, QSR_Metric_Value__c> allQsrMetricValueMaps = new  Map<String, QSR_Metric_Value__c>();
        
        for(Product_Family__c curr_prodFamily : prodFamilies)
        {
            QSR_Metric_Value__c qsrMetricValue1 = new QSR_Metric_Value__c();
            qsrMetricValue1.External_Id__c = 'BOOKINGS_BY_PRODUCT_FAMILY_' + NN_BB + '_LIC_' + curr_prodFamily.Name;
            qsrMetricValue1.Name = 'License Bookings';
            qsrMetricValue1.Current_Quarter_Amount__c = 0;
            qsrMetricValue1.Current_Quarter_Count__c = 0;
            qsrMetricValue1.Last_Quarter_Amount__c = 0;
            qsrMetricValue1.Last_Quarter_Count__c = 0;
            qsrMetricValue1.X2nd_Last_Quarter_Amount__c = 0;
            qsrMetricValue1.X2nd_Last_Quarter_Count__c = 0;
            qsrMetricValue1.X3rd_Last_Quarter_Amount__c = 0;
            qsrMetricValue1.X3rd_Last_Quarter_Count__c = 0;
            qsrMetricValue1.X4th_Last_Quarter_Amount__c = 0;
            qsrMetricValue1.X4th_Last_Quarter_Count__c = 0;
            qsrMetricValue1.Year_To_Date_Amount__c = 0;
            qsrMetricValue1.Year_To_Date_Count__c = 0; 
            qsrMetricValue1.Sorting_Order__c = 1;
            qsrMetricValue1.Category__c = 'All';
            qsrMetricValue1.QSR_Metric__c = qsrMetric.Id;        
            qsrMetricValue1.Product_Family_Name__c = curr_prodFamily.Name;
            qsrMetricValue1.Business_Group_Name__c = curr_prodFamily.Business_Group__r.Name;        
            
            allQsrMetricValues.Add(qsrMetricValue1);
            
            
            QSR_Metric_Value__c qsrMetricValue2 = new QSR_Metric_Value__c();
            qsrMetricValue2.External_Id__c = 'BOOKINGS_BY_PRODUCT_FAMILY_' + NN_BB + '_MNT_' + curr_prodFamily.Name;
            qsrMetricValue2.Name = 'Maintenance Bookings';
            qsrMetricValue2.Current_Quarter_Amount__c = 0;
            qsrMetricValue2.Current_Quarter_Count__c = 0;
            qsrMetricValue2.Last_Quarter_Amount__c = 0;
            qsrMetricValue2.Last_Quarter_Count__c = 0;
            qsrMetricValue2.X2nd_Last_Quarter_Amount__c = 0;
            qsrMetricValue2.X2nd_Last_Quarter_Count__c = 0;
            qsrMetricValue2.X3rd_Last_Quarter_Amount__c = 0;
            qsrMetricValue2.X3rd_Last_Quarter_Count__c = 0;
            qsrMetricValue2.X4th_Last_Quarter_Amount__c = 0;
            qsrMetricValue2.X4th_Last_Quarter_Count__c = 0;
            qsrMetricValue2.Year_To_Date_Amount__c = 0;
            qsrMetricValue2.Year_To_Date_Count__c = 0; 
            qsrMetricValue2.Sorting_Order__c = 2;
            qsrMetricValue2.Category__c = 'All';
            qsrMetricValue2.QSR_Metric__c = qsrMetric.Id;        
            qsrMetricValue2.Product_Family_Name__c = curr_prodFamily.Name;
            qsrMetricValue2.Business_Group_Name__c = curr_prodFamily.Business_Group__r.Name;       
            
            allQsrMetricValues.Add(qsrMetricValue2);
            
            QSR_Metric_Value__c qsrMetricValue3 = new QSR_Metric_Value__c();
            qsrMetricValue3.External_Id__c = 'BOOKINGS_BY_PRODUCT_FAMILY_' + NN_BB + '_TOTAL_' + curr_prodFamily.Name;
            qsrMetricValue3.Name = 'Total Bookings';
            qsrMetricValue3.Current_Quarter_Amount__c = 0;
            qsrMetricValue3.Current_Quarter_Count__c = 0;
            qsrMetricValue3.Last_Quarter_Amount__c = 0;
            qsrMetricValue3.Last_Quarter_Count__c = 0;
            qsrMetricValue3.X2nd_Last_Quarter_Amount__c = 0;
            qsrMetricValue3.X2nd_Last_Quarter_Count__c = 0;
            qsrMetricValue3.X3rd_Last_Quarter_Amount__c = 0;
            qsrMetricValue3.X3rd_Last_Quarter_Count__c = 0;
            qsrMetricValue3.X4th_Last_Quarter_Amount__c = 0;
            qsrMetricValue3.X4th_Last_Quarter_Count__c = 0;
            qsrMetricValue3.Year_To_Date_Amount__c = 0;
            qsrMetricValue3.Year_To_Date_Count__c = 0; 
            qsrMetricValue3.Sorting_Order__c = 3;
            qsrMetricValue3.Category__c = 'All';
            qsrMetricValue3.QSR_Metric__c = qsrMetric.Id;        
            qsrMetricValue3.Product_Family_Name__c = curr_prodFamily.Name;
            qsrMetricValue3.Business_Group_Name__c = curr_prodFamily.Business_Group__r.Name;  
            
            allQsrMetricValues.Add(qsrMetricValue3);
            
        }
        
        try
        {                            
            if(allQsrMetricValues.size() > 0){
                List<Database.UpsertResult> qsrMetricValuesResult = Database.upsert( new List<QSR_Metric_Value__c>(allQsrMetricValues), QSR_Metric_Value__c.External_ID__c);                
                system.debug('Method --> GenerateQSRReportBookingsByProductFamily'+ NN_BB + '() --> Upserting QSR Value/Row = ' + qsrMetricValuesResult.size());  
            }            
        }
        catch(DmlException e)
        {
            system.debug('Method --> GenerateQSRReportBookingsByProductFamily' + NN_BB + '() --> DML Exception Occured post conversion DML');
            system.debug(e);
            return;
        }  
        
        for(QSR_Metric_Value__c allQsrMetricValue : allQsrMetricValues)
        {
            allQsrMetricValueMaps.put(allQsrMetricValue.External_Id__c, allQsrMetricValue);
        }
        
        
        for(Opportunity op : opps)
        {
            //All Opps Created - Quarterwise
            Datetime odt = op.CloseDate; 
            Integer omonth = odt.Month(); //get month
            Integer oyear = odt.Year(); //get year
            Double amt = 0;
            if(op.CHB_License_Amount__c != null)
            {
                amt = op.CHB_License_Amount__c;
            }
            
            string lq  = GetOppQuarter(omonth, oyear);
            if(op.Product_Family__c == null)
            {
                continue;
            }
            string qsrMetricValueExtId = 'BOOKINGS_BY_PRODUCT_FAMILY_' + NN_BB + '_LIC_' + op.Product_Family__r.Name;
            QSR_Metric_Value__c qsrMetricValue =  allQsrMetricValueMaps.get(qsrMetricValueExtId);
            
            QSR_Metric_Opportunity__c qsrMetricOpp = new QSR_Metric_Opportunity__c();
            
            if(lq == CQ)
            {
                qsrMetricValue.Current_Quarter_Count__c= qsrMetricValue.Current_Quarter_Count__c + 1;
                qsrMetricValue.Current_Quarter_Amount__c = qsrMetricValue.Current_Quarter_Amount__c + amt;
                
                qsrMetricOpp = new QSR_Metric_Opportunity__c();
                qsrMetricOpp.Opportunity__c = op.Id;
                qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue.Id;
                qsrMetricOpp.Quarter__c= CQ;
                
                allQsrMetricOpps.add(qsrMetricOpp);
            }
            if(lq == LQ1)
            {                    
                qsrMetricValue.Last_Quarter_Count__c= qsrMetricValue.Last_Quarter_Count__c + 1;
                qsrMetricValue.Last_Quarter_Amount__c = qsrMetricValue.Last_Quarter_Amount__c + amt;
                
                qsrMetricOpp = new QSR_Metric_Opportunity__c();
                qsrMetricOpp.Opportunity__c = op.Id;
                qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue.Id;
                qsrMetricOpp.Quarter__c= LQ1;
                allQsrMetricOpps.add(qsrMetricOpp);
            }
            if(lq == LQ2)
            {
                qsrMetricValue.X2nd_Last_Quarter_Count__c= qsrMetricValue.X2nd_Last_Quarter_Count__c + 1;
                qsrMetricValue.X2nd_Last_Quarter_Amount__c = qsrMetricValue.X2nd_Last_Quarter_Amount__c + amt;
                
                qsrMetricOpp = new QSR_Metric_Opportunity__c();
                qsrMetricOpp.Opportunity__c = op.Id;
                qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue.Id; 
                qsrMetricOpp.Quarter__c= LQ2;  
                allQsrMetricOpps.add(qsrMetricOpp);                 
            }
            if(lq == LQ3)
            {
                qsrMetricValue.X3rd_Last_Quarter_Count__c= qsrMetricValue.X3rd_Last_Quarter_Count__c + 1;
                qsrMetricValue.X3rd_Last_Quarter_Amount__c = qsrMetricValue.X3rd_Last_Quarter_Amount__c + amt;
                
                qsrMetricOpp = new QSR_Metric_Opportunity__c();
                qsrMetricOpp.Opportunity__c = op.Id;
                qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue.Id;
                qsrMetricOpp.Quarter__c= LQ3;
                allQsrMetricOpps.add(qsrMetricOpp);
            }
            if(lq == LQ4)
            {
                qsrMetricValue.X4th_Last_Quarter_Count__c= qsrMetricValue.X4th_Last_Quarter_Count__c + 1;
                qsrMetricValue.X4th_Last_Quarter_Amount__c = qsrMetricValue.X4th_Last_Quarter_Amount__c + amt;
                
                qsrMetricOpp = new QSR_Metric_Opportunity__c();
                qsrMetricOpp.Opportunity__c = op.Id;
                qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue.Id;
                qsrMetricOpp.Quarter__c= LQ4;
                allQsrMetricOpps.add(qsrMetricOpp);
            }
            if(oyear == tyear)
            {
                qsrMetricValue.Year_To_Date_Count__c = qsrMetricValue.Year_To_Date_Count__c + 1;
                qsrMetricValue.Year_To_Date_Amount__c = qsrMetricValue.Year_To_Date_Amount__c + amt;
                
                qsrMetricOpp = new QSR_Metric_Opportunity__c();
                qsrMetricOpp.Opportunity__c = op.Id;
                qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue.Id;
                qsrMetricOpp.Quarter__c= YTD;
                allQsrMetricOpps.add(qsrMetricOpp);
            }
            
            
            amt = 0;
            if(op.CHB_Maintenance_Amount__c != null)
            {
                amt = op.CHB_Maintenance_Amount__c;
            }
            
            qsrMetricValueExtId = 'BOOKINGS_BY_PRODUCT_FAMILY_' + NN_BB + '_MNT_' + op.Product_Family__r.Name;
            qsrMetricValue =  allQsrMetricValueMaps.get(qsrMetricValueExtId);
            
            qsrMetricOpp = new QSR_Metric_Opportunity__c();
            
            if(lq == CQ)
            {
                qsrMetricValue.Current_Quarter_Count__c= qsrMetricValue.Current_Quarter_Count__c + 1;
                qsrMetricValue.Current_Quarter_Amount__c = qsrMetricValue.Current_Quarter_Amount__c + amt;
                
                qsrMetricOpp = new QSR_Metric_Opportunity__c();
                qsrMetricOpp.Opportunity__c = op.Id;
                qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue.Id;
                qsrMetricOpp.Quarter__c= CQ;
                allQsrMetricOpps.add(qsrMetricOpp);
            }
            if(lq == LQ1)
            {                    
                qsrMetricValue.Last_Quarter_Count__c= qsrMetricValue.Last_Quarter_Count__c + 1;
                qsrMetricValue.Last_Quarter_Amount__c = qsrMetricValue.Last_Quarter_Amount__c + amt;
                
                qsrMetricOpp = new QSR_Metric_Opportunity__c();
                qsrMetricOpp.Opportunity__c = op.Id;
                qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue.Id;
                qsrMetricOpp.Quarter__c= LQ1;
                allQsrMetricOpps.add(qsrMetricOpp);
            }
            if(lq == LQ2)
            {
                qsrMetricValue.X2nd_Last_Quarter_Count__c= qsrMetricValue.X2nd_Last_Quarter_Count__c + 1;
                qsrMetricValue.X2nd_Last_Quarter_Amount__c = qsrMetricValue.X2nd_Last_Quarter_Amount__c + amt; 
                
                qsrMetricOpp = new QSR_Metric_Opportunity__c();
                qsrMetricOpp.Opportunity__c = op.Id;
                qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue.Id;
                qsrMetricOpp.Quarter__c= LQ2;  
                allQsrMetricOpps.add(qsrMetricOpp);                 
            }
            if(lq == LQ3)
            {
                qsrMetricValue.X3rd_Last_Quarter_Count__c= qsrMetricValue.X3rd_Last_Quarter_Count__c + 1;
                qsrMetricValue.X3rd_Last_Quarter_Amount__c = qsrMetricValue.X3rd_Last_Quarter_Amount__c + amt;
                
                qsrMetricOpp = new QSR_Metric_Opportunity__c();
                qsrMetricOpp.Opportunity__c = op.Id;
                qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue.Id;
                qsrMetricOpp.Quarter__c= LQ3;
                allQsrMetricOpps.add(qsrMetricOpp);
            }
            if(lq == LQ4)
            {
                qsrMetricValue.X4th_Last_Quarter_Count__c= qsrMetricValue.X4th_Last_Quarter_Count__c + 1;
                qsrMetricValue.X4th_Last_Quarter_Amount__c = qsrMetricValue.X4th_Last_Quarter_Amount__c + amt;
                
                qsrMetricOpp = new QSR_Metric_Opportunity__c();
                qsrMetricOpp.Opportunity__c = op.Id;
                qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue.Id;
                qsrMetricOpp.Quarter__c= LQ4;
                allQsrMetricOpps.add(qsrMetricOpp);
            }
            if(oyear == tyear)
            {
                qsrMetricValue.Year_To_Date_Count__c = qsrMetricValue.Year_To_Date_Count__c + 1;
                qsrMetricValue.Year_To_Date_Amount__c = qsrMetricValue.Year_To_Date_Amount__c + amt;
                
                qsrMetricOpp = new QSR_Metric_Opportunity__c();
                qsrMetricOpp.Opportunity__c = op.Id;
                qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue.Id;
                qsrMetricOpp.Quarter__c= YTD;
                allQsrMetricOpps.add(qsrMetricOpp);
            }
            
            amt = 0;
            if(op.CHB_License_Amount__c != null)
            {
                amt = op.CHB_License_Amount__c;
            }
            if(op.CHB_Maintenance_Amount__c != null)
            {
                amt = amt + op.CHB_Maintenance_Amount__c;
            }
            
            qsrMetricValueExtId = 'BOOKINGS_BY_PRODUCT_FAMILY_' + NN_BB + '_TOTAL_' + op.Product_Family__r.Name;
            qsrMetricValue =  allQsrMetricValueMaps.get(qsrMetricValueExtId);
            
            qsrMetricOpp = new QSR_Metric_Opportunity__c();
            
            if(lq == CQ)
            {
                qsrMetricValue.Current_Quarter_Count__c= qsrMetricValue.Current_Quarter_Count__c + 1;
                qsrMetricValue.Current_Quarter_Amount__c = qsrMetricValue.Current_Quarter_Amount__c + amt;
                
                qsrMetricOpp = new QSR_Metric_Opportunity__c();
                qsrMetricOpp.Opportunity__c = op.Id;
                qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue.Id;
                qsrMetricOpp.Quarter__c= CQ;
                allQsrMetricOpps.add(qsrMetricOpp);
            }
            if(lq == LQ1)
            {                    
                qsrMetricValue.Last_Quarter_Count__c= qsrMetricValue.Last_Quarter_Count__c + 1;
                qsrMetricValue.Last_Quarter_Amount__c = qsrMetricValue.Last_Quarter_Amount__c + amt;
                
                qsrMetricOpp = new QSR_Metric_Opportunity__c();
                qsrMetricOpp.Opportunity__c = op.Id;
                qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue.Id;
                qsrMetricOpp.Quarter__c= LQ1;
                allQsrMetricOpps.add(qsrMetricOpp);
            }
            if(lq == LQ2)
            {
                qsrMetricValue.X2nd_Last_Quarter_Count__c= qsrMetricValue.X2nd_Last_Quarter_Count__c + 1;
                qsrMetricValue.X2nd_Last_Quarter_Amount__c = qsrMetricValue.X2nd_Last_Quarter_Amount__c + amt; 
                
                qsrMetricOpp = new QSR_Metric_Opportunity__c();
                qsrMetricOpp.Opportunity__c = op.Id;
                qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue.Id;
                qsrMetricOpp.Quarter__c= LQ2;  
                allQsrMetricOpps.add(qsrMetricOpp);                 
            }
            if(lq == LQ3)
            {
                qsrMetricValue.X3rd_Last_Quarter_Count__c= qsrMetricValue.X3rd_Last_Quarter_Count__c + 1;
                qsrMetricValue.X3rd_Last_Quarter_Amount__c = qsrMetricValue.X3rd_Last_Quarter_Amount__c + amt;
                
                qsrMetricOpp = new QSR_Metric_Opportunity__c();
                qsrMetricOpp.Opportunity__c = op.Id;
                qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue.Id;
                qsrMetricOpp.Quarter__c= LQ3;
                allQsrMetricOpps.add(qsrMetricOpp);
            }
            if(lq == LQ4)
            {
                qsrMetricValue.X4th_Last_Quarter_Count__c= qsrMetricValue.X4th_Last_Quarter_Count__c + 1;
                qsrMetricValue.X4th_Last_Quarter_Amount__c = qsrMetricValue.X4th_Last_Quarter_Amount__c + amt;
                
                qsrMetricOpp = new QSR_Metric_Opportunity__c();
                qsrMetricOpp.Opportunity__c = op.Id;
                qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue.Id;
                qsrMetricOpp.Quarter__c= LQ4;
                allQsrMetricOpps.add(qsrMetricOpp);
            }
            if(oyear == tyear)
            {
                qsrMetricValue.Year_To_Date_Count__c = qsrMetricValue.Year_To_Date_Count__c + 1;
                qsrMetricValue.Year_To_Date_Amount__c = qsrMetricValue.Year_To_Date_Amount__c + amt;
                
                qsrMetricOpp = new QSR_Metric_Opportunity__c();
                qsrMetricOpp.Opportunity__c = op.Id;
                qsrMetricOpp.QSR_Metric_Value__c = qsrMetricValue.Id;
                qsrMetricOpp.Quarter__c= YTD;
                allQsrMetricOpps.add(qsrMetricOpp);
            }
            
        }
        
        try
        {                
            if(allQsrMetricValueMaps.size() > 0){
                List<Database.UpsertResult> qsrMetricValuesResult = Database.upsert( new List<QSR_Metric_Value__c>(allQsrMetricValueMaps.values()), QSR_Metric_Value__c.External_ID__c);
                system.debug('Method --> GenerateQSRReportBookingsByProductFamily_' + NN_BB + '() --> Updated Value/Row = ' + qsrMetricValuesResult.size());                                
            }
            
            string forDeleteExistingOpp = 'BOOKINGS_BY_PRODUCT_FAMILY_' + NN_BB + '%';
            List<QSR_Metric_Opportunity__c> qsrOppForDelete = [select id, name, QSR_Metric_Value__r.external_id__c from QSR_Metric_Opportunity__c where QSR_Metric_Value__r.external_id__c like :forDeleteExistingOpp];
            if(qsrOppForDelete.size() > 0){
                system.debug('Method --> GenerateQSRReportBookingsByProductFamily_'+ NN_BB + '() --> Deleting = ' + qsrOppForDelete.size());
                QSRReportsDeletionBatch qsrBatch = new QSRReportsDeletionBatch(new List<QSR_Metric_Opportunity__c>(qsrOppForDelete));                
                Id batchId = Database.executeBatch(qsrBatch, 2000);
                system.debug('Method --> GenerateQSRReportBookingsByProductFamily_'+ NN_BB + '() --> Del Started Batch Id = ' + string.valueOf(batchId));
            }
            
            if(allQsrMetricOpps.size() > 0){                
                system.debug('Method --> GenerateQSRReportBookingsByProductFamily_'+ NN_BB + '() --> Adding New = ' + allQsrMetricOpps.size());  
                //List<Database.SaveResult> qsrMetricOppsResult = Database.insert( new List<QSR_Metric_Opportunity__c>(allQsrMetricOpps));
                QSRReportsUpdaterBatch qsrBatch = new QSRReportsUpdaterBatch(allQsrMetricOpps);                
                Id batchId = Database.executeBatch(qsrBatch, 2000);
                system.debug('Method --> GenerateQSRReportBookingsByProductFamily_'+ NN_BB + '() --> Started Batch Id = ' + string.valueOf(batchId)); 
            }
        }
        catch(DmlException e)
        {
            system.debug('Method --> GenerateQSRReportBookingsByProductFamily_' + NN_BB + '() --> DML Exception Occured post conversion DML');
            system.debug(e);
        }  
    }
    
    /*---------Bookings by Product Family Report Region End--------------*/
    
    private string GetOppQuarter(integer month, integer year)
    {
        string q;
        
        string qm = GetQuarterByMonth(month);
        
        if(TQ == Q1)
        {
            if(year == tyear)
            {
                q = CQ;
            }
            else
            {
                if(year == tyear-1)
                {
                    if(qm == Q4)
                    {
                        q = LQ1;
                    }
                    if(qm == Q3)
                    {
                        q = LQ2;
                    }                    
                    if(qm == Q2)
                    {
                        q = LQ3;
                    }                   
                    if(qm == Q1)
                    {
                        q = LQ4;
                    }
                    
                }
            }
        }
        if(TQ == Q2)
        {
            if(year == tyear)
            {
                if(qm == Q2)
                {
                    q = CQ;
                }
                if(qm == Q1)
                {
                    q = LQ1;
                }
            }
            else
            {
                if(year == tyear-1)
                {
                    if(qm == Q4)
                    {
                        q = LQ2;
                    }
                    if(qm == Q3)
                    {
                        q = LQ3;
                    }                    
                    if(qm == Q2)
                    {
                        q = LQ4;
                    }  
                }
            }
            
        }
        if(TQ == Q3)
        {
            if(year == tyear)
            {
                if(qm == Q3)
                {
                    q = CQ;
                }
                if(qm == Q2)
                {
                    q = LQ1;
                }
                if(qm == Q1)
                {
                    q = LQ2;
                }
            }
            else
            {
                if(year == tyear-1)
                {
                    if(qm == Q4)
                    {
                        q = LQ3;
                    }
                    if(qm == Q3)
                    {
                        q = LQ4;
                    }    
                }
            }
            
        }
        if(TQ == Q4)
        {
            if(year == tyear)
            {
                if(qm == Q4)
                {
                    q = CQ;
                }
                if(qm == Q3)
                {
                    q = LQ1;
                }
                if(qm == Q2)
                {
                    q = LQ2;
                }
                if(qm == Q1)
                {
                    q = LQ3;
                }
            }
            else
            {
                if(year == tyear-1)
                {
                    if(qm == Q4)
                    {
                        q = LQ4;
                    }    
                }
            }
            
        }
        
        return q;
    }
    
    private string GetQuarterByMonth(integer month)
    {
        string qm;
        
        if(month >= 1 && month <= 3)
        {
            qm = Q1;
            
        }
        if(month >= 4 && month <= 6)
        {
            qm = Q2;
            
        }
        if(month >= 7 && month <= 9)
        {
            qm = Q3;
            
        }
        if(month >= 10 && month <= 12)
        {
            qm = Q4;
            
        }
        return qm;
    }
    
    private Date GetQuarterStartDate()
    {
        Date qdt;
        
        if(tmonth >= 1 && tmonth <= 3)
        {
            qdt = Date.newInstance(tdt.year(), 1, 1);
            
        }
        if(tmonth >= 4 && tmonth <= 6)
        {
            qdt = Date.newInstance(tdt.year(), 4, 1);
            
        }
        if(tmonth >= 7 && tmonth <= 9)
        {
            qdt = Date.newInstance(tdt.year(), 7, 1);
            
        }
        if(tmonth >= 10 && tmonth <= 12)
        {
            qdt = Date.newInstance(tdt.year(), 10, 1);
            
        }
        return qdt;
    }

    private Date GetQuarterLastDate(Date selectedDate)
    {
        Date ldt = selectedDate;
        integer month = selectedDate.month();
        
        if(month >= 1 && month <= 3)
        {
            ldt = Date.newInstance(selectedDate.year(), 3, 31);            
        }
        if(month >= 4 && month <= 6)
        {
            ldt = Date.newInstance(selectedDate.year(), 6, 30);               
        }
        if(month >= 7 && month <= 9)
        {
            ldt = Date.newInstance(selectedDate.year(), 9, 30);  
        }
        if(month >= 10 && month <= 12)
        {
            ldt = Date.newInstance(selectedDate.year(), 12, 31);  
        }
        return ldt;
    }
    
    private boolean IsSourceMarketing(string source)
    {
        boolean isSourceMkt = false;
        if(string.isNotEmpty(source))
        {
            if(source == 'Direct mail')
            {
                isSourceMkt = true;
                return isSourceMkt;
            }
            if(source == 'Event/Tradeshow')
            {
                isSourceMkt = true;
                return isSourceMkt;
            }
            if(source == 'Industry List')
            {
                isSourceMkt = true;
                return isSourceMkt;
            }
            if(source == 'Industry Referral')
            {
                isSourceMkt = true;
                return isSourceMkt;
            }
            if(source == 'Marketing email')
            {
                isSourceMkt = true;
                return isSourceMkt;
            }
            if(source == 'Online banner')
            {
                isSourceMkt = true;
                return isSourceMkt;
            }
            if(source == 'Pay per click Ads')
            {
                isSourceMkt = true;
                return isSourceMkt;
            }
            if(source == 'Social Media')
            {
                isSourceMkt = true;
                return isSourceMkt;
            }
            if(source == 'Webinar')
            {
                isSourceMkt = true;
                return isSourceMkt;
            }
            if(source == 'Website')
            {
                isSourceMkt = true;
                return isSourceMkt;
            }
            if(source == 'Website Resources')
            {
                isSourceMkt = true;
                return isSourceMkt;
            }
        }
        return isSourceMkt;
    }
    
}