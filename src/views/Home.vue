<template>
  <register v-if="!store.state.user.name" />
  <home-content v-else />
</template>

<script>
import { defineComponent } from '@vue/runtime-core'
import Register from '@/components/Register.vue'
import HomeContent from '@/components/HomeContent.vue'
import { useStore } from 'vuex'

export default defineComponent({
  components: { Register, HomeContent },
  name: 'Home',

  setup() {
    const store = useStore()
    return { store }
  }
})
</script>
