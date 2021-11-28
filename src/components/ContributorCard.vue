<template>
  <div class="card hoverable small">
    <div class="card-content">
      <span class="card-title center-align">{{ user.name }} {{ isOwner ? '(Owner)' : '' }}</span>
    </div>
    <div v-if="removable && !isOwner" class="card-action">
      <a @click="removeContrib">Remove</a>
    </div>
  </div>
</template>


<script lang="ts">
import { User } from '@/types'

import { defineComponent } from '@vue/runtime-core'
import { computed } from 'vue'
import { useStore } from 'vuex'
import M from 'materialize-css'

export default defineComponent({
  name: 'ContributorCard',

  props: {
    user: User,
    projectId: String,
    removable: Boolean,
    isOwner: Boolean
  },

  setup() {
    const store = useStore()
    const contract = computed(() => store.state.contract)
    return { store, contract }
  },

  methods: {
    async removeContrib() {
      M.toast({html: 'TODO'})
    }
  },
})
</script>


<style lang="css" scoped>
.card {
  background-color: rgb(255, 255, 255) !important;
}

.card.small {
  height: 150px;
}

.card .card-title {
  color: rgba(0,0,0,0.87);
}

.card-action a {
  color: rgb(219, 133, 255) !important;
  cursor: pointer;
}

.card-action a:hover {
  color: rgba(219, 133, 255, 0.45) !important;
}
</style>