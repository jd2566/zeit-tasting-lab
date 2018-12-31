import Vue from 'vue/dist/vue.esm'
import VueResource from 'vue-resource'
import Element from 'element-ui'
import './element-variables.scss'
import errorHandlers from '../mixin/errorHandlers'
import VueRouter from 'vue-router'

import MenuDisplay from '../parts/menu-display.vue'

Vue.mixin(errorHandlers);
Vue.use(VueResource);
Vue.use(Element);
Vue.use(VueRouter);

const router = new VueRouter({
  mode: 'history',
  routes: []
});

document.addEventListener('DOMContentLoaded', () => {
  const app = new Vue({
    mixins: [errorHandlers],
    data: {},
    router,
    render: h => h(MenuDisplay)
  }).$mount('menu')
})
