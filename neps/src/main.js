import { createApp } from 'vue'
import App from './App.vue'
import router from './router'
import {
  Button, Cell, CellGroup, Field, Form, NavBar, Tag, Empty, PullRefresh,
  Picker, Popup, RadioGroup, Radio, showToast
} from 'vant'
import 'vant/lib/index.css'

const app = createApp(App)
app.use(router)
app.use(Button).use(Cell).use(CellGroup).use(Field).use(Form)
  .use(NavBar).use(Tag).use(Empty).use(PullRefresh)
  .use(Picker).use(Popup).use(RadioGroup).use(Radio)
app.config.globalProperties.$toast = showToast
app.mount('#app')
