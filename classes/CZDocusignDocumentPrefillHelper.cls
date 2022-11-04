public with sharing class CZDocusignDocumentPrefillHelper {
  public static void prefillTextField(String fieldName, String prefillValue, CZWTFCDocusignRequestDTO.SignerDTO signerDTO) {
    if (String.isBlank(prefillValue)) {
      return;
    }
    CZWTFCDocusignRequestDTO.TextTabDTO txt = new CZWTFCDocusignRequestDTO.TextTabDTO();
    txt.tabLabel = fieldName;
    txt.value = prefillValue;
    signerDTO.tabs.textTabs.add(txt);
  }

  public static void prefillCheckBoxField(String fieldName, String prefillValue, CZWTFCDocusignRequestDTO.SignerDTO signerDTO) {
    CZWTFCDocusignRequestDTO.CheckboxTabDTO txt = new CZWTFCDocusignRequestDTO.CheckboxTabDTO();
    txt.tabLabel = fieldName;
    txt.value = prefillValue;
    txt.selected = 'true';
    signerDTO.tabs.checkboxTabs.add(txt);
  }

  public static void prefillRadioField(String fieldName, String prefillValue, CZWTFCDocusignRequestDTO.SignerDTO signerDTO) {
    CZWTFCDocusignRequestDTO.RadioTabDTO txt = new CZWTFCDocusignRequestDTO.RadioTabDTO();
    txt.radios = new List<CZWTFCDocusignRequestDTO.RadiosDTO>();
    CZWTFCDocusignRequestDTO.RadiosDTO radiovalue = new CZWTFCDocusignRequestDTO.RadiosDTO();
    txt.groupName = fieldName;
    radiovalue.value = prefillValue;
    radiovalue.selected = 'true';
    txt.radios.add(radiovalue);

    signerDTO.tabs.radioGroupTabs.add(txt);
  }
}