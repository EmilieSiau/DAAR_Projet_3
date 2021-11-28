<template>
  <div class="container">

    <div class="row">
      <div class="col s12">
        <h3 class="grey-text text-darken-3 center-align">
          {{ project.name }}
        </h3>
      </div>
    </div>

    <div class="row">
      <div class="col s12">
        <p class="center-align grey-text text-darken-1">{{ project.description }}</p>
      </div>
    </div>

    <div class="row">
      <div class="col s12">
        <ul class="collapsible z-depth-0">
          <li>
            <div class="collapsible-header">
              <i class="material-icons">account_balance_wallet</i>Balance :
              {{ project.balance }} ETH
            </div>
          </li>

          <li>
            <div class="collapsible-header">
              <i class="material-icons">arrow_downward</i>Give money
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
        </ul>
      </div>
    </div>

    <div class="row">
      <div class="col s12">
        <h4 class="grey-text text-darken-3 center-align">Contributors</h4>
      </div>
    </div>

    <div class="row">
      <div
        class="col s12 m4 l3"
        v-for="contrib of contributorsObj"
        :key="contrib.addr"
      >
        <contributor-card class="member"
          :user="contrib"
          :isOwner="contrib.addr.toUpperCase() == project.userOwner.toUpperCase()"
          :removable="address.toUpperCase() == project.userOwner.toUpperCase()"
          :projectId="id"
          @removed="updateProject().then(updateContributors)"
        />
      </div>

      <div class="col s12 m4 l3" v-if="address.toUpperCase() == project.userOwner.toUpperCase()">
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
          href="#contrib-add"
        >
          <div class="card-content grey-text" style="flex-grow: 2">
            <i class="large material-icons">add</i>
          </div>
        </div>
      </div>
    </div>

  </div>

  <div id="contrib-add" class="modal">
    <div class="modal-content">
      <h4>Add a contributor to the project</h4>
      <div class="input-field" style="margin-top: 2rem">
        <input id="contrib-addr" type="text" v-model="newContribAddr" />
        <label for="contrib-addr">Address</label>
      </div>
    </div>
    <div class="modal-footer">
      <a href="#!" class="waves-effect waves-green btn-flat" @click="addContrib"
        >Add</a
      >
      <a href="#!" class="modal-close waves-effect waves-red btn-flat"
        >Cancel</a
      >
    </div>
  </div>

</template>


<script lang="ts">
import { Project, User } from '@/types'
import ContributorCard from '@/components/ContributorCard.vue'

import { computed, defineComponent } from 'vue'
import { useStore } from 'vuex'
import M from 'materialize-css'

export default defineComponent({
  // ===== Component standard definition =====

  name: 'ProjectDetails',

  props: {
    id: String,
  },

  components: { ContributorCard },

  setup() {
    const store = useStore()
    const contract = computed(() => store.state.contract)
    const address = computed(() => store.state.account.address)
    return { store, contract, address }
  },

  data() {
    const project: Project = new Project()
    const deposit = ''
    const newContribAddr = ''
    const contributorsObj: User[] = []
    return { project, deposit, newContribAddr, contributorsObj }
  },

  mounted() {
    M.Modal.init(document.querySelectorAll('.modal'))
    this.updateProject().then(() => {this.updateContributors()})
  },

  updated() {
    M.Tooltip.init(document.querySelectorAll(".tooltipped"))
    M.Collapsible.init(document.querySelectorAll('.collapsible'))
  },

  // ===== Methods =====

  methods: {
    // --- Display update methods

    /** Update the detailed project by fetching info from the smart contract */
    async updateProject() {
      this.project = await this.contract.methods.getProject(this.id).call()
    },

    /** Update the contributors list */
    async updateContributors() {
      this.contributorsObj = await this.contract.methods.getUsers(this.project.contributors).call()      
    },

    /** Add a member to the company */
    async addContrib() {
      if(!this.newContribAddr.match(new RegExp(/^0x[\dA-Fa-f]{40}$/))) {
        M.toast({ html: 'Input a valid address...' })
        return
      }

      this.contract.methods
        .addContrib(this.project.id, this.newContribAddr.toLowerCase())
        .send()
        .then(() => {
          const modalElem = document.getElementById("contrib-add")
          if(modalElem != null) M.Modal.getInstance(modalElem).close()
          this.updateProject().then(this.updateContributors)
        })
        .catch((e: Error) => {
          console.error(e)
          M.toast({ html: 'Member adding failed...' })
        })
      this.newContribAddr = ''
    },
  }

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