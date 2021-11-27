<template>
  
  <div class="container">
    <div class="row">
      <div class="col s12">
        <h3 class="grey-text text-darken-3 center-align">
          {{ company.name }} company page !
        </h3>
      </div>
    </div>

    <div class="row">
      <div id="company-details-container" class="col s12">
        <ul class="collapsible z-depth-0">
          <li>
            <div class="collapsible-header">
              <i class="material-icons">account_balance_wallet</i>Balance :
              {{ company.balance }} ETH
            </div>
          </li>

          <li v-if="address.toUpperCase() == company.owner.toUpperCase()">
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

          <li v-if="address.toUpperCase() == company.owner.toUpperCase()">
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

          <li v-if="address.toUpperCase() == company.owner.toUpperCase()">
            <div class="collapsible-header">
              <i class="material-icons">person</i>Company name : {{ company.name }}
            </div>
            <div class="collapsible-body">
              <div class="input-field">
                <input
                  id="name"
                  type="text"
                  v-model="newName"
                  v-on:keyup.enter="sendNewName"
                />
                <label for="name">New company name</label>
              </div>
            </div>
          </li>
        </ul>
      </div>
    </div>

    <div class="row">
      <div class="col s12">
        <h4 class="grey-text text-darken-3 center-align">
          Company members
        </h4>
      </div>
    </div>

    <div class="row">
      <div class="col s12 m4 l3" v-for="member of membersObj" :key="member.address">
        <member-card :user="member" :removable="true" :companyId="id" @removed="updateMembers" />
      </div>
    </div>
  </div>

</template>


<script lang="ts">
import { Company, User } from '@/types'
import MemberCard from '@/components/MemberCard.vue'

import { computed, defineComponent } from '@vue/runtime-core'
import { useStore } from 'vuex'
import M from 'materialize-css'

export default defineComponent({
  // ===== Component standard definition =====

  name: 'CompanyDetails',

  components: { MemberCard },

  props: {
    id: String,
  },

  setup() {
    const store = useStore()
    const contract = computed(() => store.state.contract)
    const address = computed(() => store.state.account.address)
    return { store, contract, address }
  },

  data() {
    const company: Company = new Company()
    const membersObj: User[] = []
    return { company, membersObj }
  },

  mounted() {
    this.updateCompany().then(this.updateMembers)
  },

  updated() {
    M.Collapsible.init(document.querySelectorAll(".collapsible"))
  },

  // ===== Methods =====

  methods: {
    // --- Display update methods

    /** Update the detailed company by fetching info from the smart contract */
    async updateCompany() {
      this.company = await this.contract.methods.getCompany(this.id).call()      
    },

    /** Update the member list */
    async updateMembers() {
      this.membersObj = await this.contract.methods.getUsers(this.company.members).call()
      console.log("MEMBERS UPDATED")
    },
  },
})
</script>
