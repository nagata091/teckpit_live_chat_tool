<template>
  <div>
    👇これはコンポーネントから表示されているメッセージです。
    <p>{{ message }}</p>
    <p>{{ isEnabled }}</p>
    <button @click="onClick">親メソッドを実行するボタン</button>
  </div>
</template>

<script>
export default {
  props: ["message", "isEnabled"],
  methods: {
    onClick() {
      // 親コンポーネントのtoggleメソッドを実行する
      this.$emit("toggle");
    },
  },
};
</script>
