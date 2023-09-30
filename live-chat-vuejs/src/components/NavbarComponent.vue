<template>
  <nav>
    <div>
      <p>
        こんにちは、<span class="name">{{ name }}</span
        >さん
      </p>
      <p class="email">現在、{{ email }}でログイン中です</p>
      <div class="error">{{ error }}</div>
    </div>
    <button @click="logout">ログアウト</button>
  </nav>
</template>

<script>
import removeItem from "@/auth/removeItem";
import axios from "axios";

export default {
  data() {
    return {
      // ローカルストレージに保存してある情報を取得する
      name: window.localStorage.getItem("name"),
      email: window.localStorage.getItem("uid"),
      error: null,
    };
  },
  methods: {
    async logout() {
      try {
        this.error = null;
        const response = await axios.delete(
          "http://localhost:3000/auth/sign_out",
          {
            // ログアウトはログインしている状態でないとできないので、ヘッダーに情報を入れて送信する
            headers: {
              uid: this.email,
              "access-token": window.localStorage.getItem("access-token"),
              client: window.localStorage.getItem("client"),
            },
          }
        );
        if (!response) {
          new Error("ログアウトできませんでした");
        }
        if (!this.error) {
          console.log("ログアウトしました");
          // ログアウト時に必要な情報をローカルストレージから削除する
          removeItem();
          // ログインページにリダイレクトさせる
          this.$router.push({ name: "WelcomePage" });
        }
        return response;
      } catch (error) {
        this.error = "ログアウトできませんでした；；";
      }
    },
  },
};
</script>

<style scoped>
nav {
  padding: 20px;
  border-bottom: 1px solid #eee;
  display: flex;
  justify-content: space-between;
  align-items: center;
}
nav p {
  margin: 2px auto;
  font-size: 16px;
  color: #444;
}
nav p.email {
  font-size: 14px;
  color: #999;
}
</style>
