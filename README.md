# OpenCollective

Authors : Emilie SIAU and Hugo GUERRIER \
Lisence : MIT\

# Installation

You’ll need to install dependencies. You’ll need [`Ganache`](https://www.trufflesuite.com/ganache), [`Node.js`](https://nodejs.org/en/) and [`NPM`](https://www.npmjs.com/) or [`Yarn`](https://yarnpkg.com/). You’ll need to install [`Metamask`](https://metamask.io/) as well to communicate with your blockchain.

- `Ganache` is a local blockchain development, to iterate quickly and avoiding wasting Ether during development.
- `Node.js` is used to build the frontend and running `truffle`, which is a utility to deploy contracts.
- `NPM` or `Yarn` is a package manager, to install dependencies for your frontend development. Yarn is recommended.
- `Metamask` is a in-browser utility to interact with decentralized applications.

# Some setup

Once everything is installed, launch `Ganache`. Create a new workspace, give it a name, and accept. You should have a local blockchain running in local. Now you can copy the mnemonic phrase Ganache generated, open Metamask, and when it asks to import a mnemonic, paste the mnemonic. Create the password of your choice and that’s fine.
Now you can connect Metamask to the blockchain. To do this, add a network by clicking on `main network` and `personalized RPC`. Here, you should be able to add a network.

![Ganache Config](public/ganache-config.png)

Once you have done it, you’re connected to the Ganache blockchain!

# Run the frontend

Install the dependencies.

```bash
# Yarn users
yarn
# NPM users
npm install
```

Compile the contracts.

```bash
# Yarn users
yarn contracts:migrate
# NPM users
npm run contracts:migrate
```

Create a symlink for your OS if this is not done for you.

```bash
# Windows
mklink /D src\build "..\build"

# Unix and macOS
ln -s ../build ./src/build
```

Run the frontend

```bash
# Yarn users
yarn serve
# NPM users
npm run serve
```

You’re good to go!

# What is persent

- User account creation
- User deposit and withdraw
- Company account creation
- Company members management
- User project creation
- Company project creation
- Project contributors management

# What is missing

- The bounties system
- Project git syncing
- Project payment to contibutors
