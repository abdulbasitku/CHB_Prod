public without sharing class TaskActions {
    
    public static void RestrictTaskDeletionForUser(List<Task> newTasks)
    {        
        system.debug('Method --> RestrictTaskDeltionForUser() --> Start');
        
        try
        {
            
            system.debug('Method --> RestrictTaskDeltionForUser() --> Task count: ' + newTasks.size());
            system.debug('Method --> RestrictTaskDeltionForUser() --> UserId: ' + UserInfo.getUserId());
            
            system.debug('Method --> RestrictTaskDeltionForUser() --> Task count: ' + newTasks.size());
            if(UserInfo.getUserId() == '0053m00000Af6ZDAAZ' || System.Test.isRunningTest()) //Prevent Laine to delete Tasks
            {
                for (Task t : newTasks) {
                    
                    system.debug('Method --> RestrictTaskDeltionForUser() --> Task: ' + t);                    
                    t.addError('Unable to delete Task - User do not have permission');
                }
            }
        }
        catch(Exception e)
        {
            system.debug('Method --> RestrictTaskDeltionForUser() --> Exception Occured');
            system.debug(e);
        }
        
        system.debug('Method --> RestrictTaskDeltionForUser() --> End');
    }
}