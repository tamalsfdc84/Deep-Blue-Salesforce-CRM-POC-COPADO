trigger WT_ContentVersionTrigger on ContentVersion (before insert) {
    
    if(trigger.isBefore){
        new WT_ContentVersionBeforeHandler().run();
    }
    
}