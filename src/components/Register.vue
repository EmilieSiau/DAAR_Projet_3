<template>
  <div class="container">
    <div class="row">
      <div class="col s12 l4 offset-l4">
        <div class="card white z-depth-2">
          <div class="card-content">

            <span class="card-title grey-text text-darken-1">Not registered</span>
            <p class="grey-text text-darken-1">
              It seems you're not registered in Open Collective. To use our service, please register by inputing a user name bellow.
            </p>

            <div class="input-field">
              <input id="username" type="text" v-model="username" v-on:keyup.enter="register">
              <label for="username">Username</label>
            </div>

          </div>

          <div class="card-action">
            <a href="#" @click="register">Register</a>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import { computed, defineComponent } from '@vue/runtime-core'
import { useStore } from 'vuex'
import M from 'materialize-css'

export default defineComponent({
  name: 'Register',

  setup() {
    const store = useStore()
    const contract = computed(() => store.state.contract)
    const address = computed(() => store.state.account.address)
    return { store, contract, address }
  },

  data() {
    const username = ''
    return { username }
  },

  mounted() {
    this.updateUser()
  },

  methods: {
    async updateUser() {
      const payload = await this.contract.methods.getUser(this.address).call()
      this.store.commit('updateUser', payload)
    },

    async register() {
      if(this.username == '') {
        M.toast({html: 'Username cannot be empty...'})
        return
      }

      this.contract.methods.registerUser(this.username).send().then(this.updateUser)
        .catch((e: Error) => {
          console.error(e);
          M.toast({html: 'Registration failed...'})
        });
    },
  },
})
</script>

<style lang="css" scoped>
.card {
  margin-top: 2rem;
}

.input-field {
  margin-top: 1.7rem;
  margin-bottom: 0rem;
}

.card-action a {
  color: rgb(219, 133, 255) !important;
}

.card-action a:hover {
  color: rgba(219, 133, 255, 0.45) !important;
}
</style>