import Vue from 'vue/dist/vue.esm'
import Materials from '../parts/materials.vue'
import Element from 'element-ui'
import './element-variables.scss'
import VueResource from 'vue-resource'

Vue.use(VueResource);
Vue.use(Element)

document.addEventListener('DOMContentLoaded', () => {
  const app = new Vue({
    el: '#materials',
    data: {},
    components: {
      Materials
    }
  })
})
