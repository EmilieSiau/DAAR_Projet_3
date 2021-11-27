<template>
  <div class="card hoverable company-card small" @click="openDetails">
    <div class="card-content white-text">
      <span class="card-title">{{ company.name }}</span>
      <p>Balance : {{ company.balance }} ETH</p>
      <p>{{ company.members.length + 1 }} members</p>
      <p>{{ company.projects.length }} open projects</p>
    </div>
  </div>
</template>


<script lang="ts">
import { Company } from '@/types'

import { defineComponent } from '@vue/runtime-core'
import { useStore } from 'vuex'

export default defineComponent({
  name: 'CompanyCard',

  props: {
    company: Company
  },

  setup() {
    const store = useStore()
    return { store }
  },

  methods: {
    openDetails() {
      if(this.company != null) {
        this.$router.push({ name: "Companies", query: {id: this.company.id} })
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