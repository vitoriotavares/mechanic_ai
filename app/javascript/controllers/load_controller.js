import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    // Faz a consulta ao backend quando a página é carregada
    fetch("/answers/load")
      .then((response) => response.text())
      .then((html) => {
        this.element.innerHTML = html; // Insere o resultado na página
      })
      .catch((error) => console.error("Error:", error));
  }
}
