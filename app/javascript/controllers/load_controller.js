import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    // Conecta ao endpoint de SSE
    const eventSource = new EventSource("/answers/load");

    // Atualiza o elemento conforme as mensagens chegam
    eventSource.onmessage = (event) => {
      const content = document.createElement("p");
      content.textContent = event.data; // Adiciona o texto recebido
      this.element.appendChild(content); // Insere no DOM
    };

    // Lida com erros de conexão
    eventSource.onerror = (error) => {
      console.error("SSE Error:", error);
      eventSource.close(); // Fecha a conexão em caso de erro
    };

    // Lida com o evento "done" para saber quando a transmissão termina
    eventSource.addEventListener("done", () => {
      const doneMessage = document.createElement("p");
      doneMessage.textContent = "Streaming completo.";
      doneMessage.classList.add("text-gray-500", "italic");
      this.element.appendChild(doneMessage);

      eventSource.close(); // Fecha a conexão após a conclusão
    });
  }
}
