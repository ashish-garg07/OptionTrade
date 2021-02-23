public inherited sharing class OptionWrapper {
  @AuraEnabled
  public Integer Strike { get; set; }

  @AuraEnabled
  public Integer expStart { get; set; }

  @AuraEnabled
  public Integer expEnd { get; set; }

  @AuraEnabled
  public String CallORPut { get; set; }

  @AuraEnabled
  public String BuyORSell { get; set; }

  @AuraEnabled
  public Integer PP { get; set; }
}
