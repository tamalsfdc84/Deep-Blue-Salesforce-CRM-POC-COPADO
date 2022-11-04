public with sharing class CZWTFCDocusignRequestDTO {
  public HeaderDTO authHeader = new HeaderDTO();
  public EnvelopeRequestDTO envelope = new EnvelopeRequestDTO();
  public RecipientViewRequestDTO recipientView = new RecipientViewRequestDTO();
  public EnvelopeStatusRequestDTO envelopeStatus = new EnvelopeStatusRequestDTO();
  public class HeaderDTO {
    public String Username;
    public String Password;
    public String IntegratorKey;

    HeaderDTO() {
    }
  }

  public class RecipientViewRequestDTO {
    public String authenticationMethod; //This is set to email always
    public String email;
    public String returnUrl;
    public String userName;
    public String clientUserId;
    public String recipientId;
    public String roleName;
  }

  public class EnvelopeRequestDTO {
    public List<CompositeTemplateDTO> compositeTemplates;
    public String status; // set to sent in old code
    public String accountId; //In old code its passed like this. If not ok pass in url as per docs. anyways its there in baseurl obtained in login call
    public String emailSubject;
    public String emailBlurb;
  }

  public class EnvelopeStatusRequestDTO {
    public String envelopeId;
  }

  public class CompositeTemplateDTO {
    public List<ServerTemplateDTO> serverTemplates;
    public List<InlineTemplateDTO> inlineTemplates;
  }

  public class ServerTemplateDTO {
    public String sequence = '1'; //This hard coded to 1 in old code;
    public String templateId;
  }

  public class InlineTemplateDTO {
    public String sequence = '2'; // //This hardcoded to 2 in old code;
    public RecipientDTO recipients;
  }

  public class RecipientDTO {
    public List<SignerDTO> signers;
    public List<SignerDTO> carbonCopies;
  }

  public class SignerDTO {
    public SignerDTO() {
      this.tabs = new EnvelopeRecipientTabDTO();
      this.emailNotification = new EmailNotificationDTO();
    }
    public String name;
    public String email;
    public String recipientId;
    public String roleName; // This should be 'Signer'+ space + 'sequence no e.g. 1, 2, 3'
    public String clientUserId; //= '100';// This was hardcoded to 100 in original apex code
    public EnvelopeRecipientTabDTO tabs;
    public EmailNotificationDTO emailNotification;
  }

  public class EnvelopeRecipientTabDTO {
    public EnvelopeRecipientTabDTO() {
      this.checkboxTabs = new List<CheckboxTabDTO>();
      this.textTabs = new List<TextTabDTO>();
      this.radioGroupTabs = new List<RadioTabDTO>();
    }
    public List<CheckboxTabDTO> checkboxTabs;
    public List<TextTabDTO> textTabs;
    public List<RadioTabDTO> radioGroupTabs;
  }

  public class CheckboxTabDTO {
    public String tabLabel;
    public String selected;
    public String value; //This was there in old code but not found in api doc
  }

  public class TextTabDTO {
    public String tabLabel;
    public String value;
  }

  public class RadioTabDTO {
    public RadioTabDTO() {
      this.radios = new List<RadiosDTO>();
    }
    public String groupName;
    public List<RadiosDTO> radios;
  }

  public class RadiosDTO {
    public String selected;
    public String value;
  }

  public class EmailNotificationDTO {
    public String emailSubject;
    public String emailBody;
    public String supportedLanguage = 'en';
  }
}