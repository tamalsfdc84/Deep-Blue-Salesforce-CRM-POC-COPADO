public with sharing class CZDocusignDocumentGenDTO {
  public DocumentDTO documentDTO = new DocumentDTO();

  public class DocumentDTO {
    public String documentId;
    public String name;
    public Integer sequenceNumber;
    public String signingType;
    public String documentType;
    //Application/Product ID to which this document will belong to.
    public String applicationId;
    //Party Id to which this document belongs to
    public String partyId;
    //Count of signers added to the document
    //public Integer signersCount = 0;
    public List<SignerDTO> lstSignerDTO;
  }

  public class PrefillDataDTO {
    public List<TextDTO> lstTextDTO = new List<TextDTO>();
    public List<CheckboxDTO> lstCheckBoxTO = new List<CheckboxDTO>();
    public List<RadioDTO> lstRadioTO = new List<RadioDTO>();
  }

  public class CheckboxDTO {
    public String name;
    public String selected;
    public String value;
  }
  public class RadioDTO {
    public String name;
    public List<RadiovalueDTO> radios;
  }

  public class RadiovalueDTO {
    public String selected;
    public String value;
  }

  public class TextDTO {
    public String name;
    public String value;
  }

  public class SignerDTO {
    public String recipientId;
    public String name;
    public String email;
    public String roleName;
    public String clientUserId;
    public Integer sequenceNo;
    public String signingMethod;
    public Boolean dummySigner = false;
    public PrefillDataDTO prefillDataDTO = new PrefillDataDTO();
  }
}