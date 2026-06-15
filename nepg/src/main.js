import { createApp } from 'vue'
import App from './App.vue'
import router from './router'
import {
  Button, Cell, CellGroup, Field, Form, List, NavBar, Tag, Divider, Empty, PullRefresh, showToast
} from 'vant'
import 'vant/lib/index.css'

const app = createApp(App)
app.use(router)
app.use(Button).use(Cell).use(CellGroup).use(Field).use(Form)
  .use(List).use(NavBar).use(Tag).use(Divider).use(Empty).use(PullRefresh)
app.config.globalProperties.$toast = showToast
app.mount('#app')
