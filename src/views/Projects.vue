<template>
  <project-details v-if="projectId != undefined && projectId != ''" :id="projectId" />

  <div v-else class="container">
    
    <div class="row">
      <div class="col s12">
        <h3 class="grey-text text-darken-3 center-align">
          Projects
        </h3>
      </div>
    </div>

    <div class="row">
      <div class="col s12">
        <h4 class="grey-text text-darken-3 center-align">
          Your projects
        </h4>
      </div>
    </div>

    <div class="row">
      <div class="col s12" v-if="projects.length == 0">
        <p class="center-align grey-text">You don't have any project for now... <b>You can create one by clicking <a class="modal-trigger" href="#project-creation">here</a> :)</b></p>
      </div>

      <div class="col s12 m4 l3 project-card-cont" v-else v-for="project of projectsObj" :key="project.id">
        <project-card :project="project" />
      </div>
    </div>

    <div v-if="lastProjectsObj.length > 0">
      <div class="row">
        <div class="col s12">
          <h4 class="grey-text text-darken-3 center-align">
            Last added projects
          </h4>
        </div>
      </div>

      <div class="row">
        <div class="col s12 m4 l3 project-card-cont" v-for="project of lastProjectsObj" :key="project.id">
          <project-card :project="project" />
        </div>
      </div>
    </div>

    <div id="project-creation" class="modal">
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

    <div class="fixed-action-btn">
      <a class="btn-floating btn-large modal-trigger tooltipped" data-position="left" data-tooltip="Create a project" href="#project-creation">
        <i class="large material-icons">add</i>
      </a>
    </div>

  </div>
</template>


<script lang="ts">
import ProjectCard from '@/components/ProjectCard.vue'
import ProjectDetails from '@/components/ProjectDetails.vue'
import { Project } from '@/types'

import { computed, defineComponent } from '@vue/runtime-core'
import { useStore } from 'vuex'
import M from 'materialize-css'

export default defineComponent({
  // ===== Component standard definition =====

  name: 'Projects',

  components: { ProjectDetails, ProjectCard },

  setup() {
    const store = useStore()
    const projects = computed(() => store.state.user.projects)
    const contract = computed(() => store.state.contract)
    const address = computed(() => store.state.account.address)
    return { store, projects, contract, address }
  },

  data() {
    const projectId = this.$route.query.id
    const projectName = ''
    const projectDescription = ''
    const projectsObj: Project[] = []
    const lastProjectsObj: Project[] = []
    const lastOffset = 0
    return { projectId, projectName, projectDescription, projectsObj, lastProjectsObj, lastOffset }
  },

  mounted() {
    M.Modal.init(document.querySelectorAll(".modal"))
    this.updateUser().then(() => {this.updateProjects(); this.updateLastProjects()})
  },

  updated() {
    document.querySelectorAll(".material-tooltip").forEach((e) => e.remove())
    M.Tooltip.init(document.querySelectorAll(".tooltipped"))
    this.projectId = this.$route.query.id
  },

  // ===== Methods =====

  methods: {

    // --- Display update methods

    /** Update the user display by fetching it in the smart contract */
    async updateUser() {
      const payload = await this.contract.methods.getUser(this.address).call()      
      this.store.commit('updateUser', payload)
    },

    /** Update the user project lists */
    async updateProjects() {
      this.projectsObj = await this.contract.methods.getProjects(this.projects).call()
    },

    /** Update the last 10 projects */
    async updateLastProjects() {
      const tmp: Project[] = await this.contract.methods.getLastProjects(this.lastOffset).call()
      this.lastProjectsObj = tmp.filter(({ id }) => id != '0')
    },

    // --- Contract call methods

    /** Create a project for the current user */
    async createProject() {
      if(this.projectName == '' || this.projectDescription == '') {
        M.toast({ html: 'Project name and descripion cannot be empty...' })
        return
      }

      this.contract.methods.
        createProject(this.projectName, this.projectDescription)
        .send()
        .then(() => {
          const modalElem = document.getElementById("project-creation")
          if(modalElem != null) M.Modal.getInstance(modalElem).close()
          this.updateUser().then(() => {this.updateProjects(); this.updateLastProjects()})
        })
        .catch((e: Error) => {
          console.error(e)
          M.toast({ html: 'Project creation failed...' })
        })

      this.projectName = ''
      this.projectDescription = ''
    }
  },
})
</script>