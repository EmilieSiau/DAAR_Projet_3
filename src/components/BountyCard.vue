<template>BOUNTY {{ bounty.name }} CARD</template>


<script lang="ts">
import { Bounty } from '@/types'

import { defineComponent } from '@vue/runtime-core'
import { useStore } from 'vuex'

export default defineComponent({
  name: 'BountyCard',

  props: {
    bounty: Bounty,
  },

  setup() {
    const store = useStore()
    return { store }
  },
})
</script>
