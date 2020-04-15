pragma solidity >=0.4.24;

// Import the library 'Roles'
import "./Roles.sol";

// Define a contract 'GraderRole' to manage this role - add, remove, check
contract GraderRole {
  using Roles for Roles.Role;

  // Define 2 events, one for Adding, and other for Removing
  event GraderAdded(address indexed account);
  event GraderRemoved(address indexed account);

  // Define a struct 'graders' by inheriting from 'Roles' library, struct Role
  Roles.Role private graders;

  // In the constructor make the address that deploys this contract the 1st grader
  constructor() public {
    _addGrader(msg.sender);
  }

  // Define a modifier that checks to see if msg.sender has the appropriate role
  modifier onlyGrader() {
    require(isGrader(msg.sender), "Not grader");
    _;
  }

  // Define a function 'isGrader' to check this role
  function isGrader(address account) public view returns (bool) {
    return graders.has(account);
  }

  // Define a function 'addGrader' that adds this role
  function addGrader(address account) public onlyGrader {
    _addGrader(account);
  }

  // Define a function 'renounceGrader' to renounce this role
  function renounceGrader() public {
    _removeGrader(msg.sender);
  }

  // Define an internal function '_addGrader' to add this role, called by 'addGrader'
  function _addGrader(address account) internal {
    graders.add(account);
    emit GraderAdded(account);
  }

  // Define an internal function '_removeGrader' to remove this role, called by 'removeGrader'
  function _removeGrader(address account) internal {
    graders.remove(account);
    emit GraderRemoved(account);
  }
}