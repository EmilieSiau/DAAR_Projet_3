export class User {
    name: string
    balance: string
    projects: string[]
    ownedCompanies: string[]
    belongedCompanies: string[]
    openedBounties: string[]
    savedBounties: string[]

    constructor() {
        this.name = ''
        this.balance = ''
        this.projects = []
        this.ownedCompanies = []
        this.belongedCompanies = []
        this.openedBounties = []
        this.savedBounties = []
    }
}

export class Company {
    id: string
    name: string
    balance: string
    owner: string
    members: string[]
    projects: string[]

    constructor() {
        this.id = ''
        this.name = ''
        this.balance = ''
        this.owner = ''
        this.members = []
        this.projects = []
    }
}

export class Bounty {
    id: string
    creator: string
    name: string
    description: string
    project: string
    reward: string

    constructor() {
        this.id = ''
        this.creator = ''
        this.name = ''
        this.description = ''
        this.project = ''
        this.reward = ''
    }
}

export class Project {
    id: string
    name: string
    description: string
    balance: string
    userOwner: string
    companyOwner: string
    contributors: string[]
    bounties: string[]

    constructor() {
        this.id = ''
        this.name = ''
        this.description = ''
        this.balance = ''
        this.userOwner = ''
        this.companyOwner = ''
        this.contributors = []
        this.bounties = []
    }
}
