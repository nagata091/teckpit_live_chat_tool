<template>
  <div>
    <h2>アカウントを登録</h2>
    <form @submit.prevent="signup">
      <input
        id="name"
        autocomplete="email"
        type="text"
        required
        placeholder="名前"
        v-model="name"
      />
      <input
        id="email"
        autocomplete="name"
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
      <input
        id="password-confirmation"
        type="password"
        required
        placeholder="パスワード（確認用）"
        v-model="passwordConfirmation"
      />
      <div class="error">{{ error }}</div>
      <button>登録する</button>
    </form>
  </div>
</template>

<script>
import axios from "axios";
import setItem from "../auth/setItem.js";

export default {
  data() {
    return {
      name: "",
      email: "",
      password: "",
      passwordConfirmation: "",
      error: null,
    };
  },
  methods: {
    // ここでサインアップ処理を書く
    // 非同期処理で行うので、async/awaitを使う
    async signup() {
      this.error = null;
      try {
        const response = await axios.post("http://localhost:3000/auth", {
          name: this.name,
          email: this.email,
          password: this.password,
          password_confirmation: this.passwordConfirmation,
        });
        // サインアップできなかったときは、エラーを発生させる
        if (!response) {
          throw new Error("アカウントを登録できませんでした；；");
        }
        // サインアップできたら、チャットルームにリダイレクトさせる
        if (!this.error) {
          // ログイン時に必要な情報をローカルストレージに保存する
          setItem(response.headers, response.data.data.name);
          // チャットルームにリダイレクトさせる
          this.$emit("redirectToChatroom");
        }
        console.log({ response });
      } catch (error) {
        this.error = "アカウントを登録できませんでした；；";
      }
    },
  },
};
</script>
