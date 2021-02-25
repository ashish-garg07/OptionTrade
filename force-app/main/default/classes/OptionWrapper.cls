public inherited sharing class OptionWrapper {
  @AuraEnabled
  public Integer Strike { get; set; }

  @AuraEnabled
  public String CallORPut { get; set; }

  @AuraEnabled
  public String BuyORSell { get; set; }

  @AuraEnabled
  public Integer PP { get; set; }
}
