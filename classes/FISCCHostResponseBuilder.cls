public interface FISCCHostResponseBuilder {
  FISCCTransactionResponseBaseDTO build(String response, FISCC_Adapter_Configs__mdt adapterConfig, FISCC_Charter_Config__mdt charterConfig);
  Object parseResponse(
    FISCCTransactionResponseBaseDTO response,
    FISCC_Adapter_Configs__mdt adapterConfig,
    FISCC_Charter_Config__mdt charterConfig
  );
}