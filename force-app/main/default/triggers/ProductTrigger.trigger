trigger ProductTrigger on Product2 (after insert, after update, after delete, before insert, before update, before delete) {

    ProductTriggerHandler handler = new ProductTriggerHandler(Trigger.isExecuting, Trigger.size);
    
    if( Trigger.isInsert )
    {
        if(Trigger.isBefore)
        {
            handler.OnBeforeInsert(trigger.New);
        }
        else
        {
            handler.OnAfterInsert(trigger.New);
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
            if(AvoidRecursion.isFirstRun())
            {
                handler.OnAfterUpdate(trigger.New ,trigger.Old,Trigger.NewMap,Trigger.OldMap);
            }
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