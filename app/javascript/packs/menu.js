import Vue from 'vue/dist/vue.esm'
import VueResource from 'vue-resource'
import Element from 'element-ui'
import './element-variables.scss'
import errorHandlers from '../mixin/errorHandlers'

import MenuDisplay from '../parts/menu-display.vue'

Vue.mixin(errorHandlers);
Vue.use(VueResource);
Vue.use(Element);

document.addEventListener('DOMContentLoaded', () => {
  const app = new Vue({
    props: ['menu-id', 'lang'],
    mixins: [errorHandlers],
    el: '#menu',
    data: {},
    components: {
      MenuDisplay
    }
  })
})
