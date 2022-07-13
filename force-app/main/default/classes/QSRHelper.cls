public class QSRHelper {

    
    static string Q1 = 'Q1';
    static string Q2 = 'Q2';
    static string Q3 = 'Q3';
    static string Q4 = 'Q4';
    
    static string CQ = 'CQ';
    
    static string LQ1 = 'LQ1';
    static string LQ2 = 'LQ2';
    static string LQ3 = 'LQ3';
    static string LQ4 = 'LQ4';
    
    static string YTD = 'YTD';
    
    public static string GetOppQuarter(integer month, integer year, string TQ, Integer tyear,Integer tmonth)
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
    
    public static string GetQuarterByMonth(integer month)
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
    
    public static Date GetQuarterStartDate(Integer tmonth, Date tdt)
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

    public static Date GetQuarterLastDate(Date selectedDate)
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
    
    public static boolean IsSourceMarketing(string source)
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