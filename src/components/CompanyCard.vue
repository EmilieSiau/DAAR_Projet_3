<template>
  COMPANY {{ company.name }} CARD
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
})
</script>
