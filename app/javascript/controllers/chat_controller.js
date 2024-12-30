import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["output"];

  connect() {
    console.log("ChatController connected");
  }

  startStreaming() {
    const eventSource = new EventSource("/chats");
    let fullContent = ""; // Para construir o texto completo.

    eventSource.onmessage = (event) => {
      const content = event.data;

      // Atualizar o DOM em tempo real.
      this.outputTarget.insertAdjacentHTML(
        "beforeend",
        `<span>${content}</span>`
      );

      // Concatenar texto completo se necessário.
      fullContent += content;
    };

    eventSource.onerror = () => {
      console.log("Streaming ended");
      eventSource.close();
    };
  }
}
