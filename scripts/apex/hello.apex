// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents

string tempvar = 'Enter_your_name_here';
System.debug('Hello World!');
System.debug('My name is ' + tempvar);

Map<String,List<Map<String,String>>> dataOption = new Map<String,List<Map<String,String>>>();

List<Map<String,String>> callList = new List<Map<String,String>>();
Map<String,String> callBuyMap = new Map<String,String>();
callBuyMap.put('Action','buy');
callBuyMap.put('Strike','7800');
callBuyMap.put('pp','79');
callList.add(callBuyMap);

Map<String,String> callSellMap = new Map<String,String>();
callSellMap.put('Action','sell');
callSellMap.put('Strike','7900');
callSellMap.put('pp','25');
callList.add(callSellMap);

dataOption.put('Call',callList);



Integer expStart = 7000;
Integer expEnd = 8500;

for(Integer i = 0;i < (expEnd - expStart);i = i + 100){
    Integer profitLoss = 0;
for(String optionType : dataOption.keySet()){
    for(Map<String,String> listOfMap : dataOption.get(optionType)){
    
        if(optionType.equalsIgnoreCase('Call') && listOfMap.get('Action').equalsIgnoreCase('Buy')){
            profitLoss += Math.max(0,(expStart + i) - Integer.ValueOf(listOfMap.get('Strike'))) - Integer.ValueOf(listOfMap.get('pp'));
            
        }else if(optionType.equalsIgnoreCase('Call') && listOfMap.get('Action').equalsIgnoreCase('Sell')){
            profitLoss += -Math.max(0,(expStart + i) - Integer.ValueOf(listOfMap.get('Strike'))) + Integer.ValueOf(listOfMap.get('pp'));
        }else if(optionType.equalsIgnoreCase('Put') && listOfMap.get('Action').equalsIgnoreCase('Buy')){
            profitLoss += -Math.max(0,(Integer.ValueOf(listOfMap.get('Strike')) - (expStart + i))) - Integer.ValueOf(listOfMap.get('pp'));
        }else if(optionType.equalsIgnoreCase('Put') && listOfMap.get('Action').equalsIgnoreCase('Sell')){
            profitLoss += Math.max(0,Integer.ValueOf(listOfMap.get('Strike')) - (expStart + i)) + Integer.ValueOf(listOfMap.get('pp'));
        }
                    
        }
    }
    System.debug('Exp: '+(expStart + i)+' Profit/Loss: '+profitLoss);
}