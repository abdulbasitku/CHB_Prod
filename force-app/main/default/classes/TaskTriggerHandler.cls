public with sharing class TaskTriggerHandler 
{
    private boolean m_isExecuting = false;
    private integer BatchSize = 0;
    public static boolean IsFromBachJob ;
    public static boolean isFromUploadAPI=false;
    
    public TaskTriggerHandler(boolean isExecuting, integer size)
    {
        m_isExecuting = isExecuting;
        BatchSize = size;
    }
            

    public void OnBeforeInsert(List<Task> newTask)
    {
        system.debug('Task Trigger On Before Insert');
    }
    public void OnAfterInsert(List<Task> newTask, Map<ID, Task> newTaskMap)
    {
        system.debug('Task Trigger On After Insert');
    }
    public void OnAfterUpdate( List<Task> newTask, List<Task> oldTask, Map<ID, Task> newTaskMap, Map<ID, Task> oldTaskMap)
    {
        system.debug('Task Trigger On After Update ');
    }
    public void OnBeforeUpdate( List<Task> newTask, List<Task> oldTask, Map<ID, Task> newTaskMap , Map<ID, Task> oldTaskMap)
    {
        system.debug('Task Trigger On Before Update ');
    }

    public void OnBeforeDelete(List<Task> newTask)
    {
        system.debug('Task Trigger On Before Delete');
        TaskActions.RestrictTaskDeletionForUser(newTask);
    }
    
    public void OnAfterDelete(List<Task> oldTask)
    {
        system.debug('Task Trigger On After Delete');        
    }
    
    /*@future 
    public static void OnAfterUpdateAsync(Set<ID> newTaskIDs)
    {

    }
    
    public boolean IsTriggerContext
    {
        get{ return m_isExecuting;}
    }
    
    public boolean IsVisualforcePageContext
    {
        get{ return !IsTriggerContext;}
    }
    
    public boolean IsWebServiceContext
    {
        get{ return !IsTriggerContext;}
    }
    
    public boolean IsExecuteAnonymousContext
    {
        get{ return !IsTriggerContext;}
    }*/
}