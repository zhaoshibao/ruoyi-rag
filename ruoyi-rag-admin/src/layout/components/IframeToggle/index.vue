<template>
  <transition-group name="fade-transform" mode="out-in">
    <inner-link
      v-for="(item, index) in iframeViews"
      :key="item.path"
      :iframeId="'iframe' + index"
      v-show="$route.path === item.path"
      :src="iframeUrl(item.meta.link, item.queryVo)"
    ></inner-link>
  </transition-group>
</template>

<script>
import InnerLink from "../InnerLink/index";

export default {
  components: { InnerLink },
  computed: {
    iframeViews() {
      return this.$store.state.tagsView.iframeViews;
    }
  },
  methods: {
    iframeUrl(url, queryVo) {
      if (Object.keys(queryVo).length > 0) {
        let params = Object.keys(queryVo).map((key) => key + "=" + queryVo[key]).join("&");
        return url + "?" + params;
      }
      return url;
    }
  }
}
</script>
