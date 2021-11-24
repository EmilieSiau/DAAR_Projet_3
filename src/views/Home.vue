<template>
  <register v-if="!store.state.user.name" />

  <div class="container" v-else>
    <div class="col s12">
      <h3 class="grey-text text-darken-3 center-align">
        Welcome (back) {{ name }} !
      </h3>
    </div>

    <div id="account-container" class="col s12">
      <ul class="collapsible z-depth-0">
        <li>
          <div class="collapsible-header">
            <i class="material-icons">account_balance_wallet</i>Balance :
            {{ balance }} ETH
          </div>
        </li>

        <li>
          <div class="collapsible-header">
            <i class="material-icons">arrow_downward</i>Deposit
          </div>
          <div class="collapsible-body">
            <div class="input-field">
              <input
                id="deposit"
                type="text"
                v-model="deposit"
                v-on:keyup.enter="sendDeposit"
              />
              <label for="deposit">Value</label>
            </div>
          </div>
        </li>

        <li>
          <div class="collapsible-header">
            <i class="material-icons">arrow_upward</i>Withdraw
          </div>
          <div class="collapsible-body">
            <div class="input-field">
              <input
                id="withdraw"
                type="text"
                v-model="withdraw"
                v-on:keyup.enter="sendWithdraw"
              />
              <label for="withdraw">Value</label>
            </div>
          </div>
        </li>

        <li>
          <div class="collapsible-header">
            <i class="material-icons">person</i>Username : {{ name }}
          </div>
          <div class="collapsible-body">
            <div class="input-field">
              <input
                id="username"
                type="text"
                v-model="newName"
                v-on:keyup.enter="sendNewName"
              />
              <label for="username">New username</label>
            </div>
          </div>
        </li>
      </ul>
    </div>

    <div
      id="saved-bounties"
      v-if="savedBountiesObj != null && savedBountiesObj.length > 0"
    >
      <div class="row">
        <div class="col s12">
          <h4 class="grey-text text-darken-3 center-align">
            Your saved bounties
          </h4>
        </div>
      </div>

      <div class="row">
        <div class="col s12">
          <div v-for="bounty of savedBountiesObj" :key="bounty.id">
            <bounty-card :bounty="bounty" />
          </div>
        </div>
      </div>
    </div>

    <div
      id="opened-bounties"
      v-if="openedBountiesObj != null && openedBountiesObj.length > 0"
    >
      <div class="row">
        <div class="col s12">
          <h4 class="grey-text text-darken-3 center-align">
            Your opened bounties
          </h4>
        </div>
      </div>

      <div class="row">
        <div class="col s12">
          <div v-for="bounty of openedBountiesObj" :key="bounty.id">
            <bounty-card :bounty="bounty" />
          </div>
        </div>
      </div>
    </div>

    <div id="last-bounties" class="row">
      <div class="col s12">
        <h4 class="grey-text text-darken-3 center-align">
          Last opened bounties
        </h4>
      </div>
    </div>

    <div class="row">
      <div class="col s12">
        <div v-if="lastBountiesObj.length == 0">
          <p class="center-align grey-text">No bounty for now...</p>
        </div>

        <div v-else>
          <div v-for="bounty of lastBountiesObj" :key="bounty.id">
            <bounty-card :bounty="bounty" />
          </div>
        </div>
      </div>
    </div>
  </div>
</template>


<script lang="ts">
import BountyCard from '@/components/BountyCard.vue'
import Register from '@/components/Register.vue'
import { Bounty } from '@/types'

import { computed, defineComponent } from '@vue/runtime-core'
import { useStore } from 'vuex'
import M from 'materialize-css'
import Web3 from 'web3'

export default defineComponent({
  // ===== Component standard definition =====

  name: 'Home',

  components: { Register, BountyCard },

  setup() {
    const store = useStore()
    const name = computed(() => store.state.user.name)
    const balance = computed(() => Web3.utils.fromWei(store.state.user.balance))
    const openedBounties = computed(() => store.state.user.openedBounties)
    const savedBounties = computed(() => store.state.user.savedBounties)
    const contract = computed(() => store.state.contract)
    const address = computed(() => store.state.account.address)
    return {
      store,
      name,
      balance,
      openedBounties,
      savedBounties,
      contract,
      address,
    }
  },

  data() {
    const deposit = ''
    const withdraw = ''
    const newName = ''
    const openedBountiesObj: Bounty[] = []
    const savedBountiesObj: Bounty[] = []
    const lastBountiesObj: Bounty[] = []
    const lastOffset = 0
    return {
      deposit,
      withdraw,
      newName,
      openedBountiesObj,
      savedBountiesObj,
      lastBountiesObj,
      lastOffset,
    }
  },

  mounted() {
    this.updateUser()
    this.fetchBounties()
  },

  updated() {
    M.Collapsible.init(document.querySelectorAll(".collapsible"))
  },

  // ===== Methods =====

  methods: {
    // --- Display update methods

    /** Update the user display by fetching it in the smart contract */
    async updateUser() {
      const payload = await this.contract.methods.getUser(this.address).call()
      this.store.commit('updateUser', payload)
    },

    /** Fetch the bounties and update the display */
    async fetchBounties() {
      this.openedBountiesObj = await this.contract.methods
        .getBounties(this.openedBounties)
        .call()
      this.savedBountiesObj = await this.contract.methods
        .getBounties(this.savedBounties)
        .call()
      const tmp: Bounty[] = await this.contract.methods
        .getLastBounties(this.lastOffset++)
        .call()
      this.lastBountiesObj = tmp.filter(({ id }) => id != '0')
    },

    // --- Constract call methods

    /** Send the deposit order to the smart contract and update the display */
    async sendDeposit() {
      const depositValue = Web3.utils.toWei(this.deposit, 'ether')
      if (!depositValue) {
        M.toast({ html: 'Deposit value must be a strictly positive number...' })
        return
      }

      this.contract.methods
        .deposit()
        .send({ value: depositValue })
        .then(this.updateUser)
        .catch((e: Error) => {
          console.error(e)
          M.toast({ html: 'Depositing failed...' })
        })

      this.deposit = ''
    },

    /** Send the withdraw order to the smart contract and update the display */
    async sendWithdraw() {
      const withdrawValue = Web3.utils.toWei(this.withdraw, 'ether')
      if (!withdrawValue) {
        M.toast({
          html: 'Withdraw value must be a strictly positive number...',
        })
        return
      }

      this.contract.methods
        .withdraw(withdrawValue)
        .send()
        .then(this.updateUser)
        .catch((e: Error) => {
          console.error(e)
          M.toast({ html: 'Withdrawing failed...' })
        })

      this.withdraw = ''
    },

    /** Send the new user name from the form to the smart contract and update the display */
    async sendNewName() {
      if (this.newName == '') {
        M.toast({ html: 'Username cannot be empty...' })
        return
      }

      this.contract.methods
        .updateUser(this.newName)
        .send()
        .then(this.updateUser)
        .catch((e: Error) => {
          console.error(e)
          M.toast({ html: 'Name updating failed...' })
        })

      this.newName = ''
    },
  },
})
</script>


<style lang="css" scoped>
h3 {
  margin-top: 3.5rem;
}

#account-container {
  margin-bottom: 3rem;
}
</style>
