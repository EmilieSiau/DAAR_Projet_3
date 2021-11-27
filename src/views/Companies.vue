<template>
  <company-details
    v-if="companyId != undefined && companyId != ''"
    :id="companyId"
  ></company-details>

  <div class="container" v-else>
    <div class="row">
      <div class="col s12">
        <h3 class="grey-text text-darken-3 center-align">
          Companies
        </h3>
      </div>
    </div>

    <div class="row">
      <div class="col s12">
        <h4 class="grey-text text-darken-3 center-align">
          Your companies
        </h4>
      </div>
    </div>
    
    <div class="row">
      <div class="col s12" v-if="ownedCompaniesObj.length == 0">
        <p class="center-align grey-text">You don't own any company for now... You can create one by clicking <a class="modal-trigger" href="#company-creation">here</a> :)</p>
      </div>

      <div class="col s12 m4 l3 company-card-cont" v-else v-for="company of ownedCompaniesObj" :key="company.id">
        <company-card :company="company" />
      </div>
    </div>

    <div v-if="belongedCompaniesObj.length > 0">
      <div class="row">
        <div class="col s12">
          <h4 class="grey-text text-darken-3 center-align">
            Companies you work for
          </h4>
        </div>
      </div>

      <div class="row">
        <div v-for="company of belongedCompaniesObj" :key="company.id">
          <company-card :company="company" />
        </div>
      </div>
    </div>

    <div id="company-creation" class="modal">
      <div class="modal-content">
        <h4>Create your company !</h4>
        <div class="input-field" style="margin-top: 2rem;">
          <input
            id="name"
            type="text"
            v-model="name"
            v-on:keyup.enter="sendWithdraw"
          />
          <label for="name">Name</label>
        </div>
      </div>
      <div class="modal-footer">
        <a href="#!" class="waves-effect waves-green btn-flat" @click="reigsterCompany">Create</a>
        <a href="#!" class="modal-close waves-effect waves-red btn-flat">Cancel</a>
      </div>
    </div>
  </div>

  <div class="fixed-action-btn">
    <a class="btn-floating btn-large modal-trigger tooltipped" data-position="left" data-tooltip="Create a company" href="#company-creation">
      <i class="large material-icons">add</i>
    </a>
  </div>
</template>


<script lang="ts">
import CompanyDetails from '@/components/CompanyDetails.vue'
import CompanyCard from '@/components/CompanyCard.vue'
import { Company } from '@/types'

import { computed, defineComponent } from '@vue/runtime-core'
import { useStore } from 'vuex'
import M from 'materialize-css'

export default defineComponent({
  // ===== Component standard definition =====

  name: 'Companies',

  components: { CompanyDetails, CompanyCard },

  setup() {
    const store = useStore()
    const ownedCompanies = computed(() => store.state.user.ownedCompanies)
    const belongedCompanies = computed(() => store.state.user.belongedCompanies)
    const contract = computed(() => store.state.contract)
    const address = computed(() => store.state.account.address)    
    return { store, contract, address, ownedCompanies, belongedCompanies }
  },

  data() {
    const companyId = this.$route.query.id
    const name = ''
    const ownedCompaniesObj: Company[] = []
    const belongedCompaniesObj: Company[] = []
    return { companyId, name, ownedCompaniesObj, belongedCompaniesObj }
  },

  mounted() {
    M.Modal.init(document.querySelectorAll(".modal"))
    M.Tooltip.init(document.querySelectorAll(".tooltipped"))
    this.updateOwned()
    this.updateBelonged()
  },

  updated() {
    this.companyId = this.$route.query.id
  },

  // ===== Methods =====

  methods: {

    // --- Form methods

    // --- Display update methods

    /** Update the user display by fetching it in the smart contract */
    async updateUser() {
      const payload = await this.contract.methods.getUser(this.address).call()
      this.store.commit('updateUser', payload)
    },

    /** Methods to update the owned companies list */
    async updateOwned() {      
      this.ownedCompaniesObj = await this.contract.methods.getCompanies(this.ownedCompanies).call()
    },

    /** Methods to belonged the owned companies list */
    async updateBelonged() {
      this.belongedCompaniesObj = await this.contract.methods.getCompanies(this.belongedCompanies).call()
    },

    // --- Constract call methods

    /** Method do create a new company with the name */
    async reigsterCompany() {
      if (this.name == '') {
        M.toast({ html: 'Company name cannot be empty...' })
        return
      }

      this.contract.methods
        .registerCompany(this.name)
        .send()
        .then(() => {
          const modalElem = document.getElementById("company-creation")
          if(modalElem != null) M.Modal.getInstance(modalElem).close()
          this.updateUser().then(() => {this.updateOwned().then(this.$forceUpdate)})
        })
        .catch((e: Error) => {
          console.error(e)
          M.toast({ html: 'Company creation failed...' })
        })

      this.name = ''
    },

  }
})
</script>


<style lang="css" scoped>
.company-card {
  flex-grow: 0 !important;
  flex-shrink: 1 !important;
}
</style>