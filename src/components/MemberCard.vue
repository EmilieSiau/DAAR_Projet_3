<template>
  <div class="card company-card small">
    <div class="card-content white-text">
      <span class="card-title">{{ user.name }}</span>
    </div>
    <div v-if="removable" class="card-action">
      <a @click="removeMember">Fire</a>
    </div>
  </div>
</template>


<script lang="ts">
import { User } from '@/types'

import { defineComponent } from '@vue/runtime-core'
import { computed } from 'vue'
import { useStore } from 'vuex'

export default defineComponent({
  name: 'MemberCard',

  props: {
    user: User,
    companyId: String,
    removable: Boolean
  },

  setup() {
    const store = useStore()
    const contract = computed(() => store.state.contract)
    return { store, contract }
  },

  methods: {
    async removeMember() {
      console.log("TODO")
      this.$emit('removed')
    }
  },
})
</script>


<style lang="css" scoped>
.card {
  background-color: rgb(219, 133, 255) !important;
  cursor: pointer;
}

.card.small {
  height: 150px;
}

.card-action a {
  cursor: pointer;
  color: rgb(255, 255, 255) !important;
}

.card-action a:hover {
  color: rgba(255, 255, 255, 0.45) !important;
}
</style>