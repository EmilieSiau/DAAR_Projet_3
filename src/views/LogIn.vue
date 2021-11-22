<template>
  <div id="user-login" class="valign-wrapper gradient-bg">
    <div id="connect-form">
      <h1 class="center-align white-text">Welcome to Open Collective</h1>
      <h4 class="center-align white-text">Build the future togEther</h4>
      <div class="center-align">
        <a class="waves-effect waves-light btn-flat white-text" @click="connect">Connect</a>
      </div>
      <p id="error-message" class="center-allign" v-if="errorMessage != ''">
        {{ errorMessage }}
      </p>
    </div>
  </div>
</template>

<script lang="ts">
import { computed, defineComponent } from '@vue/runtime-core'
import { useStore } from 'vuex'

export default defineComponent({
  name: 'LogIn',

  setup() {
    const store = useStore()
    const navbar = computed(() => document.getElementById("navbar"))
    const address = computed(() => store.state.account.address)
    return { address, store, navbar }
  },

  data() {
    const errorMessage = ""
    return { errorMessage }
  },

  async mounted() {
    if(this.navbar) this.navbar.style.display = "none"
  },

  methods : {
    async connect() {
      this.store.dispatch("ethereumConnect").then(
        () => {
          if(this.navbar) this.navbar.style.display = ""
          this.$router.push({ name: 'Home' })
        }
      ).catch(
        () => this.errorMessage = "Cannot connect to the user account"
      )
    },
  }
})
</script>

<style lang="css" scoped>
#user-login {
  height: 100vh;
}

h4 {
  margin-bottom: 4.5rem !important;
}

#connect-form {
  width: 100vw;
}
</style>