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
        uint64[] ownedCompanies;
        uint64[] belongedCompanies;
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
    Project[] private projectsList;

    // --- The bounties
    mapping(uint64 => Bounty) private bountiesMap;
    Bounty[] private bountiesList;

    // --- The company id counter
    uint64 private companyCounter;

    // --- The project id counter
    uint64 private projectCounter;

    // --- The bounties id counter
    uint64 private bountyCounter;


    // ===== Constructor =====


    constructor() public {
        owner = msg.sender;

        companyCounter = 0;
        projectCounter = 0;
        bountyCounter = 0;
    }
    
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
    function registerUser(string memory name) public {
        require(bytes(name).length > 0);
        require(users[msg.sender].addr == address(0));

        User memory user;
        user.name = name;
        user.addr = msg.sender;
        user.balance = 0;
        users[msg.sender] = user;
    }

    // Function to update an user name
    // function updateUser(string memory name) public {
    //     require(bytes(name).length > 0);
    //     require(users[msg.sender].addr != address(0));

    //     users[msg.sender].name = name;
    // }

    // Deposit on an user acocunt
    function deposit() public payable {
        require(users[msg.sender].addr != address(0));

        users[msg.sender].balance += msg.value;
    }

    // Withdraw from an user account
    function withdraw(uint val) public {
        require(users[msg.sender].addr != address(0));
        require(users[msg.sender].balance >= val);
        
        users[msg.sender].balance -= val;

        address payable wal = address(uint160(msg.sender));
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

    // Function to register a company
    function registerCompany(string memory name) public {
        require(bytes(name).length > 0);
        require(users[msg.sender].addr != address(0));

        companyCounter++;
        Company memory company;
        company.id = companyCounter;
        company.name = name;
        company.owner = msg.sender;
        company.balance = 0;
        companiesMap[companyCounter] = company;
        companiesMap[company.id].members.push(msg.sender);
        users[msg.sender].ownedCompanies.push(companyCounter);
    }

    // Function to add a member to a company
    function addMember(uint64 id, address member) public {
        require(msg.sender == companiesMap[id].owner);
        require(users[member].addr != address(0));

        companiesMap[id].members.push(member);
        users[member].belongedCompanies.push(id);
    }

    // Function to remove a member from a company
    function removeMember(uint64 id, address member) public {
        require(msg.sender == companiesMap[id].owner);
        require(member != companiesMap[id].owner);

        // Delete the member from the company
        address[] memory newMembers = new address[](companiesMap[id].members.length-1);
        bool found = false;

        for(uint256 i = 0 ; i < companiesMap[id].members.length ; i++) {
            if(companiesMap[id].members[i] == member) {
                found = true;
            } else {
                if(!found) newMembers[i] = companiesMap[id].members[i];
                else newMembers[i-1] = companiesMap[id].members[i];
            }
        }

        companiesMap[id].members = newMembers;

        // Delete the company in the user belonged company
        if(users[member].addr != address(0)) {
            uint64[] memory newBelonged = new uint64[](users[member].belongedCompanies.length-1);
            found = false;

            for(uint256 i = 0 ; i < users[member].belongedCompanies.length ; i++) {
                if(users[member].belongedCompanies[i] == id) {
                    found = true;
                } else {
                    if(!found) newBelonged[i] = users[member].belongedCompanies[i];
                    else newBelonged[i-1] = users[member].belongedCompanies[i];
                }
            }

            users[member].belongedCompanies = newBelonged;
        }
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

    // Function to get the 10 last bounties
    function getLastProjects(uint offset) public view returns (Project[] memory) {
        Project[] memory res = new Project[](10);
        uint ptr = 0;
        uint256 startIndex = projectsList.length - (offset * 10);
        int256 tmp = int256(startIndex) - 10;
        if(tmp < 0) tmp = 0;
        uint256 endIndex = uint256(tmp);

        for(uint256 i = startIndex ; i > endIndex ; i--) {
            res[ptr] = projectsList[(i-1)];
            ptr++;
        }

        return res;
    }

    // Function to add a contributor to a project
    function addContrib(uint64 id, address user) public {
        require(msg.sender == projectsMap[id].userOwner);
        require(users[user].addr != address(0));

        projectsMap[id].contributors.push(user);
        users[user].projects.push(id);
    }

    // Function to remove a contributor from a project
    // function removeContrib(uint64 id, address user) public {
    //     require(msg.sender == projectsMap[id].userOwner);
    //     require(user != projectsMap[id].userOwner);

    //     // Delete the member from the company
    //     address[] memory newContrib = new address[](projectsMap[id].contributors.length-1);
    //     bool found = false;

    //     for(uint256 i = 0 ; i < projectsMap[id].contributors.length ; i++) {
    //         if(projectsMap[id].contributors[i] == user) {
    //             found = true;
    //         } else {
    //             if(!found) newContrib[i] = projectsMap[id].contributors[i];
    //             else newContrib[i-1] = projectsMap[id].contributors[i];
    //         }
    //     }

    //     projectsMap[id].contributors = newContrib;

    //     // Delete the project from the user projects
    //     if(users[user].addr != address(0)) {
    //         uint64[] memory newProjects = new uint64[](users[user].projects.length-1);
    //         found = false;

    //         for(uint256 i = 0 ; i < users[user].projects.length ; i++) {
    //             if(users[user].projects[i] == id) {
    //                 found = true;
    //             } else {
    //                 if(!found) newProjects[i] = users[user].projects[i];
    //                 else newProjects[i-1] = users[user].projects[i];
    //             }
    //         }

    //         users[user].projects = newProjects;
    //     }
    // }

    // Function to create a project for a user
    function createProject(string memory name, string memory description) public {
        require(users[msg.sender].addr != address(0));
        require(bytes(name).length > 0);
        require(bytes(description).length > 0);

        projectCounter++;
        Project memory project;
        project.id = projectCounter;
        project.name = name;
        project.description = description;
        project.balance = 0;
        project.companyOwner = 0;
        project.userOwner = msg.sender;
        projectsMap[projectCounter] = project;
        projectsMap[projectCounter].contributors.push(msg.sender);
        users[msg.sender].projects.push(projectCounter);
        projectsList.push(project);
    }

    // Function to create a project for a company
    function createCompanyProject(uint64 company, string memory name, string memory description) public {
        require(msg.sender == companiesMap[company].owner);
        require(bytes(name).length > 0);
        require(bytes(description).length > 0);

        projectCounter++;
        Project memory project;
        project.id = projectCounter;
        project.name = name;
        project.description = description;
        project.balance = 0;
        project.companyOwner = company;
        projectsMap[projectCounter] = project;
        companiesMap[company].projects.push(projectCounter);
        projectsList.push(project);
    }


    // --- Bounties managment functions

    // Function to get a single bounty
    // function getBounty(uint64 id) public view returns (Bounty memory) {
    //     return bountiesMap[id];
    // }

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
        uint256 startIndex = bountiesList.length - (offset * 10);
        int256 tmp = int256(startIndex) - 10;
        if(tmp < 0) tmp = 0;
        uint256 endIndex = uint256(tmp);

        for(uint256 i = startIndex ; i > endIndex ; i--) {
            res[ptr] = bountiesList[(i-1)];
            ptr++;
        }

        return res;
    }

}