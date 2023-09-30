import { createRouter, createWebHistory } from "vue-router";
import WelcomePage from "../views/WelcomePage.vue";
import ChatroomPage from "../views/ChatroomPage.vue";
import useValidate from "../auth/validate";

// useValidateメソッドを実行し、validateメソッドを使用できるようにする
const { error, validate } = useValidate();

// ログインしているときにアクセスを許可するメソッド
// eslint-disable-next-line no-unused-vars
const requireAuth = async (to, from, next) => {
  // ローカルストレージからuid, client, access-tokenを取得
  const uid = window.localStorage.getItem("uid");
  const client = window.localStorage.getItem("client");
  const accessToken = window.localStorage.getItem("access-token");
  // uid, client, access-tokenのいずれかがない場合はログインしていないと判断
  if (!uid || !client || !accessToken) {
    console.log("ログインしていません");
    next({ name: "WelcomePage" });
    return;
  }
  // validateメソッドを実行し、その結果をresponseに代入
  await validate();
  // error.valueがtrueの場合は認証に失敗していると判断
  if (error.value) {
    console.log("認証に失敗しました；；");
    next({ name: "WelcomePage" });
    return;
  } else {
    // error.valueがfalseの場合は認証に成功していると判断し、次の処理に進む
    console.log("認証に成功しました！！");
    next();
  }
};

// ログインしていないときにアクセスを許可するメソッド
// eslint-disable-next-line no-unused-vars
const noRequireAuth = async (to, from, next) => {
  const uid = window.localStorage.getItem("uid");
  const client = window.localStorage.getItem("client");
  const accessToken = window.localStorage.getItem("access-token");
  // uid, client, access-tokenのいずれかがない場合はログインしていないと判断
  if (!uid && !client && !accessToken) {
    // ログインしていない場合は次の処理に進む
    next();
    return;
  }
  // validateメソッドを実行し、その結果をresponseに代入
  await validate();
  // error.valueがfalseの場合は認証に成功していると判断し、ChatroomPageにリダイレクトする
  if (!error.value) {
    next({ name: "ChatroomPage" });
  } else {
    // error.valueがtrueの場合は認証に失敗していると判断し、次の処理に進む
    next();
  }
};

const routes = [
  {
    path: "/",
    name: "WelcomePage",
    component: WelcomePage,
    // 設定されているルートにアクセスする前にnoRequireAuthが実行される
    // ログインしているとWelcomePageにアクセスできない
    beforeEnter: noRequireAuth,
  },
  {
    path: "/chatroom",
    name: "ChatroomPage",
    component: ChatroomPage,
    // 設定されているルートにアクセスする前にrequireAuthが実行される
    // ログインしていないとChatroomPageにアクセスできない
    beforeEnter: requireAuth,
  },
];

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes,
});

export default router;
