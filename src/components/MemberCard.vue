<template>
  <div class="card hoverable small">
    <div class="card-content">
      <span class="card-title center-align">{{ user.name }} {{ isOwner ? '(Owner)' : '' }}</span>
    </div>
    <div v-if="removable && !isOwner" class="card-action">
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
    removable: Boolean,
    isOwner: Boolean
  },

  setup() {
    const store = useStore()
    const contract = computed(() => store.state.contract)
    return { store, contract }
  },

  methods: {
    async removeMember() {
      await this.contract.methods.removeMember(this.companyId, this.user?.addr).send()
      this.$emit('removed')
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