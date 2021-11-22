<template>
    <div>BOUNTIES</div>
</template>

<script>
import { defineComponent } from '@vue/runtime-core'
import { useStore } from 'vuex'

export default defineComponent({
    name: 'Bounties',

    setup() {
        const store = useStore()
        return { store }
    },
})
</script>
