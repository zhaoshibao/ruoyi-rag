<template>
  <el-header class="top-nav">
    <div class="logo">

      <ModelSelect />
    </div>
    <!--<img src="../assets/logo.png" alt="Logo Image" class="logo_ai">-->
  </el-header>
</template>

<script>
import ModelSelect from "./ModelSelect.vue";
import MenuBox from './MenuBox.vue'; // 引入 MenuBox 组件

export default {
  name: "TopNav",
  components: {
    ModelSelect,
    MenuBox, // 注册 MenuBox 组件
  },
  data() {
    return {

    };
  },
};
</script>

<style scoped>
.top-nav {
  position: absolute;
  top: 0;
  left: 0;
  display: flex;
  justify-content: space-between;
  align-items: center;
  width: 100%;
  padding: 0;
  background-color: rgba(0, 0, 0, 0.2);
}

.logo {
  font-size: 20px;
  font-weight: bold;
  display: flex;
  align-items: center;
}

.logo_ai {
  width: 35px;
  height: 35px;
  margin-right: 60px
}
</style>