public with sharing class CZWTFCProductService {
  private static WintrustEnvConfig__mdt wintrustEnvConfig = CZWTFCHelperRepository.fetchWintrustEnvConfig();
  /**
   * fetch product matrix objects by facts
   */
  public static List<tffa__ProductMatrix__c> readProductMatrix(Map<String, Object> params) {
    List<tffa__ProductMatrix__c> prodMatrixList = new List<tffa__ProductMatrix__c>();

    List<tffa__ProductMatrix__c> updatedprodMatrixList = new List<tffa__ProductMatrix__c>();

    String zipcode = '';

    String stateCode = '';
    String prodCode = '';
    List<String> prodCodeList = new List<String>();
    try {
      if (params.containsKey('zipCode')) {
        zipcode = (String) params.get('zipCode');
      }

      if (params.containsKey('stateCode')) {
        stateCode = (String) params.get('stateCode');
      }

      if (params.containsKey('productCode')) {
        prodCode = (String) params.get('productCode');
        if ((prodCode).contains(',')) {
          prodCodeList = prodCode.split(',');
        } else {
          prodCodeList.add(prodCode);
        }
      }

      if (params.containsKey('productCode')) {
        for (String code : prodCodeList) {
          prodMatrixList.addall(CZWTFCProductRepository.getProdMatrixByProdCode(code));
        }
      } else {
        prodMatrixList = CZWTFCProductRepository.getAllProductsMatrix();
      }

      String channel = params.containsKey('channel') ? (String) params.get('channel') : null;
      List<tffa__ProductMatrix__c> prodMatrixupdatedList = new List<tffa__ProductMatrix__c>();
      if (channel != null) {
        for (tffa__ProductMatrix__c prodMatrix : prodMatrixList) {
          if (prodMatrix.tffa__ChannelSet__c == null) {
            prodMatrixupdatedList.add(prodMatrix);
          } else if (prodMatrix.tffa__ChannelSet__c.contains(channel)) {
            prodMatrixupdatedList.add(prodMatrix);
          }
        }
      }

      if (!prodMatrixupdatedList.isEmpty()) {
        prodMatrixList.clear();
        prodMatrixList = prodMatrixupdatedList;
      }

      if (String.isNotBlank(stateCode)) {
        updatedprodMatrixList = validateStateAndZip(prodMatrixList, zipcode, stateCode);
      } else {
        updatedprodMatrixList = prodMatrixList;
      }

      List<tffa__ProductMatrix__c> brandCheckprodMatrixList = new List<tffa__ProductMatrix__c>();
      for (tffa__ProductMatrix__c prodObj : updatedprodMatrixList) {
        if (String.isNotBlank(prodObj.tffa__BrandCodeSet__c)) {
          if ((prodObj.tffa__BrandCodeSet__c).contains((String) params.get('brandCode'))) {
            brandCheckprodMatrixList.add(prodObj);
          }
        } else {
          brandCheckprodMatrixList.add(prodObj);
        }
      }

      //Check prod is eligible for the branch.
      updatedprodMatrixList = CZWTFCProductService.filterProdMatbyBranch(brandCheckprodMatrixList, params);
    } catch (Exception ex) {
      tffa.Logger.error('Exception in Product Service ' + ex.getMessage() + ' ' + ex.getStackTraceString());
    }
    return updatedprodMatrixList;
  }

  /**
   * Returns Product List
   */
  public static List<tffa__Product__c> readProducts(List<tffa__ProductMatrix__c> prodMatrix, Map<String, Object> paramMap) {
    List<tffa__Product__c> productList = new List<tffa__Product__c>();
    List<String> ids = new List<String>();
    Map<Id, List<tffa__ProductMatrix__c>> prodMatMap = new Map<Id, List<tffa__ProductMatrix__c>>();
    String channel;
    if (paramMap.containsKey('channel')) {
      channel = (String) paramMap.get('channel');
    }

    for (tffa__ProductMatrix__c prodMat : prodMatrix) {
      ids.add(prodMat.tffa__Product__c);
      if (channel == 'BRANCH') {
        if (prodMatMap.containsKey(prodMat.tffa__Product__c)) {
          List<tffa__ProductMatrix__c> prodM = prodMatMap.get(prodMat.tffa__Product__c);
          prodM.add(prodMat);
          prodMatMap.put(prodMat.tffa__Product__c, prodM);
        } else {
          prodMatMap.put(prodMat.tffa__Product__c, new List<tffa__ProductMatrix__c>{ prodMat });
        }
      }
    }

    Map<String, Object> params = new Map<String, Object>();
    params.put('Id', ids);
    tffa.QueryContext qc = new tffa.QueryContext(params);
    productList = tffa.ProductService.readAll(qc);
    if (channel == 'BRANCH') {
      setProductMatrix(productList, prodMatMap);
    }
    //Map<String, InterestPlanDetails__c> interestPlanMap = CZWTFCHelperRepository.fetchInterestPlanMap(submission.tffa__Brand__c);
    if (wintrustEnvConfig.InterestRateAutomation__c || Test.isRunningTest()) {
      for (tffa__Product__c product : productList) {
        if (product.InterestPlanCode__c != null) {
          String interestPlanCode = product.InterestPlanCode__c;
          Map<String, Object> apyMap = getAPYToDisplay(interestPlanCode, (String) paramMap.get('brandCode'));
          Boolean isTiered = (Boolean) apyMap.get('isTiered');
          String apyToSet = (String) apyMap.get('apyToSet');
          Boolean isRateAvailable = (Boolean) apyMap.get('isRateAvailable');

          Integer loopCtr = 0;
          for (tffa__ProductFeature__c productFeature : product.tffa__Features__r) {
            if (CZWTFCConstants.ANNUAL_PERCENTAGE_YIELD.equals(productFeature.tffa__Label__c)) {
              if (isRateAvailable) {
                if (isTiered) {
                  productFeature.tffa__Description__c = apyToSet;
                } else {
                  productFeature.tffa__Value__c = apyToSet;
                }
              } else {
                productFeature.tffa__Disabled__c = true;
              }
            }
            loopCtr++;
          }
        } else if (product.tffa__Terms__r != null && product.tffa__Terms__r.size() > 0) {
          for (tffa__ProductTerm__c productTerm : product.tffa__Terms__r) {
            String interestPlanCode = productTerm.tffa__InterestPlanCode__c;
            String label = productTerm.tffa__Label__c;
            Map<String, Object> apyMap = getAPYToDisplay(interestPlanCode, (String) paramMap.get('brandCode'));
            Boolean isTiered = (Boolean) apyMap.get('isTiered');
            String apyToSet = (String) apyMap.get('apyToSet');
            Boolean isRateAvailable = (Boolean) apyMap.get('isRateAvailable');

            Integer loopCtr = 0;
            for (tffa__ProductFeature__c productFeature : product.tffa__Features__r) {
              if (
                CZWTFCConstants.ANNUAL_PERCENTAGE_YIELD.equals(productFeature.tffa__Label__c) &&
                label.equals(productFeature.tffa__Description__c)
              ) {
                if (isRateAvailable) {
                  if (isTiered) {
                    productFeature.tffa__Description__c = apyToSet;
                  } else {
                    productFeature.tffa__Value__c = apyToSet;
                  }
                } else {
                  productFeature.tffa__Disabled__c = true;
                }
              }
              loopCtr++;
            }
          }
        }
      }
    }
    fetchInterestRateDetails(productList, (String) paramMap.get('brandCode'));
    // productList = CZWTFCProductRepository.readAllProducts(ids);
    return productList;
  }

  public static void fetchInterestRateDetails(List<tffa__Product__c> productList, String brandCode) {
    Map<String, InterestPlanDetails__c> interestPlanMap = CZWTFCHelperRepository.fetchInterestPlanMap(brandCode);
    for (tffa__Product__c prod : productList) {
      if (
        prod.tffa__Category__c == 'CERTIFICATE' ||
        prod.tffa__Category__c == 'BUSINESS_CERTIFICATE' ||
        (prod.tffa__Category__c == 'IRA' &&
        prod.tffa__AllowedInvestmentAccountType__c != null &&
        prod.tffa__AllowedInvestmentAccountType__c == 'CERTIFICATE')
      ) {
        for (tffa__ProductTerm__c pdTerm : prod.tffa__Terms__r) {
          if (interestPlanMap.containsKey(pdTerm.tffa__InterestPlanCode__c)) {
            pdTerm.tffa__Rate__c = interestPlanMap.get(pdTerm.tffa__InterestPlanCode__c).InterestRate__c;
          }
          if (interestPlanMap.containsKey(pdTerm.CZFounderInterestPlan__c)) {
            pdTerm.CZFounderInterestRate__c = interestPlanMap.get(pdTerm.CZFounderInterestPlan__c).InterestRate__c;
          }
        }
      }
    }
  }

  public static void setProductMatrix(List<tffa__Product__c> products, Map<Id, List<tffa__ProductMatrix__c>> prodMatMap) {
    for (Integer indx = 0; indx < products.size(); indx++) {
      if (prodMatMap.containsKey(products[indx].Id)) {
        tffa.SObjectAssembler prodObjAssembler = new tffa.SObjectAssembler(products[indx]);
        prodObjAssembler.setChildObjects('Matrices__r', prodMatMap.get(products[indx].Id));
        products.set(indx, (tffa__Product__c) prodObjAssembler.assemble());
      }
    }
  }

  private static Map<String, Object> getAPYToDisplay(String interestPlanCode, String brandCode) {
    List<InterestPlanDetails__c> intPlanDetailsList = CZWTFCHelperRepository.fetchInterestPlanDetails(interestPlanCode, brandCode);
    String apyToSet = '';
    Boolean isTiered = false;
    Boolean isRateAvailable = true;
    if (intPlanDetailsList != null && intPlanDetailsList.size() > 0) {
      if (intPlanDetailsList.size() == 1 && 'N'.equals(intPlanDetailsList.get(0).RteSchedInd__c)) {
        //Non-tiered
        if (intPlanDetailsList.get(0).APY__c != null) {
          apyToSet = intPlanDetailsList.get(0).APY__c + CZWTFCConstants.PERCENTAGE;
        } else {
          isRateAvailable = false;
        }
      } else {
        //Tiered
        Map<Double, InterestPlanDetails__c> tierDtlsMap = new Map<Double, InterestPlanDetails__c>();
        for (InterestPlanDetails__c intPlanDetails : intPlanDetailsList) {
          //Loop and create map
          tierDtlsMap.put(intPlanDetails.TierMinBal__c, intPlanDetails);
        }
        //Sort map based on ascending tier min balance
        List<Double> tierKeyList = new List<Double>();
        tierKeyList.addAll(tierDtlsMap.keySet());
        tierKeyList.sort();
        //Create APY string to display
        for (Double tierKey : tierKeyList) {
          InterestPlanDetails__c intPlanDtls = tierDtlsMap.get(tierKey);
          if (intPlanDtls.APY__c != null) {
            apyToSet =
              apyToSet +
              CZWTFCConstants.DOLLAR +
              intPlanDtls.TierMinBal__c +
              ' - ' +
              CZWTFCConstants.DOLLAR +
              intPlanDtls.TierMaxBal__c +
              ': ' +
              intPlanDtls.APY__c +
              CZWTFCConstants.PERCENTAGE +
              CZWTFCConstants.LINE_BRK;
          } else {
            isRateAvailable = false;
            break;
          }
        }
        if (isRateAvailable) {
          apyToSet = apyToSet.substring(0, apyToSet.lastIndexOf(CZWTFCConstants.LINE_BRK));
        }
        isTiered = true;
      }
    } else {
      isRateAvailable = false;
    }
    Map<String, Object> apyMap = new Map<String, Object>();
    apyMap.put('apyToSet', apyToSet);
    apyMap.put('isTiered', isTiered);
    apyMap.put('isRateAvailable', isRateAvailable);
    return apyMap;
  }

  /**
   * Filter Product Matrix by Branch Code
   * Params: List<tffa__ProductMatrix__c> , Map<String, Object>.
   * Return: List<tffa__ProductMatrix__c>
   */
  private static List<tffa__ProductMatrix__c> filterProdMatbyBranch(List<tffa__ProductMatrix__c> prodMatrix, Map<String, Object> params) {
    List<tffa__ProductMatrix__c> updatedProdMatrix = new List<tffa__ProductMatrix__c>();
    Map<String, tffa__Location__c> brandLocationMap = fetchLocationMap(prodMatrix, params);
    String branchCode = params.containsKey('branchCode') ? (String) params.get('branchCode') : null;

    for (tffa__ProductMatrix__c prodMat : prodMatrix) {
      List<String> branchProdLst = prodMat.tffa__LocationCodeSet__c != null
        ? getBranchList(prodMat.tffa__LocationCodeSet__c, brandLocationMap)
        : new List<String>();

      if (prodMat.tffa__LocationCodeSet__c == null) {
        updatedProdMatrix.add(prodMat);
      } else if (branchCode != null && branchProdLst.contains(branchCode)) {
        updatedProdMatrix.add(prodMat);
      }
    }
    return updatedProdMatrix;
  }

  /**
   * Fetch fetchLocationMap
   * Params: List<tffa__ProductMatrix__c>.
   * Return: Map<String, tffa__Location__c> where String is tffa__Code__c
   */
  private static Map<String, tffa__Location__c> fetchLocationMap(List<tffa__ProductMatrix__c> prodMatrix, Map<String, Object> params) {
    List<String> brandLocationIdLst = new List<String>();
    String brandCode = (String) params.get('brandCode');
    List<tffa__BrandLocation__c> brandLocation = CZWTFCProductRepository.fetchLocationByCodes(brandCode);

    for (tffa__BrandLocation__c brandLoc : brandLocation) {
      brandLocationIdLst.add(brandLoc.tffa__Location__c);
    }

    return CZWTFCProductRepository.fetchLocationByIds(brandLocationIdLst);
  }

  /**
   * Get FIS Branch String List from locationSet
   * Params:String(LocationSet), Map<String, tffa__Location__c> where String is tffa__Code__c.
   * Return: List<String>
   */
  private static List<String> getBranchList(String locationSet, Map<String, tffa__Location__c> brandLocationMap) {
    List<String> branchLst = new List<String>();
    List<String> locationLst = locationSet.split(';');
    locationLst.remove(0);
    for (String locCode : locationLst) {
      if (brandLocationMap.containsKey(locCode)) {
        branchLst.add(brandLocationMap.get(locCode).FISBranchCode__c);
      }
    }
    return branchLst;
  }

  /**
   * validate State And Zip
   * Params: List<tffa__ProductMatrix__c>, zipcode, stateCode.
   * Return: List<tffa__ProductMatrix__c>
   */
  private static List<tffa__ProductMatrix__c> validateStateAndZip(
    List<tffa__ProductMatrix__c> prodMatrixList,
    String zipCode,
    String stateCode
  ) {
    List<tffa__ProductMatrix__c> updatedprodMatrixList = new List<tffa__ProductMatrix__c>();
    for (tffa__ProductMatrix__c prodMatrixObj : prodMatrixList) {
      if (String.isNotBlank(zipcode) && String.isNotBlank(stateCode)) {
        if (String.isNotBlank(prodMatrixObj.ZipCodeSet__c) && String.isNotBlank(prodMatrixObj.StateCodeSet__c)) {
          if ((prodMatrixObj.ZipCodeSet__c).contains(zipcode) && (prodMatrixObj.StateCodeSet__c).contains(stateCode)) {
            updatedprodMatrixList.add(prodMatrixObj);
          }
        } else if (String.isNotBlank(prodMatrixObj.StateCodeSet__c)) {
          if ((prodMatrixObj.StateCodeSet__c).contains(stateCode)) {
            updatedprodMatrixList.add(prodMatrixObj);
          }
        } else {
          updatedprodMatrixList.add(prodMatrixObj);
        }
      } else if (String.isNotBlank(stateCode)) {
        if (String.isNotBlank(prodMatrixObj.StateCodeSet__c)) {
          if ((prodMatrixObj.StateCodeSet__c).contains(stateCode)) {
            updatedprodMatrixList.add(prodMatrixObj);
          }
        } else {
          updatedprodMatrixList.add(prodMatrixObj);
        }
      }
    }
    return updatedprodMatrixList;
  }
}