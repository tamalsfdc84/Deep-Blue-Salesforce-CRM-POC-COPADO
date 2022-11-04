trigger WT_BlockUserAutoProvisionTrigger on WT_Block_User_Auto_Provision__e (after insert) 
{
    new WT_BlockUserAutoProvisionAfterHandler().run();
}