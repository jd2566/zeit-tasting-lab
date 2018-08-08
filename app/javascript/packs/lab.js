import Vue from 'vue'
import Vuex from 'vuex'
import VueResource from 'vue-resource'
import VueRouter from 'vue-router'
import VueLodash from 'vue-lodash'
import createPersistedState from "vuex-persistedstate";
import VueCookie from 'vue-cookie'

import Element from 'element-ui'
import './element-variables.scss'

import errorHandlers from '../mixin/errorHandlers'

import App from '../app.vue'
import MenuEditor from '../parts/sub_functions/menu-editor.vue'
import MatchMaker from '../parts/sub_functions/match-maker.vue'

Vue.mixin(errorHandlers);

Vue.use(Vuex);
Vue.use(VueCookie);
Vue.use(VueResource);
Vue.use(VueRouter);
Vue.use(VueLodash);
Vue.use(Element);

const routes = [{
    path: '/menu',
    component: MenuEditor
  },
  {
    path: '/match_maker',
    component: MatchMaker
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
    },
    selected: []
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
    },
    syncSelected (state, payload) {
      state.selected = payload;
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
    },
    getSelected: state => {
      return state.selected;
    }
  },
  plugins: [createPersistedState()]
})

document.addEventListener('DOMContentLoaded', () => {
  document.body.appendChild(document.createElement('lab'))
  const app = new Vue({
    mixins: [errorHandlers],
    data: {},
    store,
    router,
    render: h => h(App)
  }).$mount('lab')
})
