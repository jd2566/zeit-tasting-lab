import Vue from 'vue/dist/vue.esm'
import Materials from '../parts/materials.vue'
import Element from 'element-ui'
import './element-variables.scss'
import VueResource from 'vue-resource'

Vue.use(VueResource);
Vue.use(Element)

Vue.http.headers.common['Authorization'] = 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIxIiwic2NwIjoidXNlciIsImF1ZCI6bnVsbCwiaWF0IjoxNTI5MDQ5NDgyLCJleHAiOjE1MjkxMzU4ODIsImp0aSI6Ijg1MGNjOTI4LWIzODAtNDk3MC1hZGM4LTg5NGE4NzNlZTllMCJ9.UaOC72X6bmT1bxPScPlWdj16G4pmdEGSCtPFoCUF77o';

document.addEventListener('DOMContentLoaded', () => {
  const app = new Vue({
    el: '#materials',
    data: {},
    components: {
      Materials
    }
  })
})
