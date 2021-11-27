<template>
  <div class="card hoverable company-card small" @click="openDetails">
    <div class="card-content white-text">
      <span class="card-title">{{ project.name }}</span>
      <p>{{ project.description }}</p>
    </div>
  </div>
</template>


<script lang="ts">
import { Project } from '@/types'

import { defineComponent } from '@vue/runtime-core'

export default defineComponent({
  name: 'ProjectCard',

  props: {
    project: Project,
  },

  methods: {
    openDetails() {
      if (this.project != null) {
        this.$router.push({ name: 'Projects', query: { id: this.project.id } })
      }
    },
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
