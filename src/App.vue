<template>
  <nav id="navbar" class="navbar gradient-bg">
    <div class="nav-wrapper">
    <router-link to="/home" class="brand-logo">
        Open Collective
    </router-link>

    <ul id="nav-mobile" class="right hide-on-med-and-down" v-if="store.state.account.address">
        <li id="Home-nav"><router-link to="/home">Home</router-link></li>
        <li id="Projects-nav" v-if="store.state.user.name"><router-link to="/projects">Projects</router-link></li>
        <li id="Companies-nav" v-if="store.state.user.name"><router-link to="/companies">Companies</router-link></li>
        <li id="Bounties-nav" v-if="store.state.user.name"><router-link to="/bounties">Bounties</router-link></li>
        <li id="disconnect-nav"><a @click="disconnect">Disconnect</a></li>
    </ul>
    </div>
  </nav>
  <router-view />
</template>

<script lang="ts">
import { defineComponent } from 'vue'
import { useStore } from 'vuex'

export default defineComponent({
  name: 'App',
  setup() {
    const store = useStore()
    return { store }
  },

  methods: {
    async disconnect() {
      this.store.dispatch('ethereumDisconnect').then(
        () => this.$router.push({ name: "LogIn" })
      )
    },
  },
})
</script>

<style lang="css">
#disconnect-nav {
  margin-left: 1.5rem;
}

.brand-logo {
  margin-left: 0.5rem;
}

.gradient-bg {
  background: rgb(195, 50, 255);
  background: linear-gradient(34deg, rgb(195, 50, 255) 0%, rgba(8,208,214,1) 100%);
}

.fixed-action-btn .btn-floating {
  background-color: rgb(219, 133, 255) !important;
}

.input-field input {
  border-bottom: 1px solid #757575 !important;
  box-shadow: 0 0px 0 0 #757575 !important;
  color: #757575;
}

.input-field input:focus {
  border-bottom: 1px solid #757575 !important;
  box-shadow: 0 0px 0 0 #757575 !important;
  color: #757575;
}

.input-field label {
  color: #b3b3b3 !important;
}

.input-field input:focus + label {
  color: #757575 !important;
}

.input-field .prefix {
  color: #757575 !important;
}

.input-field .prefix.active {
  color: #757575 !important;
}

.card-action a {
  color: rgb(219, 133, 255) !important;
}

.card-action a:hover {
  color: rgba(219, 133, 255, 0.45) !important;
}
</style>
