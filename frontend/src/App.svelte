<script>
  import Router from "svelte-spa-router";
  import { wrap } from "svelte-spa-router/wrap";
  import Navbar from "./components/Navbar.svelte";
	import Dashboard from "./pages/dashboard/Dashboard.svelte";

  import Login from "./pages/Login.svelte";
	import NotFound from "./pages/NotFound.svelte";

  export let path_api = "";
  export let table_header_font;
	export let table_body_font;
  let token = localStorage.getItem("token");
	let routes = "";
	let isNav = false;
  if (token == "" || token == null) {
		routes = {
			"/": wrap({
        props: {
					path_api: path_api,
				},
				component: Login,
			}),
			"*": NotFound,
		};
	} else {
    isNav = true;
		routes = {
			"/": wrap({
				props: {
					table_header_font: table_header_font,
					table_body_font: table_body_font,
				},
				component: Dashboard,
			}),
			"*": NotFound,
		};
  }
</script>

{#if isNav}
	<Navbar />
{/if}
<Router {routes} />