pragma solidity >=0.4.24;
// Define a contract 'Supplychain'
contract SupplyChain {

  // Define 'owner'
  address payable owner;

  // Define id to keep track of cow
  uint  cowID;

  // Define a public mapping 'items' that maps the cowID to an Item.
  mapping (uint => Item) items;

  // Define a public mapping 'itemsHistory' that maps the cowID to an array of TxHash,
  // that track its journey through the supply chain -- to be sent from DApp.
  mapping (uint => string[]) itemsHistory;

  // Define enum 'State' with the following values:
  enum State {
    InitialState, // 0
    Raised,  // 1
    Slaughtered,  // 2
    Split,     // 3
    Cleaned,    // 4
    Graded,       // 5
    ForSaleWholesale,    // 6
    BoughtWholesale,   // 7
    Shipped,   // 8
    ForSaleRetail,  //9
    BoughtRetail  //10
}

  State constant defaultState = State.InitialState;

  // Define a struct 'Item' with the following fields:
  struct Item {
    uint    cowID;
    address ownerID;  // Metamask-Ethereum address of the current owner as the product moves through 10 stages
    address payable originFarmerID; // Metamask-Ethereum address of the Farmer
    string  originFarmName; // Farmer Name
    uint    wholesalePrice; // Wholesale Price
    uint    retailPrice; // Retail Price
    State   itemState;  // Product State as represented in the enum above
    address processorID; // Metamask-Ethereum address of the Processor
    address graderID; // Metamask-Ethereum address of the Grader
    address payable distributorID;  // Metamask-Ethereum address of the Distributor
    address retailerID; // Metamask-Ethereum address of the Retailer
    address consumerID; // Metamask-Ethereum address of the Consumer
  }

  // Define 8 events with the same 8 state values and accept 'cowID' as input argument
  event Raised(uint cowID);
  event Slaughtered(uint cowID);
  event Split(uint cowID);
  event Cleaned(uint cowID);
  event Graded(uint cowID);
  event ForSaleWholesale(uint cowID);
  event BoughtWholesale(uint cowID);
  event Shipped(uint cowID);
  event ForSaleRetail(uint cowID);
  event BoughtRetail(uint cowID);

  // Define a modifer that checks to see if msg.sender == owner of the contract
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

  // Define a modifer that verifies the Caller
  modifier verifyCaller (address _address) {
    require(msg.sender == _address); 
    _;
  }

  // Define a modifier that checks if the paid amount is sufficient to cover the price
  modifier paidEnough(uint _price) { 
    require(msg.value >= _price); 
    _;
  }
  
  // Define a modifier that checks the wholesale price and refunds the remaining balance
  modifier checkWholesaleValue(uint _cowID) {
    _;
    uint _price = items[_cowID].wholesalePrice;
    uint amountToReturn = msg.value - _price;
    msg.sender.transfer(amountToReturn);
  }

  // Define a modifier that checks the retail price and refunds the remaining balance
  modifier checkRetailValue(uint _cowID) {
    _;
    uint _price = items[_cowID].retailPrice;
    uint amountToReturn = msg.value - _price;
    msg.sender.transfer(amountToReturn);
  }

  // Define a modifier that checks if an item.state of a cowID is Raised
  modifier raised(uint _cowID) {
    require(items[_cowID].itemState == State.Raised);
    _;
  }

  // Define a modifier that checks if an item.state of a cowID is Slaughtered
  modifier slaughtered(uint _cowID) {
    require(items[_cowID].itemState == State.Slaughtered);
    _;
  }
  
  // Define a modifier that checks if an item.state of a cowID is Split
  modifier split(uint _cowID) {
    require(items[_cowID].itemState == State.Split);
    _;
  }

  // Define a modifier that checks if an item.state of a cowID is Cleaned
  modifier cleaned(uint _cowID) {
    require(items[_cowID].itemState == State.Cleaned);
    _;
  }

  // Define a modifier that checks if an item.state of a cowID is Graded
  modifier graded(uint _cowID) {
    require(items[_cowID].itemState == State.Graded);
    _;
  }
  
  // Define a modifier that checks if an item.state of a cowID is For Sale Wholesale
  modifier forSaleWholesale(uint _cowID) {
    require(items[_cowID].itemState == State.ForSaleWholesale);
    _;
  }

  // Define a modifier that checks if an item.state of a cowID is Bought Wholesale
  modifier boughtWholesale(uint _cowID) {
    require(items[_cowID].itemState == State.BoughtWholesale);
    _;
  }

  // Define a modifier that checks if an item.state of a cowID is Shipped
  modifier shipped(uint _cowID) {
    require(items[_cowID].itemState == State.Shipped);
    _;
  }

  // Define a modifier that checks if an item.state of a cowID is For Sale Retail
  modifier forSaleRetail(uint _cowID) {
    require(items[_cowID].itemState == State.ForSaleRetail);
    _;
  }

  // Define a modifier that checks if an item.state of a cowID is Bought Retail
  modifier boughtRetail(uint _cowID) {
    require(items[_cowID].itemState == State.BoughtRetail);
    _;
  }

  // In the constructor set 'owner' to the address that instantiated the contract
  // and set 'cowID' to 1
  constructor() public payable {
    owner = msg.sender;
    cowID = 1;
  }

  // Define a function 'kill' if required
  function kill() public {
    if (msg.sender == owner) {
      selfdestruct(owner);
    }
  }

  // Define a function 'raiseCow' that allows a farmer to mark an cow 'Raised'
  function raiseCow(uint _cowID, address payable _originFarmerID, string memory _originFarmName) public
  {
    // Add the new item as part of Harvest
    Item storage thisItem = items[_cowID];
    thisItem.cowID = _cowID;
    thisItem.ownerID = _originFarmerID;
    thisItem.originFarmerID = _originFarmerID;
    thisItem.originFarmName = _originFarmName;
    thisItem.itemState = State.Raised;

    // Emit the appropriate event
    emit Raised(_cowID);
  }

  // Define a function 'slaughterCow' that allows a processor to mark an item 'Slaughtered'
  function slaughterCow(uint _cowID) public
  // Call modifier to check if cowID has passed previous supply chain stage
  raised(_cowID) {
    // Update the appropriate fields
    Item storage thisItem = items[_cowID];
    thisItem.processorID = msg.sender;
    thisItem.itemState = State.Slaughtered;
    // Emit the appropriate event
    emit Slaughtered(_cowID);
  }

  // Define a function 'splitCow' that allows a processor to mark an item 'Split'
  function splitCow(uint _cowID) public
  // Call modifier to check if cowID has passed previous supply chain stage
  slaughtered(_cowID)
  // Call modifier to verify caller of this function
  verifyCaller(items[_cowID].processorID) {
    // Update the appropriate fields
    Item storage thisItem = items[_cowID];
    thisItem.itemState = State.Split;
    // Emit the appropriate event
    emit Split(_cowID);
  }

  // Define a function 'cleanCow' that allows a processor to mark an item 'Cleaned'
  function cleanCow(uint _cowID) public
  // Call modifier to check if cowID has passed previous supply chain stage
  split(_cowID)
  // Call modifier to verify caller of this function
  verifyCaller(items[_cowID].processorID) {
    // Update the appropriate fields
    Item storage thisItem = items[_cowID];
    thisItem.itemState = State.Cleaned;
    // Emit the appropriate event
    emit Cleaned(_cowID);
  }

  // Define a function 'gradeCow' that allows a grader to mark an item 'Graded'
  function gradeCow(uint _cowID) public
  // Call modifier to check if cowID has passed previous supply chain stage
  cleaned(_cowID) {
    // Update the appropriate fields
    Item storage thisItem = items[_cowID];
    thisItem.graderID = msg.sender;
    thisItem.itemState = State.Graded;
    // Emit the appropriate event
    emit Graded(_cowID);
  }

  // Define a function 'packItem' that allows a farmer to mark an item 'Packed'
  function sellWholesale(uint _cowID, uint _price) public
  // Call modifier to check if cowID has passed previous supply chain stage
  graded(_cowID)
  // Call modifier to verify caller of this function
  verifyCaller(items[_cowID].originFarmerID) {
    // Update the appropriate fields
    Item storage thisItem = items[_cowID];
    thisItem.wholesalePrice = _price;
    thisItem.itemState = State.ForSaleWholesale;
    // Emit the appropriate event
    emit ForSaleWholesale(_cowID);
  }

  // Define a function 'buyWholesale' that allows a distributor to buy from the farmer
  function buyWholesale(uint _cowID) public payable
    // Call modifier to check if cowID has passed previous supply chain stage
    forSaleWholesale(_cowID)
    // Call modifer to check if buyer has paid enough
    paidEnough(items[_cowID].wholesalePrice)
    // Call modifer to send any excess ether back to buyer
    checkWholesaleValue(_cowID) {

    // Update the appropriate fields - ownerID, distributorID, itemState
    Item storage thisItem = items[_cowID];
    address payable farmer = thisItem.originFarmerID;
    thisItem.ownerID = msg.sender;
    thisItem.distributorID = msg.sender;
    thisItem.itemState = State.BoughtWholesale;

    // Transfer money to farmer
    farmer.transfer(thisItem.wholesalePrice);

    // emit the appropriate event
    emit BoughtWholesale(_cowID);
  }

  // Define a function 'shipBeef' that allows the distributor to mark an item 'Shipped'
  function shipBeef(uint _cowID) public
    // Call modifier to check if cowID has passed previous supply chain stage
    boughtWholesale(_cowID)
    // Call modifier to verify caller of this function
    verifyCaller(items[_cowID].distributorID) {
    // Update the appropriate fields
    Item storage thisItem = items[_cowID];
    thisItem.itemState = State.Shipped;
    // Emit the appropriate event
    emit Shipped(_cowID);
  }

  // Define a function 'sellRetail' that allows the retailer to mark an item 'For Sale Retail'
  function sellRetail(uint _cowID, uint _price) public
    // Call modifier to check if cowID has passed previous supply chain stage
    shipped(_cowID)
    // Access Control List enforced by calling Smart Contract / DApp
    {
      // Update the appropriate fields - ownerID, retailerID, itemState
      Item storage thisItem = items[_cowID];
      thisItem.ownerID = msg.sender;
      thisItem.retailerID = msg.sender;
      thisItem.retailPrice = _price;
      thisItem.itemState = State.ForSaleRetail;
      // Emit the appropriate event
      emit ForSaleRetail(_cowID);
    }

  // Define a function 'buyRetail' that allows the consumer to mark an item 'Bought Retail'
  // Use the above modifiers to check if the item is received
  function buyRetail(uint _cowID) public payable
    // Call modifier to check if cowID has passed previous supply chain stage
    forSaleRetail(_cowID)
    // Call modifer to check if buyer has paid enough
    paidEnough(items[_cowID].retailPrice)
    // Call modifer to send any excess ether back to buyer
    checkRetailValue(_cowID)
    // Access Control List enforced by calling Smart Contract / DApp
    {
      // Update the appropriate fields - ownerID, consumerID, itemState
      Item storage thisItem = items[_cowID];
      thisItem.ownerID = msg.sender;
      thisItem.consumerID = msg.sender;
      thisItem.itemState = State.BoughtRetail;

      // Transfer money to distributor
      address payable distributor = thisItem.distributorID;
      distributor.transfer(thisItem.retailPrice);

      // Emit the appropriate event
      emit BoughtRetail(_cowID);
    }

  // Define a function 'fetchItemBufferOne' that fetches the data
  function fetchItemBufferOne(uint _cowID) public view returns
  (
  uint    itemCowID,
  address ownerID,
  address originFarmerID,
  string  memory originFarmName
  )
  {
  // Assign values to the 8 parameters
  Item memory thisItem = items[_cowID];
  itemCowID = thisItem.cowID;
  ownerID = thisItem.ownerID;
  originFarmerID = thisItem.originFarmerID;
  originFarmName = thisItem.originFarmName;

  return
  (
  itemCowID,
  ownerID,
  originFarmerID,
  originFarmName
  );
  }

  // Define a function 'fetchItemBufferTwo' that fetches the data
  function fetchItemBufferTwo(uint _cowID) public view returns
  (
  uint    itemCowID,
  uint    wholesalePrice,
  uint    retailPrice,
  uint    itemState,
  address processorID,
  address graderID,
  address distributorID,
  address retailerID,
  address consumerID
  )
  {
    // Assign values to the 9 parameters
    Item memory thisItem = items[_cowID];
    itemCowID = thisItem.cowID;
    wholesalePrice = thisItem.wholesalePrice;
    retailPrice = thisItem.retailPrice;
    itemState = uint(thisItem.itemState);
    processorID = thisItem.processorID;
    graderID = thisItem.graderID;
    distributorID = thisItem.distributorID;
    retailerID = thisItem.retailerID;
    consumerID = thisItem.consumerID;

  return
  (
  itemCowID,
  wholesalePrice,
  retailPrice,
  itemState,
  processorID,
  graderID,
  distributorID,
  retailerID,
  consumerID
  );
  }
}
