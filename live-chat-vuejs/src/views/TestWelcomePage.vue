<template>
  <div>
    <h1>{{ title }}</h1>
    <!-- `@toggle`は子コンポーネントの`this.$emit('toggle')`に紐づいている -->
    <TestComponent
      @toggle="toggle"
      :isEnabled="isEnabled"
      message="コンポーネントにデータが渡されています！ひょー！"
    />
    <p v-if="isEnabled">こんにちは！</p>
  </div>
</template>

<script>
import TestComponent from "../components/TestComponent.vue";

export default {
  components: {
    TestComponent,
  },
  data() {
    return {
      title: "初めてのVue.jsアプリです！うひょー！",
      subtitle: "ようこそ！",
      isEnabled: true,
    };
  },
  computed: {
    text() {
      if (this.isEnabled) {
        return "こんにちは！";
      } else {
        return "さようなら！";
      }
    },
  },
  methods: {
    // isEnabledの値を反転させるtoggleメソッド
    // `@click`は`v-on:click`の省略形
    // `@dblclick`でダブルクリック時のイベントを設定できる
    toggle() {
      this.isEnabled = !this.isEnabled;
    },
  },
};
</script>

<!-- `scoped`によって、このVueファイルのHTMLだけにCSSを適用している -->
<style scoped>
p {
  font-size: 20px;
  color: red;
}
</style>
