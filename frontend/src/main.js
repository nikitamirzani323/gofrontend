import './app.css'
import App from './App.svelte'

const app = new App({
  target: document.getElementById('app'),
  props: {
    path_api: "/",
    // path_api: "http://localhost:2222/",
    table_header_font: "13px",
		table_body_font: "13px",
    version: "0.0.1",
  }
})

export default app
