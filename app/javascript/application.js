import "@hotwired/turbo-rails"
import "controllers"

window.TurboNativeBridge = {
  postMessage(name, data = {}) {
    if (window.webkit && window.webkit.messageHandlers && window.webkit.messageHandlers.nativeApp) {
      window.webkit.messageHandlers.nativeApp.postMessage({ name, ...data });
    } 
    else if (window.nativeApp) {
      window.nativeApp.postMessage(JSON.stringify({ name, ...data }));
    } else {
      console.log("Turbo Native мост не найден. Команда:", name, data);
    }
  }
}
