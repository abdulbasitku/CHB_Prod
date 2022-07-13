trigger ContactProductTrigger on Contact_Product__c (after insert, after update, after delete, before insert, before update, before delete) {

    ContactProductTriggerHandler handler = new ContactProductTriggerHandler(Trigger.isExecuting, Trigger.size);
    
    if( Trigger.isInsert )
    {
        if(Trigger.isBefore)
        {
            handler.OnBeforeInsert(trigger.New);
        }
        else
        {
            handler.OnAfterInsert(trigger.New, trigger.NewMap);
        }
    }
    else if ( Trigger.isUpdate )
    {
        if(Trigger.isBefore)
        {
            handler.OnBeforeUpdate(trigger.New ,trigger.Old,Trigger.NewMap,Trigger.OldMap);
        }
        else
        {
            handler.OnAfterUpdate(trigger.New ,trigger.Old,Trigger.NewMap,Trigger.OldMap);
        }
    }
    else if ( Trigger.isDelete )
    {
        if(Trigger.isBefore)
        {
            handler.OnBeforeDelete(trigger.New);
        }
        else
        {
            handler.OnAfterDelete(trigger.Old);
        }
    }
}