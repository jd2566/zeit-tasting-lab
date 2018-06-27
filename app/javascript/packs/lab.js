import Vue from 'vue/dist/vue.esm'
import Vuex from 'vuex'
import VueResource from 'vue-resource'
import VueRouter from 'vue-router'
import createPersistedState from "vuex-persistedstate";
import UserPanel from '../parts/user-panel.vue'
import MainMenu from '../parts/main-menu.vue'
import ItemSelector from '../parts/item-selector.vue'

import MenuEditor from '../parts/menu-editor.vue'

import Element from 'element-ui'
import './element-variables.scss'

import errorHandlers from '../mixin/errorHandlers'

Vue.mixin(errorHandlers);

Vue.use(Vuex);
Vue.use(VueResource);
Vue.use(VueRouter);
Vue.use(Element);

const routes = [{
    path: '/menu',
    component: MenuEditor
  }
]

const router = new VueRouter({
  routes // short for `routes: routes`
})

const store = new Vuex.Store({
  state: {
    user: {
      email: "",
      token: "",
      loggedIn: false
    },
    root: {
      id: "",
      name: ""
    },
    category: {
      id: "",
      name: ""
    }
  },
  mutations: {
    setUserData (state, payload) {
      state.user.email = payload.email;
      state.user.token = payload.token;
      state.user.loggedIn = payload.loggedIn;
    },
    login (state) {
      state.user.loggedIn = true;
    },
    logout (state) {
      state.user.loggedIn = false;
    },
    setRoot(state, payload) {
      state.root.id = payload.id;
      state.root.name = payload.name;
    },
    setCategory (state, payload) {
      state.category.id = payload.id;
      state.category.name = payload.name;
    }
  },
  getters: {
    isLoggedIn: state => {
      return state.user.loggedIn;
    },
    getToken: state => {
      return state.user.token;
    },
    getEmail: state => {
      return state.user.email;
    },
    getRoot: state => {
      return state.root;
    },
    getCategory: state => {
      return state.category;
    }
  },
  plugins: [createPersistedState()]
})

document.addEventListener('DOMContentLoaded', () => {
  const app = new Vue({
    mixins: [errorHandlers],
    el: '#lab',
    data: {},
    store,
    router,
    components: {
      MainMenu,
      UserPanel,
      ItemSelector
    }
  })
})
