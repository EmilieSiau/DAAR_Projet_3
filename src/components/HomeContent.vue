<template>
  <div class="container">

    <div class="col s12">
      <h3 class="grey-text text-darken-3 center-align">
        Welcome (back) {{ name }} !
      </h3>
    </div>

    <div id="test" class="col s12">

      <ul class="collapsible z-depth-0">

        <li>
          <div class="collapsible-header">
            <i class="material-icons">account_balance_wallet</i>Balance : {{ balance }} ETH
          </div>
        </li>

        <li>
          <div class="collapsible-header"><i class="material-icons">arrow_downward</i>Deposit</div>
          <div class="collapsible-body">
            <div class="input-field">
              <input id="deposit" type="text" v-model="deposit" v-on:keyup.enter="sendDeposit">
              <label for="deposit">Value</label>
            </div>
          </div>
        </li>

        <li>
          <div class="collapsible-header"><i class="material-icons">arrow_upward</i>Withdraw</div>
          <div class="collapsible-body">
            <div class="input-field">
              <input id="withdraw" type="text" v-model="withdraw" v-on:keyup.enter="sendWithdraw">
              <label for="withdraw">Value</label>
            </div>
          </div>
        </li>

        <li>
          <div class="collapsible-header"><i class="material-icons">person</i>Username : {{ name }}</div>
          <div class="collapsible-body">
            <div class="input-field">
              <input id="username" type="text" v-model="newName" v-on:keyup.enter="sendNewName">
              <label for="username">New username</label>
            </div>
          </div>
        </li>

      </ul>

    </div>



  </div>
</template>

<script lang="ts">
import { computed, defineComponent } from '@vue/runtime-core'
import { useStore } from 'vuex'
import M from 'materialize-css'
import Web3 from 'web3'

export default defineComponent({
  name: 'HomeContent',

  setup() {
    const store = useStore()
    const name = computed(() => store.state.user.name)
    const balance = computed(() => Web3.utils.fromWei(store.state.user.balance))
    const openedBounties = computed(() => store.state.user.openedBounties)
    const savedBounties = computed(() => store.state.user.savedBounties)
    const contract = computed(() => store.state.contract)
    const address = computed(() => store.state.account.address)
    return { store, name, balance, openedBounties, savedBounties, contract, address }
  },

  data() {
    const deposit = ''
    const withdraw = ''
    const newName = ''
    const openedBountiesObj = null
    const savedBountiesObj = null
    const lastBountiesObj = null
    const lastOffset = 0
    return { deposit, withdraw, newName, openedBountiesObj, savedBountiesObj, lastBountiesObj, lastOffset }
  },

  mounted() {    
    this.updateUser()
    this.fetchBounties()
    M.Collapsible.init(document.querySelectorAll(".collapsible"))
  },

  methods: {
    async updateUser() {
      const payload = await this.contract.methods.getUser(this.address).call()
      this.store.commit('updateUser', payload)
    },

    async fetchBounties() {
      this.openedBountiesObj = await this.contract.methods.getBounties(this.openedBounties).call()
      this.savedBountiesObj = await this.contract.methods.getBounties(this.savedBounties).call()
      this.lastBountiesObj = await this.contract.methods.getLastBounties(this.lastOffset++).call()
      console.log(this.openedBountiesObj)
      console.log(this.savedBountiesObj)
      console.log(this.lastBountiesObj)
    },

    async sendDeposit() {
      const depositValue = Web3.utils.toWei(this.deposit, 'ether')
      if(!depositValue) {
        M.toast({html: 'Deposit value must be a strictly positive number...'})
        return
      }

      this.contract.methods.deposit().send({value: depositValue}).then(this.updateUser)
        .catch((e: Error) => {
          console.error(e);
          M.toast({html: 'Depositing failed...'})
        });

      this.deposit = ''
    },

    async sendWithdraw() {
      const withdrawValue = Web3.utils.toWei(this.withdraw, 'ether')
      if(!withdrawValue) {
        M.toast({html: 'Withdraw value must be a strictly positive number...'})
        return
      }

      this.contract.methods.withdraw(withdrawValue).send().then(this.updateUser)
        .catch((e: Error) => {
          console.error(e);
          M.toast({html: 'Withdrawing failed...'})
        });

      this.withdraw = ''
    },

    async sendNewName() {
      if(this.newName == '') {
        M.toast({html: 'Username cannot be empty...'})
        return
      }

      this.contract.methods.updateUserName(this.newName).send().then(this.updateUser)
        .catch((e: Error) => {
          console.error(e);
          M.toast({html: 'Name updating failed...'})
        });

      this.newName = ''
    },
  }
})
</script>

<style lang="css" scoped>
h3 {
  margin-top: 3.5rem;
}
</style>