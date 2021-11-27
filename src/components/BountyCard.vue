<template>
  <div class="card hoverable company-card small" @click="openDetails">
    <div class="card-content white-text">
      <span class="card-title">{{ bounty.name }}</span>
      <p>Reward : {{ bounty.reward }} ETH</p>
      <p>{{ bounty.description }}</p>
    </div>
  </div>
</template>


<script lang="ts">
import { Bounty } from '@/types'

import { defineComponent } from '@vue/runtime-core'

export default defineComponent({
  name: 'BountyCard',

  props: {
    bounty: Bounty,
  },

  methods: {
    openDetails() {
      if(this.bounty != null) {
        this.$router.push({ name: "Bounties", query: {id: this.bounty.id} })
      }
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
  height: 230px;
}
</style>