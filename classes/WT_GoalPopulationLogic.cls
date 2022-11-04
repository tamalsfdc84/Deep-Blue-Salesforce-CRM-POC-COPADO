/**
* --------------------------------------------------------------------------------------------------------------
* @Name             WT_GoalPopulationLogic
* @Author           Krupa Chinthakindi
* @Version          v1.0
* @CreatedDate      12-03-2022
* @UsedBy      
* -----------------------------------------------------------------------------------------------------------------------------
* @Description      This class used to update the goal results in the Goal object.
------------------------------------------------------------------------------------------------------------------------------------------
**/

public with sharing class WT_GoalPopulationLogic {
    @InvocableMethod(
        label='Calculate Goal Info'
        description='Update the goal by using the goal metric'
    )
    public static List<String> updateGoal(List<Id> goalId) {
        List<String> errors;
        List<WT_Goal__c> goals = [
            SELECT
                Id,
                WT_Goal_Metric__c,
                WT_Date_From__c,
                WT_Run_Rate_To_Goal__c,
                WT_Date_To__c,
                WT_Target__c,
                WT_Goal_Owner__c,
                WT_Parent_Goal__c,
                WT_Date_Last_In_Progress_Rolled_Up__c,
                LastModifiedDate,
                WT_Should_Roll_Up_From_Child__c,
                WT_Percentage_Achieved__c,
                WT_Actual__c,
                WT_In_Progress__c
            FROM WT_Goal__c
            WHERE Id IN :goalId
        ];

        List<WT_Goal__c> indGoals = new List<WT_Goal__c>();
        Set<Id> parentGoalIds = new Set<Id>();
        for(WT_Goal__c gol : goals){
            if(gol.WT_Should_Roll_Up_From_Child__c == false){
                indGoals.add(gol);
            }
            else{
                parentGoalIds.add(gol.Id);
            }
 
        }
        if(indGoals.size()>0 && !indGoals.isEmpty()){
              system.debug('pindGoals**'+indGoals);
              errors = calculateIndividualGoal(indGoals);
        }
        system.debug('parentGoalIds**'+parentGoalIds);

        if((parentGoalIds.size()>0 && !parentGoalIds.isEmpty())){
              calculateParentGoal(parentGoalIds);      
        }
		return errors;
    }

    //Krupa: This method is to calculate all roll up childs for the Parent Goal
    //It calculates all the Actuals/InProgress from all the childs and populates on Parent Goal Actual field
    public static void calculateParentGoal(Set<Id> parentGoalIds){
            system.debug('parentGoalMap**'+parentGoalIds);
            List<AggregateResult> aggResults = [
                SELECT WT_Parent_Goal__c, SUM(WT_In_Progress__c), SUM(WT_Actual__c)
                FROM WT_Goal__c
                WHERE WT_Parent_Goal__c IN :parentGoalIds
                GROUP BY WT_Parent_Goal__c
            ];

            system.debug('aggrResults'+aggResults);
        	
        	Map<Id,WT_Goal__c> goalsMap = new Map<Id,WT_Goal__c>(
            	[SELECT Id, WT_Actual__c,WT_Date_Last_In_Progress_Rolled_Up__c,LastModifiedDate, WT_Target__c, WT_Date_To__c, WT_Date_From__c, WT_In_Progress__c
                FROM WT_Goal__c
                WHERE Id IN :parentGoalIds]
            );
            system.debug('GoalMap**'+goalsMap);
           
            List<WT_Goal__c> goals4UpdLst = new List<WT_Goal__c>();
            for (AggregateResult aggr : aggResults) {
                Id goalId = (Id)aggr.get('WT_Parent_Goal__c');
                Id currentGoalId = (Id)aggr.get('WT_Parent_Goal__c'); 
                WT_Goal__c gl = new WT_Goal__c();
                gl.Id = goalId;
                gl.WT_Date_Last_In_Progress_Rolled_Up__c = goalsMap.get(currentGoalId).LastModifiedDate;
                
                if((Decimal)aggr.get('expr1')!=null){
                   gl.WT_Actual__c = (Decimal)aggr.get('expr1');
                   gl.WT_Percentage_Achieved__c = ((Decimal)aggr.get('expr1')/(goalsMap.get(currentGoalId).WT_Target__c)) * 100;
                   Integer monthsDiff = Date.valueOf(goalsMap.get(currentGoalId).WT_Date_From__c).monthsBetween(Date.today()); 
                   system.debug('dts'+ monthsDiff);
                   Integer monthsDiff2 = Date.valueOf(goalsMap.get(currentGoalId).WT_Date_From__c).monthsBetween(Date.valueOf(goalsMap.get(currentGoalId).WT_Date_To__c));
                   system.debug('dts'+ monthsDiff2);
                   Decimal RR = (Decimal)aggr.get('expr1')/(goalsMap.get(currentGoalId).WT_Target__c);
                   gl.WT_Run_Rate_To_Goal__c = ((RR / monthsDiff) * monthsDiff2) * 100;
                   system.debug('RR'+ gl.WT_Run_Rate_To_Goal__c);
                }
                if((Decimal)aggr.get('expr0')!=null){
                   gl.WT_In_Progress__c = (Decimal)aggr.get('expr0');
                }
                goals4UpdLst.add(gl);
                parentGoalIds.remove(goalId); 
            }
            if(parentGoalIds.size() > 0) {
                for(Id goalId : parentGoalIds) {
                    goals4UpdLst.add(
                        new WT_Goal__c(
                            Id = goalId,
                            WT_Actual__c = 0,
                            WT_In_Progress__c = 0
                        )
                    );
                }
            }
           
            system.debug('goals'+goals4UpdLst.size());
            if(goals4UpdLst.size() > 0) {
                update goals4UpdLst;
            } 
    }

   // Krupa: This method is to update the actual and InProgress calculations for Individual goals
    public static List<String> calculateIndividualGoal(List<WT_Goal__c> indGoals){

        system.debug('Inside');
        List<String> errors = new List<String>();
        List<WT_Goal_Metric__c> goalMetrics = [
            SELECT
                Id,
                WT_Metric_Type__c,
                WT_Actual_Result_Date_Field_API_Name__c,
                WT_CRM_Object_API_Name__c,
                WT_CRM_Field_API_Name__c,
                WT_Actual_Result_Criteria__c,
                WT_Actual_Result_Criteria_Logic__c,
                WT_InProgress_Result_Criteria__c,
                WT_In_Progress_Criteria_Logic__c,
                WT_InProgress_Result_Date_Field_API_Name__c
            FROM WT_Goal_Metric__c
            WHERE Id = :indGoals[0].WT_Goal_Metric__c
        ];
     system.debug('goalMetrics**'+goalMetrics.size());
       
        String actualQuery;
        string inPrgQuery;
        Decimal actualSumOrCount = 0;
        if(!goalMetrics.isEmpty() && goalMetrics.size()>0){   
            if(String.isNotBlank(goalMetrics[0].WT_Actual_Result_Criteria__c)){
                string gmObjectAPIName  = goalMetrics[0].WT_CRM_Object_API_Name__c;
                    actualQuery = getActualQuery(
                    goalMetrics[0],
                    indGoals[0].WT_Date_From__c,
                    indGoals[0].WT_Date_To__c,
                    indGoals[0].WT_Goal_Owner__c
                );

                if (String.isNotBlank(actualQuery)) {
                    string fieldAPIName = string.valueOf(goalMetrics[0].WT_CRM_Field_API_Name__c);
                    string metricType = string.valueOf(goalMetrics[0].WT_Metric_Type__c);
                    actualSumOrCount = sumOrCountLogic(actualQuery,fieldAPIName,metricType);
                    system.debug('actualSumOrCount'+actualSumOrCount);
                    indGoals[0].WT_Actual__c = actualSumOrCount;
                    if (indGoals[0].WT_Target__c != null){
                        indGoals[0].WT_Percentage_Achieved__c =
                            (actualSumOrCount / indGoals[0].WT_Target__c) * 100;
                        indGoals[0].WT_Date_Last_In_Progress_Rolled_Up__c = indGoals[0].LastModifiedDate;
                          Integer monthsDiff = Date.valueOf(indGoals[0].WT_Date_From__c).monthsBetween(Date.today());
                          system.debug('dts'+ monthsDiff);
                          Integer monthsDiff2 = Date.valueOf(indGoals[0].WT_Date_From__c).monthsBetween(Date.valueOf(indGoals[0].WT_Date_To__c));
                          system.debug('dts'+ monthsDiff2);
                          Decimal RR = actualSumOrCount / indGoals[0].WT_Target__c;
                          indGoals[0].WT_Run_Rate_To_Goal__c = ((RR / monthsDiff) * monthsDiff2) * 100;
                          system.debug('RunToGoal****'+ indGoals[0].WT_Run_Rate_To_Goal__c);
                    }
                } 
            }
        system.debug('actualQuery**' + actualQuery);
       if(String.isNotBlank(goalMetrics[0].WT_InProgress_Result_Criteria__c)){
           string gmObjAPIName  = goalMetrics[0].WT_CRM_Object_API_Name__c;
                inPrgQuery = getiPQuery(
                goalMetrics[0],
                indGoals[0].WT_Date_From__c,
                indGoals[0].WT_Date_To__c,
                indGoals[0].WT_Goal_Owner__c
            );

            if (String.isNotBlank(inPrgQuery)) {
                Decimal inPrgSumOrCount = 0;
                string iPfieldAPIName = string.valueOf(goalMetrics[0].WT_CRM_Field_API_Name__c);
                string iPmetricType = string.valueOf(goalMetrics[0].WT_Metric_Type__c);
                inPrgSumOrCount = sumOrCountLogic(inPrgQuery,iPfieldAPIName,iPmetricType);
                indGoals[0].WT_In_Progress__c = inPrgSumOrCount;
            }

            }
        }
        system.debug('inPrgQuery**' + inPrgQuery);
      
      
            try{
                update indGoals[0];
                }
            catch(Exception e){
                    system.debug(e.getMessage());
					errors.add('Goal Id: ' + indGoals[0].Id + '. Excepton: ' + e.getMessage() + '. Line number: ' + e.getLineNumber());                
            }
    
        return errors;
    }

    //Krupa: This method is used do SUM/COUNT based on the Metric Type
    public static Decimal sumOrCountLogic(string dynquery,string fieldName,string metricTyp){
        Decimal sumOrCount = 0;
        if(String.isNotBlank(dynquery)){
            for (Sobject sobj : Database.query(dynquery)) {
                    if (metricTyp == 'SUM') {
                        
                        sumOrCount += (Decimal) sobj.get(fieldName);
                        system.debug('sumOrCount***'+sumOrCount);
                    } else if (metricTyp == 'COUNT') {
                        system.debug('Inside Count');
                        sumOrCount += 1;
                        system.debug('sumOrCount2***'+sumOrCount);
                    }
                }
        }
        system.debug('sumOrCount**'+sumOrCount);
        return sumOrCount;
    }
  // Krupa: This method is used to generate the dynamic query for Actual criteria 
    public static String getActualQuery(
    WT_Goal_Metric__c goalMetric,
    Date goalFromDate,
    Date goalToDate,
    String glOwnerId
) {
    system.debug('goalFromDate***' + goalFromDate);
    system.debug('goalToDate***' + goalToDate);
    String actResult;
    String goalMetrics;
    string DateConcat;
    String gmActualDate;
    String gmObjName;
    String fromDateStr = DateTime.newInstance(
            goalFromDate.year(),
            goalFromDate.month(),
            goalFromDate.day()
        )
        .format('yyyy-MM-dd');
    String toDateStr = DateTime.newInstance(
            goalToDate.year(),
            goalToDate.month(),
            goalToDate.day()
        )
        .format('yyyy-MM-dd');
      
    if (String.isNotBlank(goalMetric.WT_Actual_Result_Criteria__c)) {
        system.debug('Inside ARC');
        actResult = goalMetric.WT_Actual_Result_Criteria__c;
    } 
    String goalType = goalMetric.WT_Metric_Type__c;
    List<String> actualResultConditions = getFilter(
        actResult,
        goalMetric.WT_CRM_Object_API_Name__c
    ); 
    system.debug('actualResultCondition**' + actualResultConditions);
    String criteriaLogic;
    if (String.isNotBlank(goalMetric.WT_Actual_Result_Criteria_Logic__c)) {
        criteriaLogic = goalMetric.WT_Actual_Result_Criteria_Logic__c;
    } 
    String actualQuery;
    if (String.isNotBlank(goalMetric.WT_Actual_Result_Date_Field_API_Name__c)) {
        if(String.isNotBlank(goalMetric.WT_CRM_Field_API_Name__c)){
            actualQuery =
                'SELECT  Id, ' +
                goalMetric.WT_CRM_Field_API_Name__c +
                ',' +
                goalMetric.WT_Actual_Result_Date_Field_API_Name__c +
                ' FROM ' +
                goalMetric.WT_CRM_Object_API_Name__c;
        }
        else{
            actualQuery =
                'SELECT  Id, '+
                goalMetric.WT_Actual_Result_Date_Field_API_Name__c +
                ' FROM ' +
                goalMetric.WT_CRM_Object_API_Name__c;
        }
    } 
    system.debug('actualQuery&&&'+actualQuery);
    String actualQueryFilter = ' WHERE ';
    
    System.debug('actualResultConditions: ' + actualResultConditions);
    string gmActualCrtLogic = getCriteriaLogic(actualResultConditions, criteriaLogic);
    if (String.isNotBlank(gmActualCrtLogic))
    {
        actualQueryFilter += gmActualCrtLogic;
    }
   
    if (String.isNotBlank(goalMetric.WT_Actual_Result_Date_Field_API_Name__c)) { 
        gmActualDate = goalMetric.WT_Actual_Result_Date_Field_API_Name__c;  
    }
    
    gmObjName = goalMetric.WT_CRM_Object_API_Name__c;
    string finalactualQuery =  concatenatedQuery(gmObjName,glOwnerId,gmActualDate,goalFromDate,goalToDate,fromDateStr,toDateStr,actualQueryFilter,actualQuery);
    system.debug('finalQuery**'+finalactualQuery);
    return finalactualQuery;
}

 //Krupa: This method is to generate the query for inProgress Criteria
 public static String getiPQuery(
    WT_Goal_Metric__c goalMetric,
    Date goalFromDate,
    Date goalToDate,
    String glOwnerId
) {
    system.debug('goalFromDate***' + goalFromDate);
    system.debug('goalToDate***' + goalToDate);
    String actResult;
    String goalMetrics;
    string DateConcat;
    String gmActualDate;
    String gmObjName;
    String fromDateStr = DateTime.newInstance(
            goalFromDate.year(),
            goalFromDate.month(),
            goalFromDate.day()
        )
        .format('yyyy-MM-dd');
    String toDateStr = DateTime.newInstance(
            goalToDate.year(),
            goalToDate.month(),
            goalToDate.day()
        )
        .format('yyyy-MM-dd');
    if (String.isNotBlank(goalMetric.WT_InProgress_Result_Criteria__c)) {
        system.debug('Inside ARC');
        actResult = goalMetric.WT_InProgress_Result_Criteria__c;
    } 
    String goalType = goalMetric.WT_Metric_Type__c;
    List<String> actualResultConditions = getFilter(
        actResult,
        goalMetric.WT_CRM_Object_API_Name__c
    ); 
    system.debug('actualResultCondition**' + actualResultConditions);
    String criteriaLogic;
    if (String.isNotBlank(goalMetric.WT_In_Progress_Criteria_Logic__c)) {
        criteriaLogic = goalMetric.WT_In_Progress_Criteria_Logic__c;
    } 
    String inPrgQuery;
    if (String.isNotBlank(goalMetric.WT_InProgress_Result_Date_Field_API_Name__c)) {

        if(String.isNotBlank(goalMetric.WT_CRM_Field_API_Name__c)){
            inPrgQuery =
                'SELECT  Id, ' +
                goalMetric.WT_CRM_Field_API_Name__c +
                ',' +
                goalMetric.WT_InProgress_Result_Date_Field_API_Name__c +
                ' FROM ' +
                goalMetric.WT_CRM_Object_API_Name__c;
        }
        else{
            inPrgQuery =
                'SELECT  Id, '+
                goalMetric.WT_InProgress_Result_Date_Field_API_Name__c +
                ' FROM ' +
                goalMetric.WT_CRM_Object_API_Name__c;
        }

    } 
    String actualQueryFilter = ' WHERE ';
    
    System.debug('actualResultConditions: ' + actualResultConditions);
    string gmInPrgsCrtLogic = getCriteriaLogic(actualResultConditions, criteriaLogic);
    if (String.isNotBlank(gmInPrgsCrtLogic))
    {
        actualQueryFilter += gmInPrgsCrtLogic;
    }
   
    if (String.isNotBlank(goalMetric.WT_InProgress_Result_Date_Field_API_Name__c)) { 
        gmActualDate = goalMetric.WT_InProgress_Result_Date_Field_API_Name__c;  
    }
    
    gmObjName = goalMetric.WT_CRM_Object_API_Name__c;
    string finalinPrgQuery =  concatenatedQuery(gmObjName,glOwnerId,gmActualDate,goalFromDate,goalToDate,fromDateStr,toDateStr,actualQueryFilter,inPrgQuery);
    
    return finalinPrgQuery;
}

//This method is used to concatenate the criteria logic with logical operators.
  //If criteriaLogic is blank,then it appends with AND
  //If the criterialogic is not blank, then it splits the criteria and appends to the dynamic query
public static string getCriteriaLogic(List<string> criteriaCondition, string criteriaLogic){
  
    if (criteriaCondition.size() > 0) {
    if (String.isBlank(criteriaLogic)) {
        criteriaLogic = String.join(criteriaCondition, ' AND ');
        system.debug('criteriaLogic1st**' + criteriaLogic);
    } else {
        String finalCriteriaLogic = '';
        List<String> listCriteriaLogic = criteriaLogic.split('');
        for(String criteriaCharacter : listCriteriaLogic)
        {
            if(criteriaCharacter.isNumeric())
            {
                Integer criteriaInt = Integer.valueOf(criteriaCharacter);
                String actualCriteriaForTheInt = criteriaCondition[criteriaInt - 1];
                finalCriteriaLogic += actualCriteriaForTheInt;
            }
            else
            {
                finalCriteriaLogic += criteriaCharacter;
            }
        }
        
        if(String.isNotBlank(finalCriteriaLogic))
        {
            criteriaLogic = finalCriteriaLogic;
        }
        system.debug('criteriaLogic**' + criteriaLogic);                
    
    }
}
return criteriaLogic;
}

//Krupa: This method is to concatenate the dateField to the dynamic query
//This goal metric date field will tries to compare with Goal Object From and To Dates and appends to the dynamic query
// If Object is Lead, it appends ReferredBY User to dynamic query
//Other than Lead object, it appends OwnerId to the dynamic query
    public static string concatenatedQuery(string gmObjName, string glOwnerId,string DateField,Date goalFromDate, Date goalToDate, string fromDateStr, string toDateStr, string queryFilter, string actualQuery ){
		system.debug('DateField**'+DateField);
        Schema.DisplayType actualFieldType = WT_GoalSettingController.fieldType(gmObjName,DateField);
        String dateTimeValue = String.valueOf(actualFieldType);
        string DateConcat = dateFormat(dateTimeValue,goalFromDate,goalToDate,fromDateStr,toDateStr,DateField);
        system.debug('DateConcat***'+DateConcat);
        String appendActualDate = 'AND';
        string paran = '(';
        string closeParan = ')';
        appendActualDate += +' ' +paran;
        appendActualDate += +DateConcat;
        appendActualDate += +closeParan;
        system.debug('DateField@@**' + appendActualDate);
        queryFilter += +' ' + appendActualDate;
        //Krupa: Added as part of DBSFCRM-3120 User story Goal Owner logic
        String appendWithOwner = 'AND';
        String appendOwner;
        if(gmObjName == 'Lead'){
            appendOwner = 'FinServ__ReferredByUser__c =' + '\'' + glOwnerId + '\'';
            appendWithOwner += +' ' + appendOwner; 
        }
        else{
            appendOwner = 'OwnerId=' + '\'' + glOwnerId + '\'';
            system.debug('OwnerAppend'+ appendOwner);
            appendWithOwner += +' ' + appendOwner;
        }
        queryFilter += +' ' + appendWithOwner;
        actualQuery += queryFilter;
        System.debug('actualQuery: ' + actualQuery); 
    
        return actualQuery;
    
    }

   
//Krupa Added: This logic is to form the concatenation based on field datatype Date/DateTime
   //If it is DateTime, it converts Goal Object From and To Dates into DateTime format and appends to dynamic Query
   // If it is Date, it compares with Goal Object From and To Dates and appends to the dynamic Query
    public static string dateFormat(String dateTimeValue,Date goalFromDate, Date goalToDate, String fromDateStr, String toDateStr, String gmActualDate){
           string dateDTconcat;
           system.debug('gmActualDate**'+gmActualDate);
        if (dateTimeValue == 'DATETIME') {
                        system.debug('InsideDateTime');
                        system.debug('FromDateTime' +goalFromDate);
                        DateTime cvtFromDT = goalFromDate;
                        DateTime cvtToDT = goalToDate;
                        string formatedFromDt = cvtFromDT.format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
                        string formatedToDt = cvtToDT.format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
                        dateDTconcat =
                        +gmActualDate +
                        '>=' +
                        formatedFromDt +
                        ' ' +
                        'AND' +
                        ' ' +
                        gmActualDate +
                        '<=' +
                        formatedToDt;
                      system.debug('DateTimeConcat**'+dateDTconcat);
                  }
        else if(dateTimeValue == 'DATE'){
                      system.debug('InsideDate');
                      dateDTconcat =
                      +gmActualDate +
                      '>=' +
                      fromDateStr +
                      ' ' +
                      'AND' +
                      ' ' +
                      gmActualDate +
                      '<=' +
                      toDateStr; //Eg: CloseDate>=GoalFromDate AND CloseDate<=GoalToDate
      
                  }
        system.debug('dateDTconcat**'+dateDTconcat);
        return dateDTconcat;
      
      }

    static Map<String, String> operatorsMap = new Map<String, String>{
        'equals' => '=',
        'greater than' => '>',
        'not equal to' => '!=',
        'contains' => 'LIKE',
        'less than' => '<',
        'less or equal' => '<=',
        'greater than' => '>',
        'greater or equal' => '>='
    };

    static Map<String, String> datatypeMap = new Map<String, String>{
        'CURRENCY' => 'Integer',
        'NUMBER' => 'Integer',
        'STRING' => 'String',
        'BOOLEAN' => 'String',
        'PICKLIST' => 'String',
        'TEXTAREA' => 'String',
        'DOUBLE' => 'Integer',
        'ADDRESS' => 'String',
        'DATETIME'=> 'String'
    };
    
    // Krupa: This method used to convert the json into list of string and iterate to get the field type
    // and appends the criteria to the dynamic query
    
    public static List<String> getFilter(String filterJson, String objName) {
        System.debug(filterJson);
        string singleFilter;
        List<Object> filters = (List<Object>) JSON.deserializeUntyped(
            filterJson
        );
        List<String> filterStrings = new List<String>();
        for (Object obj : filters) {
            Map<String, Object> objMap = (Map<String, Object>) obj;
            if (objMap.get('field') != null) {
                Schema.DisplayType actualFieldType = WT_GoalSettingController.fieldType(objName,String.valueOf(objMap.get('field')));
                String displayType = String.valueOf(actualFieldType);
                String type = datatypeMap.get(displayType);
                if(operatorsMap.get(String.valueOf(objMap.get('operator'))) == 'LIKE'){
                    singleFilter =  String.valueOf(objMap.get('field')) + ' ' + 'LIKE';
                    system.debug('FilterWithLikeOpr**'+singleFilter);
                }
                else{
                    singleFilter =
                    String.valueOf(objMap.get('field')) +
                    ' ' +
                    operatorsMap.get(String.valueOf(objMap.get('operator'))) +
                    ' ';
                }
                if (type == 'Integer') {
                  
                    if(objMap.get('value') != null && objMap.get('value') != '')
                        singleFilter += Integer.valueOf(objMap.get('value'));
                    else
                        singleFilter += null;
                    system.debug('Integer**' + singleFilter);
                } else {
                    
                    if(objMap.get('value') != null && objMap.get('value') != ''){
                        if(operatorsMap.get(String.valueOf(objMap.get('operator'))) == 'LIKE'){
                        // string  FilterWithLikeOpr =  'LIKE' + ':' +'\'' +'%' + String.valueOf(objMap.get('field')) +'%' +'\'';
                         // system.debug('FilterWithLikeOpr**'+FilterWithLikeOpr);
                         singleFilter += + '\'' +'%' +  String.valueOf(objMap.get('value')) + '%' + '\'';
                         system.debug('singkeFilterLike**' + singleFilter);
                        }
                        else{
                            singleFilter +=
                            '\'' +
                            String.valueOf(objMap.get('value')) +
                                    '\'';
                        }
                 }
                    else 
                        singleFilter += '\'' + '\'';
                }
               
                system.debug('singkeFilter**' + singleFilter);
                filterStrings.add(singleFilter);
            }
        }
        System.debug('filterStrings: ' + filterStrings);
        return filterStrings;
    }


 
}