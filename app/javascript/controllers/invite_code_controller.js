import { Controller } from '@hotwired/stimulus';

// 招待コードの表示・コピーを行う
export default class extends Controller {
  static targets = ['panel', 'code', 'copied'];

  reveal() {
    this.panelTarget.classList.remove('d-none');
  }

  async copy() {
    await navigator.clipboard.writeText(this.codeTarget.textContent.trim());
    this.copiedTarget.classList.remove('d-none');
  }
}
