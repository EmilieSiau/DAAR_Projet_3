import { createRouter, createWebHistory, RouteRecordRaw } from 'vue-router'
import store from '@/store'
import LogIn from '@/views/LogIn.vue'
import Home from '@/views/Home.vue'
import Projects from '@/views/Projects.vue'
import Companies from '@/views/Companies.vue'
import Bounties from '@/views/Bounties.vue'

const routes: Array<RouteRecordRaw> = [
  {
    path: '/',
    name: 'LogIn',
    component: LogIn,
  },
  {
    path: '/home',
    name: 'Home',
    component: Home,
  },
  {
    path: '/projects',
    name: 'Projects',
    component: Projects,
  },
  {
    path: '/bounties',
    name: 'Bounties',
    component: Bounties,
  },
  {
    path: '/companies',
    name: 'Companies',
    component: Companies,
  },
]

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes,
})

router.beforeEach((to, _from, next) => {  
  if (to.name !== 'LogIn' && !store.state.account.address) {
    next({ name: 'LogIn' })
  } else if(to.name === 'LogIn' && store.state.account.address) {
    next({ name: 'Home' })
  } else {
    next()
  }
})

router.afterEach((to, from, fail) => {
  if(!fail) {    
    const navTo = document.getElementById(to.name?.toString() + "-nav")
    const navFrom = document.getElementById(from.name?.toString() + "-nav")
    if(navTo) {
      navTo.classList.add("active")
    }
    if(navFrom) {
      navFrom.classList.remove("active")
    }
  }
})

export default router
