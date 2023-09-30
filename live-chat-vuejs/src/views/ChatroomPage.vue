<template>
  <div class="container">
    <NavbarComponent />
    <ChatWindow
      @connectCable="connectCable"
      :messages="formattedMessages"
      ref="chatWindow"
    />
    <NewChatForm @connectCable="connectCable" />
  </div>
</template>

<script>
import NavbarComponent from "@/components/NavbarComponent.vue";
import ChatWindow from "@/components/ChatWindow.vue";
import NewChatForm from "@/components/NewChatForm.vue";
import axios from "axios";
import ActionCable from "actioncable";
import { formatDistanceToNow } from "date-fns";
import { ja } from "date-fns/locale";

export default {
  components: {
    NavbarComponent,
    ChatWindow,
    NewChatForm,
  },
  data() {
    return {
      messages: [],
    };
  },
  computed: {
    // メッセージ一覧を表示する際に、created_atを見やすい形式にフォーマットする
    formattedMessages() {
      if (!this.messages.length) {
        return [];
      }
      return this.messages.map((message) => {
        let time = formatDistanceToNow(new Date(message.created_at), {
          locale: ja,
        });
        return { ...message, created_at: time };
      });
    },
  },
  methods: {
    async getMessages() {
      try {
        const response = await axios.get("http://localhost:3000/messages", {
          headers: {
            uid: window.localStorage.getItem("uid"),
            "access-token": window.localStorage.getItem("access-token"),
            client: window.localStorage.getItem("client"),
          },
        });
        if (!response) {
          new Error("メッセージ一覧を取得できませんでした；；");
        }
        this.messages = response.data;
      } catch (err) {
        console.log(err);
      }
    },
    // 子コンポーネントからmessageを受け取り、ActionCableを通してRailsに送信
    // 送信されたmessageとemailは、RailsのRoomChannel#receiveで受け取る
    connectCable(message) {
      this.messageChannel.perform("receive", {
        message: message,
        email: window.localStorage.getItem("uid"),
      });
    },
  },
  // ライフサイクルフック。ライフサイクル＝ブラウザ画面が表示されるまでの過程
  // mounted()は、ページが読み込まれHTMLが表示される直前に実行される
  mounted() {
    // RailsのActionCableとコネクションを確立
    const cable = ActionCable.createConsumer("ws://localhost:3000/cable");
    // "RoomChannel"という名前のチャンネルと常時接続状態にする
    this.messageChannel = cable.subscriptions.create("RoomChannel", {
      // 接続できたら実行
      connected: () => {
        this.getMessages().then(() => {
          // メッセージ一覧を取得したら、ChatWindowコンポーネントのscrollToBottomメソッドを実行
          this.$refs.chatWindow.scrollToBottom();
        });
      },
      // ActionCableから何らかのデータを受信したら実行
      received: () => {
        this.getMessages().then(() => {
          // メッセージ一覧を取得したら、ChatWindowコンポーネントのscrollToBottomメソッドを実行
          this.$refs.chatWindow.scrollToBottom();
        });
      },
    });
  },
  // ライフサイクルフック。ライフサイクル＝ブラウザ画面が表示されるまでの過程
  // beforeUnmount()は、ページを移動したり、ページが閉じられる直前に実行される
  beforeUnmount() {
    // チャンネルとのコネクションを削除
    this.messageChannel.unsubscribe();
  },
};
</script>

<style scoped></style>
