<template>
  <div>
    <h2>ログイン</h2>
    <form @submit.prevent="login">
      <!-- `v-model`で、データ(dataプロパティ)と入力フォームの内容を連動させることができる -->
      <!-- 入力フォームバインディングと呼ばれるそうですー。 -->
      <input
        id="email"
        autocomplete="email"
        type="email"
        required
        placeholder="メールアドレス"
        v-model="email"
      />
      <input
        id="password"
        type="password"
        required
        placeholder="パスワード"
        v-model="password"
      />
      <div class="error">{{ error }}</div>
      <div>
        <button>ログインする</button>
      </div>
    </form>
  </div>
</template>

<script>
import axios from "axios";
import setItem from "../auth/setItem.js";

export default {
  data() {
    return {
      email: "",
      password: "",
      error: null,
    };
  },
  methods: {
    // ここでログイン処理を書く
    // 非同期処理で行うので、async/awaitを使う
    async login() {
      this.error = null;
      try {
        const response = await axios.post(
          "http://localhost:3000/auth/sign_in",
          {
            email: this.email,
            password: this.password,
          }
        );
        if (!response) {
          throw new Error("メールアドレスもしくはパスワードが違います；；");
        }
        if (!this.error) {
          // ログイン時に必要な情報をローカルストレージに保存する
          setItem(response.headers, response.data.data.name);
          // チャットルームにリダイレクトさせる
          this.$emit("redirectToChatroom");
        }
        console.log({ response });
      } catch (error) {
        console.log({ error });
        this.error = "ログインに失敗しました。";
      }
    },
  },
};
</script>
