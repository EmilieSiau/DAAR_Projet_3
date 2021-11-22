<template>
    <div>COMPANIES</div>
</template>

<script>
import { defineComponent } from '@vue/runtime-core'
import { useStore } from 'vuex'

export default defineComponent({
    name: 'Companies',

    setup() {
        const store = useStore()
        return { store }
    },
})
</script>