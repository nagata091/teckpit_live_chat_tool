import axios from "axios";
import { ref } from "vue";
import removeItem from "./removeItem";

// 変数errorの値を監視する。変数errorの値が変更されると、自動的に再レンダリングされる
// 初期値はnull
const error = ref(null);

// RailsAPIと通信して、ログインしているかどうかを確認するメソッド
const validate = async () => {
  // 変数errorの値を初期化する。refの値は.valueで取得できる
  error.value = null;
  // ローカルストレージからuid, client, accessTokenを取得
  const uid = window.localStorage.getItem("uid");
  const client = window.localStorage.getItem("client");
  const accessToken = window.localStorage.getItem("access-token");
  // RailsAPIと通信して、取得した情報の有効期限が切れていないか確認
  try {
    const response = await axios.get(
      "http://localhost:3000/auth/validate_token",
      {
        headers: {
          uid: uid,
          "access-token": accessToken,
          client: client,
        },
      }
    );
    if (!response) {
      throw new Error("認証に失敗しました；；");
    }
    return response;
  } catch (err) {
    error.value = "認証に失敗しました；；";
    removeItem();
  }
};

// validateメソッドを実行してその結果を返すだけのメソッド
const useValidate = () => {
  return { error, validate };
};

export default useValidate;
