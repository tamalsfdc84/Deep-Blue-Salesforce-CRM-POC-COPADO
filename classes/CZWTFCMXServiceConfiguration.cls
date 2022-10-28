/**
 * Copyright (c) 2020 Terafina Inc
 * @group  Configuration
 * @description: Contains the wintrust service configurations;
 */
public with sharing class CZWTFCMXServiceConfiguration {
  private static MXConfiguration__mdt mxConfiguration;
  /**
   * @description Return wintrust configuration detail from custom setting
   * @return MXConfiguration__mdt
   */
  public static MXConfiguration__mdt getMXConfig() {
    if (mxConfiguration != null) {
      return mxConfiguration;
    } else {
      return (new MXConfiguration__mdt());
    }
  }
  /**
   * @description set wintrust configuration detail based on the integration service
   * @param
   * @return void
   */
  public static void setMXConfig(CZWTFCMXServiceMapper mxServiceMapper) {
    mxConfiguration = CZWTFCPartyRepository.fetchMxParams(String.valueOf(mxServiceMapper));
  }
}