public without sharing class OptionProfitLoss {
  @AuraEnabled(cacheable=true)
  public static List<Map<String, Integer>> calculateSrategyPayoff(
    List<OptionWrapper> userData
  ) {
    System.debug('user data: ' + userData);
    Map<String, List<Map<String, String>>> dataOption = new Map<String, List<Map<String, String>>>();

    List<Map<String, String>> callList = new List<Map<String, String>>();
    List<Map<String, String>> putList = new List<Map<String, String>>();
    Map<String, String> callMap = null;
    Map<String, String> putMap = null;
    Integer expStart = 0;
    Integer expEnd = 0;
    for (OptionWrapper optWrap : userData) {
      if (optWrap.CallORPut.equalsIgnoreCase('Call')) {
        callMap = new Map<String, String>();
        callMap.put('Action', optWrap.BuyORSell);
        callMap.put('Strike', String.ValueOf(optWrap.Strike));
        callMap.put('pp', String.ValueOf(optWrap.PP));
        callList.add(callMap);
      } else if (optWrap.CallORPut.equalsIgnoreCase('Put')) {
        putMap = new Map<String, String>();
        putMap.put('Action', optWrap.BuyORSell);
        putMap.put('Strike', String.ValueOf(optWrap.Strike));
        putMap.put('pp', String.ValueOf(optWrap.PP));
        putList.add(putMap);
      }
      expStart = (expStart == 0 ||
        optWrap.Strike - 500 < expStart)
        ? optWrap.Strike - 500
        : expStart;
      expEnd = (expEnd == 0 ||
        optWrap.Strike + 500 > expEnd)
        ? optWrap.Strike + 500
        : expEnd;
    }

    dataOption.put('Call', callList);
    dataOption.put('Put', putList);

    List<Map<String, Integer>> profitLossMapList = new List<Map<String, Integer>>();
    Map<String, Integer> profitLossMap = null;

    for (Integer i = 0; i <= (expEnd - expStart); i = i + 50) {
      Integer profitLoss = 0;
      for (String optionType : dataOption.keySet()) {
        for (Map<String, String> listOfMap : dataOption.get(optionType)) {
          if (
            optionType.equalsIgnoreCase('Call') &&
            listOfMap.get('Action').equalsIgnoreCase('Buy')
          ) {
            profitLoss +=
              Math.max(
                0,
                (expStart + i) - Integer.ValueOf(listOfMap.get('Strike'))
              ) - Integer.ValueOf(listOfMap.get('pp'));
          } else if (
            optionType.equalsIgnoreCase('Call') &&
            listOfMap.get('Action').equalsIgnoreCase('Sell')
          ) {
            profitLoss +=
              -Math.max(
                0,
                (expStart + i) - Integer.ValueOf(listOfMap.get('Strike'))
              ) + Integer.ValueOf(listOfMap.get('pp'));
          } else if (
            optionType.equalsIgnoreCase('Put') &&
            listOfMap.get('Action').equalsIgnoreCase('Buy')
          ) {
            profitLoss +=
              Math.max(
                0,
                (Integer.ValueOf(listOfMap.get('Strike')) - (expStart + i))
              ) - Integer.ValueOf(listOfMap.get('pp'));
          } else if (
            optionType.equalsIgnoreCase('Put') &&
            listOfMap.get('Action').equalsIgnoreCase('Sell')
          ) {
            profitLoss +=
              -Math.max(
                0,
                Integer.ValueOf(listOfMap.get('Strike')) - (expStart + i)
              ) + Integer.ValueOf(listOfMap.get('pp'));
          }
        }
      }
      profitLossMap = new Map<String, Integer>();

      profitLossMap.put('expiry', expStart + i);
      profitLossMap.put('profitOrLoss', profitLoss);
      profitLossMapList.add(profitLossMap);
      System.debug('Exp: ' + (expStart + i) + ' Profit/Loss: ' + profitLoss);
    }
    return profitLossMapList;
  }
}
