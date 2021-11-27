<template>
  DETAILS {{ id }}
</template>


<script lang="ts">
import { Company } from '@/types'

import { computed, defineComponent } from '@vue/runtime-core'
import { useStore } from 'vuex'

export default defineComponent({
  // ===== Component standard definition =====

  name: 'CompanyDetails',

  props: {
    id: String,
  },

  setup() {
    const store = useStore()
    const contract = computed(() => store.state.contract)
    return { store, contract }
  },

  data() {
    const company: Company = new Company()
    return { company }
  },

  mounted() {
    this.updateCompany()
  },

  // ===== Methods =====

  methods: {
    // --- Display update methods

    /** Update the detailed company by fetching info from the smart contract */
    async updateCompany() {
      this.company = await this.contract.methods.getCompany(this.id).call()
    },
  },
})
</script>
