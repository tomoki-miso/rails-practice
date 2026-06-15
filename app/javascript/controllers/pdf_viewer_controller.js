import { Controller } from '@hotwired/stimulus';
import * as pdfjsLib from 'pdfjs-dist';

pdfjsLib.GlobalWorkerOptions.workerSrc =
  'https://cdn.jsdelivr.net/npm/pdfjs-dist@4.10.38/build/pdf.worker.min.mjs';

export default class extends Controller {
  static targets = ['canvas', 'pageInfo', 'prev', 'next', 'pageField'];
  static values = { url: String };

  connect() {
    this.currentPage = 1;
    this.pdfDoc = null;
    if (!this.urlValue) return;
    pdfjsLib
      .getDocument(this.urlValue)
      .promise.then((doc) => {
        this.pdfDoc = doc;
        this.render();
      })
      .catch((error) => {
        console.error('PDFの読み込みに失敗しました', error);
        this.pageInfoTarget.textContent = 'PDFの読み込みに失敗しました';
      });
  }

  render() {
    if (!this.pdfDoc) return;
    this.pdfDoc.getPage(this.currentPage).then((page) => {
      const viewport = page.getViewport({ scale: 1.5 });
      const canvas = this.canvasTarget;
      const ctx = canvas.getContext('2d');
      canvas.height = viewport.height;
      canvas.width = viewport.width;
      page.render({ canvasContext: ctx, viewport });
      this.pageInfoTarget.textContent = `${this.currentPage} / ${this.pdfDoc.numPages}`;
      this.prevTarget.disabled = this.currentPage <= 1;
      this.nextTarget.disabled = this.currentPage >= this.pdfDoc.numPages;
      this.updatePageField();
    });
  }

  pageFieldTargetConnected(el) {
    el.value = this.currentPage;
  }

  updatePageField() {
    if (this.hasPageFieldTarget) this.pageFieldTarget.value = this.currentPage;
  }

  prev() {
    if (this.currentPage <= 1) return;
    this.currentPage--;
    this.render();
  }

  next() {
    if (!this.pdfDoc || this.currentPage >= this.pdfDoc.numPages) return;
    this.currentPage++;
    this.render();
  }
}
