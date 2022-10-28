public with sharing class CZWTFCGenDisclosurePdfProvider {
  public boolean generateDisclosurePdf(tffa__Submission__c sub) {
    CZWTFCGenDisclosurePdfProvider pdfProvider = new CZWTFCGenDisclosurePdfProvider();
    Map<String, String> mp = new Map<String, String>();
    try {
      tffa__Brand__c brandObj = CZWTFCBrandRepository.fetchBrandByCode(sub.tffa__Brand__c);
      Set<String> eventNameSet = new Set<String>();

      for (tffa__Disclosure__c dis : sub.tffa__Disclosures__r) {
        eventNameSet.add(dis.tffa__EventName__c);
      }

      //for group disclosures
      List<String> eventLst = new List<String>(eventNameSet);
      if (!eventLst.isEmpty()) {
        for (Integer idx = 0; idx < eventLst.size(); idx++) {
          String disclosure = '';
          if (eventLst[idx].equalsIgnoreCase('AccountDetails_OD')) {
            disclosure += '\nPlease take a moment to review your selection. Is everything correct?';
          }
          for (tffa__Disclosure__c dis : sub.tffa__Disclosures__r) {
            if (dis.tffa__EventName__c != null && dis.tffa__EventName__c.equalsIgnoreCase(eventLst[idx])) {
              if (CZWTFCConstants.disclosureLabelMap.containsKey(dis.tffa__Label__c)) {
                disclosure += ' \n\n' + CZWTFCConstants.disclosureLabelMap.get(dis.tffa__Label__c);
              } else {
                disclosure += ' \n\n' + dis.tffa__Label__c;
              }
            }
          }
          if (eventLst[idx].equalsIgnoreCase('AccountDetails_OD')) {
            disclosure +=
              '\n\nYou have a right to change these selections at any time by calling ' +
              brandObj.ContactNumber__c +
              ' or visiting your local branch.';
            Date startDate = system.today();
            Datetime dt = DateTime.newInstance(startDate, Time.newInstance(0, 0, 0, 0));
            String dayOfWeek = dt.format('EEEE');
            String month = dt.format('MMMM');
            disclosure +=
              '\n\n' +
              dayofWeek +
              ', ' +
              month +
              ' ' +
              String.valueOf(Date.Today().Day()) +
              ' ,' +
              String.valueOf(Date.Today().Year());
          }
          if (eventLst[idx].equalsIgnoreCase('AccountDetails_OD')) {
            disclosure = disclosure.replace('<div>', '');
            disclosure = disclosure.replace('</div>', ' \n');
            disclosure = disclosure.replace('<b>', '');
            disclosure = disclosure.replace('</b>', '');
          }
          mp.put(eventLst[idx], disclosure);
        }
      }

      for (String key : mp.keySet()) {
        pdfProvider.createPDF(key, mp.get(key), sub);
      }
      return true;
    } catch (Exception ex) {
      tffa.Logger.error('Exception msg in CZWTFCGenDisclosurePdfProvider : ' + ex.getMessage() + ' ' + ex.getStackTraceString());
      return false;
    }
  }

  public void createPDF(String pdfName, String disclosureContent, tffa__Submission__c sub) {
    String updatedPdfName = (CZWTFCConstants.disclosureNameMap.containsKey(pdfName))
      ? CZWTFCConstants.disclosureNameMap.get(pdfName)
      : pdfName;
    PageReference pageRef = Page.DisclosurePdfConverter;
    pageRef.getParameters().put('disclosureTitle', updatedPdfName);
    pageRef.getParameters().put('disclosureText', disclosureContent);
    tffa.DocumentMetadataDTO disclosurePdf = new tffa.DocumentMetadataDTO(updatedPdfName + '.pdf', pageRef.getContent(), sub.id, 'OTHER');
    tffa.ContentService.createContentWithParticipant(disclosurePdf);
  }
}