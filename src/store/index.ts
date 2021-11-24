import { createStore } from 'vuex'
import * as Ethereum from '../services/ethereum'

export default createStore({
  state: {
    contract: null,
    account: {
      address: null,
      balance: 0,
    },
    user: {
      name: null,
      balance: 0,
      projects: [],
      ownedCompanies: [],
      belongedCompanies: [],
      openedBounties: [],
      savedBounties: []
    },
  },

  mutations: {
    updateEthereum(state, { address, contract, balance }) {
      state.account.address = address
      state.account.balance = balance
      state.contract = contract
    },

    updateUser(state, { name, balance, projects, ownedCompanies, belongedCompanies, openedBounties, savedBounties }) {
      state.user.name = name
      state.user.balance = balance
      state.user.projects = projects
      state.user.ownedCompanies = ownedCompanies
      state.user.belongedCompanies = belongedCompanies
      state.user.openedBounties = openedBounties
      state.user.savedBounties = savedBounties
    },
  },

  actions: {

    async ethereumConnect(context) {
      const response = await Ethereum.connect()
      if (response) {
        const { address, contract, balance } = response
        context.commit('updateEthereum', { address, contract, balance })
      }
    },

    async ethereumDisconnect(context) {
      context.commit('updateEthereum', { address: null, contract: null, balance: 0 })
    },

  },
  modules: {},
})
