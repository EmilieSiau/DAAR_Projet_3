pragma solidity >=0.5.8 <0.9.0;
pragma experimental ABIEncoderV2;


contract OpenCollective {

    // ===== Structure definitions =====


    // --- An user
    struct User {
        address addr;
        string name;
        uint256 balance;
        uint64[] projects;
        uint64[] companies;
        uint64[] openedBounties;
        uint64[] savedBounties;
    }

    // --- A company
    struct Company {
        uint64 id;
        string name;
        uint256 balance;
        address owner;
        address[] members;
        uint64[] projects;
    }

    // --- A project
    struct Project {
        uint64 id;
        string name;
        string description;
        uint256 balance;
        address userOwner;
        uint64 companyOwner;
        address[] contributors;
        uint64[] bounties;
    }

    // --- A bounty for a project
    struct Bounty {
        uint64 id;
        uint64 project;
        address creator;
        string name;
        string description;
        uint256 reward;
    }


    // ===== Contract memory definition =====


    // --- The open collective owner
    address private owner;

    // --- The open collective users
    mapping(address => User) private users;

    // --- The registered companies
    mapping(uint64 => Company) private companiesMap;

    // --- The existing projects
    mapping(uint64 => Project) private projectsMap;

    // --- The bounties
    mapping(uint64 => Bounty) private bountiesMap;
    Bounty[] private bountiesList;

    // --- The company id counter
    uint private companyCounter;

    // --- The project id counter
    uint private projectCounter;

    // --- The bounties id counter
    uint private bountyCounter;


    // ===== Constructor =====


    constructor() public {
        owner = msg.sender;

        companyCounter = 0;
        projectCounter = 0;
        bountyCounter = 0;
    }


    // ===== Logging events =====


    // --- Log a new user
    event UserRegistered(address addr, string name);

    // --- Log a new company
    event CompanyRegistered(uint64 id, address owner, string name);

    // --- Log a new personal project
    event NewUserPoject(uint64 id, address owner, string name);

    // --- Log a new company project
    event NewCompanyProject(uint64 id, uint64 owner, string name);

    // --- Log a new bounty
    event NewBounty(uint64 id, uint64 on, string name);

    // --- Log arbitrary messages
    event LogMsg(string msg);
    event LogInt(uint val, string msg);


    // ===== Contract functions =====


    // --- User managment functions 

    // Get the user for an address
    function getUser(address addr) public view returns (User memory) {
        return users[addr];
    }

    // Function to get multiple users
    function getUsers(address[] memory addrs) public view returns (User[] memory) {
        User[] memory res = new User[](addrs.length);
        for(uint i = 0 ; i < addrs.length ; i++) {
            res[i] = users[addrs[i]];
        }
        return res;
    }
    
    // Function to register an user in the database
    function registerUser(string memory name) public returns (User memory) {
        require(bytes(name).length > 0, "User name cannot be empty");
        require(users[msg.sender].addr == address(0), "You cannot register multiple times");

        User memory user;
        user.name = name;
        user.addr = msg.sender;
        user.balance = 0;
        users[msg.sender] = user;

        emit UserRegistered(msg.sender, name);
    }

    // Function to update an user name
    function updateUserName(string memory name) public returns (bool) {
        require(bytes(name).length > 0, "User name cannot be empty");
        require(users[msg.sender].addr != address(0), "You cannot update the name of an unregistered user");

        users[msg.sender].name = name;
        return true;
    }

    // Remove an user from the database
    function removeUser(address addr) public returns (bool) {
        require(msg.sender == owner || msg.sender == addr, "You have not the permission to delete an user");

        delete users[addr];
        return true;
    }

    // Deposit on an user acocunt
    function deposit() public payable returns (bool) {
        require(users[msg.sender].addr != address(0), "You cannot deposite on the count of an unregistered user");

        users[msg.sender].balance += msg.value;
        return true;
    }

    // Withdraw from an user account
    function withdraw(uint val) public returns (bool) {
        require(users[msg.sender].addr != address(0), "You cannot withdraw on the count of an unregistered user");
        require(users[msg.sender].balance >= val, "Insuficient funds to withdraw");
        
        users[msg.sender].balance -= val;

        address payable wal = address(uint160(msg.sender));
        wal.transfer(val);
    }


    // --- Companies managment functions

    // Function to get a single company
    function getCompany(uint64 id) public view returns (Company memory) {
        return companiesMap[id];
    }

    // Function to get a company list
    function getCompanies(uint64[] memory ids) public view returns (Company[] memory) {
        Company[] memory res = new Company[](ids.length);
        for(uint256 i = 0 ; i < ids.length ; i++) {
            res[i] = companiesMap[ids[i]];
        }
        return res;
    }


    // --- Project managment functions

    // Function to get a single project
    function getProject(uint64 id) public view returns (Project memory) {
        return projectsMap[id];
    }

    // Function to get a list of project
    function getProjects(uint64[] memory ids) public view returns (Project[] memory) {
        Project[] memory res = new Project[](ids.length);
        for(uint256 i = 0 ; i < ids.length ; i++) {
            res[i] = projectsMap[ids[i]];
        }
        return res;
    }

    // --- Bounties managment functions

    // Function to get a single bounty
    function getBounty(uint64 id) public view returns (Bounty memory) {
        return bountiesMap[id];
    }

    // Function to get the a list of bounty
    function getBounties(uint64[] memory ids) public view returns (Bounty[] memory) {
        Bounty[] memory res = new Bounty[](ids.length);
        for(uint256 i = 0 ; i < ids.length ; i++) {
            res[i] = bountiesMap[ids[i]];
        }
        return res;
    }

    // Function to get the 10 last bounties
    function getLastBounties(uint offset) public view returns (Bounty[] memory) {
        Bounty[] memory res = new Bounty[](10);
        uint ptr = 0;
        uint256 startIndex = bountiesList.length;
        
        return res;
    }

}


// ===== Utility functions =====

function max(uint256 a, uint256 b) pure returns (uint256) {
    if(a >= b) return a;
    return b;
}