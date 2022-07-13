public with sharing class QSRReportsLwcController {
    // Retrive list of contact list
    
    @AuraEnabled(cacheable=false)
    public static void GenerateReport(string reportName, Date generationDate) {
        
        
        system.debug('Method --> GenerateReportLwc --> Start');
        system.debug('Method --> GenerateReportLwc --> Report Name: ' + reportName);
        system.debug('Method --> GenerateReportLwc --> On Dated: ' + generationDate);
        
       QSRReports obj = new QSRReports(generationDate);
        
        if(reportName == 'Marketing')
        {
            obj.GenerateQSRReportMarketing(null, true);   
            
            obj.GenerateQSRReportMarketing(null, false);  
        }
        
        if(reportName == 'Marketing_PF')
        {
            QSRReports2.GenerateQSRReportMarketingByProductFamilyB(generationDate, true);   
            
            QSRReports2.GenerateQSRReportMarketingByProductFamilyB(generationDate, false); 
        }
        
        if(reportName == 'Sales')
        {
            obj.GenerateQSRReportSales(null, true);
            
            obj.GenerateQSRReportSales(null, false); 
        }
        
        if(reportName == 'Sales_PF')
        {
            obj.GenerateQSRReportSalesByProductFamily(null, true);
            
            obj.GenerateQSRReportSalesByProductFamily(null, false);
        }
        
        if(reportName == 'Bookings_SP')
        {
            obj.GenerateQSRReportBookingsBySalesPerson(true);        
            
            obj.GenerateQSRReportBookingsBySalesPerson(false);        
        }
        
        if(reportName == 'PSG_Bookings_SP')
        {
            obj.GenerateQSRReportPSGBookingsBySalesPerson(true);
            
            obj.GenerateQSRReportPSGBookingsBySalesPerson(false);
        }
        
        if(reportName == 'Bookings_PF')
        {
            obj.GenerateQSRReportBookingsByProductFamily(true);
            
            obj.GenerateQSRReportBookingsByProductFamily(false);
        }
        
        system.debug('Method --> GenerateReportLwc --> Report Name: ' + reportName);
        system.debug('Method --> GenerateReportLwc --> On Dated: ' + generationDate);
        
        system.debug('Method --> GenerateReportLwc --> end');
        
    }
}