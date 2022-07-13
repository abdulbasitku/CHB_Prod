public class QSRReports2 {
        
    public static void GenerateQSRReportMarketingByProductFamilyB(Date generationDate, boolean isNewBusiness)
    {
        QSRBatchForMPF qsrBatchForMPF = new QSRBatchForMPF(generationDate, isNewBusiness);
        ID batchId = Database.executeBatch(qsrBatchForMPF, 2000);            
    }
    
}