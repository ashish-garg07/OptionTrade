import { LightningElement } from "lwc";
import calculateSrategyPayoff from "@salesforce/apex/OptionProfitLoss.calculateSrategyPayoff";

const actions = [{ label: "Delete", name: "delete" }];

const columns = [
  { label: "Strike", fieldName: "Strike" },
  { label: "Call OR Put", fieldName: "CallORPut" },
  { label: "Buy OR Sell", fieldName: "BuyORSell" },
  { label: "Expiry Start Range", fieldName: "expStart" },
  { label: "Expiry End Range", fieldName: "expEnd" },
  { label: "Premium Paid", fieldName: "PP" },
  {
    type: "action",
    typeAttributes: { rowActions: actions }
  }
];

const columnsProfitLoss = [
  { label: "Expiry", fieldName: "expiry" },
  { label: "Profit/Loss", fieldName: "profitOrLoss" }
];

export default class OptionCalcForm extends LightningElement {
  columns = columns;
  columnsProfitLoss = columnsProfitLoss;
  id = 1;
  optionData = [];
  optionProfitLoss = [];
  Strike;
  CallORPut;
  BuyORSell;
  expStart;
  expEnd;
  PP;

  get callorput() {
    return [
      { label: "Call", value: "Call" },
      { label: "Put", value: "Put" }
    ];
  }

  get buyorsell() {
    return [
      { label: "Buy", value: "Buy" },
      { label: "Sell", value: "Sell" }
    ];
  }

  get sizeOfArray() {
    return this.optionData.length > 0 ? true : false;
  }
  handleChange(event) {
    this[event.target.name] = event.target.value;
  }
  handleAddOption() {
    let obj = {
      id: this.id,
      Strike: this.Strike,
      CallORPut: this.CallORPut,
      BuyORSell: this.BuyORSell,
      expStart: this.expStart,
      expEnd: this.expEnd,
      PP: this.PP
    };
    this.optionData = [obj, ...this.optionData];
    this.id++;
    console.log(this.optionData);
  }

  handleRowAction(event) {
    const actionName = event.detail.action.name;
    const row = event.detail.row;
    switch (actionName) {
      case "delete":
        this.deleteRow(row);
        break;
      default:
    }
  }

  deleteRow(row) {
    const { id } = row;
    const index = this.findRowIndexById(id);
    if (index !== -1) {
      this.optionData = this.optionData
        .slice(0, index)
        .concat(this.data.slice(index + 1));
    }
  }

  findRowIndexById(id) {
    let ret = -1;
    this.optionData.some((row, index) => {
      if (row.id === id) {
        ret = index;
        return true;
      }
      return false;
    });
    return ret;
  }

  calculateOption() {
    console.log(this.optionData);
    calculateSrategyPayoff({ userData: this.optionData })
      .then((result) => (this.optionProfitLoss = result))
      .catch((error) => console.log(error));
  }
}
