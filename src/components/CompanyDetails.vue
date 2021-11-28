<template>
  <div class="container">
    <div class="row">
      <div class="col s12">
        <h3 class="grey-text text-darken-3 center-align">
          {{ company.name }}
        </h3>
      </div>
    </div>

    <div class="row">
      <div class="col s12">
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
        </ul>
      </div>
    </div>

    <div class="row">
      <div class="col s12">
        <h4 class="grey-text text-darken-3 center-align">Members</h4>
      </div>
    </div>

    <div class="row">
      <div
        class="col s12 m4 l3"
        v-for="member of membersObj"
        :key="member.addr"
      >
        <member-card class="member"
          :user="member"
          :isOwner="member.addr.toUpperCase() == company.owner.toUpperCase()"
          :removable="address.toUpperCase() == company.owner.toUpperCase()"
          :companyId="id"
          @removed="updateCompany().then(updateMembers)"
        />
      </div>

      <div class="col s12 m4 l3" v-if="address.toUpperCase() == company.owner.toUpperCase()">
        <div
          id="add-member"
          class="
            member
            modal-trigger
            card
            waves-effect
            z-depth-0
            white
            small
            valign-wrapper
            center-align
          "
          href="#member-add"
        >
          <div class="card-content grey-text" style="flex-grow: 2">
            <i class="large material-icons">add</i>
          </div>
        </div>
      </div>
    </div>

    <div class="row">
      <div class="col s12">
        <h4 class="grey-text text-darken-3 center-align">Company's project</h4>
      </div>
    </div>

    <div class="row">
      <div class="col s12" v-if="company.projects.length == 0">
        <p class="center-align grey-text">
          This company doesn't have open project... 
          <b v-if="address.toUpperCase() == company.owner.toUpperCase()">
            You can create one by clicking
            <a class="modal-trigger" href="#cproject-creation">here</a> :)
          </b>
        </p>
      </div>

      <div
        class="col s12 m4 l3"
        v-else
        v-for="project of projectsObj"
        :key="project.id"
      >
        <project-card :project="project" />
      </div>
    </div>
  </div>

  <div id="cproject-creation" class="modal">
    <div class="modal-content">
      <h4>Create a project for the company</h4>
      <div class="input-field" style="margin-top: 2rem">
        <input id="proj-name" type="text" v-model="projectName" />
        <label for="proj-name">Project name</label>
      </div>
      <div class="input-field" style="margin-top: 2rem">
        <input id="proj-desc" type="text" v-model="projectDescription" />
        <label for="proj-desc">Project description</label>
      </div>
    </div>
    <div class="modal-footer">
      <a
        href="#!"
        class="waves-effect waves-green btn-flat"
        @click="createProject"
        >Create</a
      >
      <a href="#!" class="modal-close waves-effect waves-red btn-flat"
        >Cancel</a
      >
    </div>
  </div>

  <div id="member-add" class="modal">
    <div class="modal-content">
      <h4>Add a member to the company</h4>
      <div class="input-field" style="margin-top: 2rem">
        <input id="memAddr" type="text" v-model="newMemberAddr" />
        <label for="memAddr">Address</label>
      </div>
    </div>
    <div class="modal-footer">
      <a href="#!" class="waves-effect waves-green btn-flat" @click="addMember"
        >Add</a
      >
      <a href="#!" class="modal-close waves-effect waves-red btn-flat"
        >Cancel</a
      >
    </div>
  </div>

  <div class="fixed-action-btn" v-if="address.toUpperCase() == company.owner.toUpperCase()">
    <a
      class="btn-floating btn-large modal-trigger tooltipped"
      data-position="left"
      data-tooltip="Create a project"
      href="#cproject-creation"
    >
      <i class="large material-icons">add</i>
    </a>
  </div>
</template>


<script lang="ts">
import { Company, Project, User } from '@/types'
import MemberCard from '@/components/MemberCard.vue'
import ProjectCard from '@/components/ProjectCard.vue'

import { computed, defineComponent } from '@vue/runtime-core'
import { useStore } from 'vuex'
import M from 'materialize-css'

export default defineComponent({
  // ===== Component standard definition =====

  name: 'CompanyDetails',

  components: { MemberCard, ProjectCard },

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
    const projectsObj: Project[] = []
    const deposit = ''
    const withdraw = ''
    const projectName = ''
    const projectDescription = ''
    const newMemberAddr = ''
    return {
      company,
      membersObj,
      projectsObj,
      deposit,
      withdraw,
      projectName,
      projectDescription,
      newMemberAddr,
    }
  },

  mounted() {
    M.Modal.init(document.querySelectorAll('.modal'))
    this.updateCompany().then(() => {
      this.updateMembers()
      this.updateProjects()
    })
  },

  updated() {
    M.Tooltip.init(document.querySelectorAll(".tooltipped"))
    M.Collapsible.init(document.querySelectorAll('.collapsible'))
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
      this.membersObj = await this.contract.methods
        .getUsers(this.company.members)
        .call()
    },

    /** Update the projects list */
    async updateProjects() {
      this.projectsObj = await this.contract.methods
        .getProjects(this.company.projects)
        .call()
    },

    // --- Contract call methods

    /** Send a deposit on the company account */
    async sendDeposit() {
      M.toast({html: 'TODO'})
    },

    /** Withdraw money from the company account */
    async sendWithdraw() {
      M.toast({html: 'TODO'})
    },

    /** Create a project for the company */
    async createProject() {
      if(this.projectName == '' || this.projectDescription == '') {
        M.toast({ html: 'Project name and descripion cannot be empty...' })
        return
      }

      this.contract.methods.
        createCompanyProject(this.company.id, this.projectName, this.projectDescription)
        .send()
        .then(() => {
          const modalElem = document.getElementById("cproject-creation")
          if(modalElem != null) M.Modal.getInstance(modalElem).close()
          this.updateCompany().then(this.updateProjects)
        })
        .catch((e: Error) => {
          console.error(e)
          M.toast({ html: 'Project creation failed...' })
        })
  
      this.projectDescription = ''
      this.projectName = ''
    },

    /** Add a member to the company */
    async addMember() {
      if(!this.newMemberAddr.match(new RegExp(/^0x[\dA-Fa-f]{40}$/))) {
        M.toast({ html: 'Input a valid address...' })
        return
      }

      this.contract.methods
        .addMember(this.company.id, this.newMemberAddr.toLowerCase())
        .send()
        .then(() => {
          const modalElem = document.getElementById("member-add")
          if(modalElem != null) M.Modal.getInstance(modalElem).close()
          this.updateCompany().then(this.updateMembers)
        })
        .catch((e: Error) => {
          console.error(e)
          M.toast({ html: 'Member adding failed...' })
        })
      this.newMemberAddr = ''
    },
  },
})
</script>


<style lang="css" scoped>
.card.member {
  background-color: rgb(255, 255, 255) !important;
}

.card.member.small {
  height: 150px;
}

#add-member {
  cursor: pointer;
}
</style>