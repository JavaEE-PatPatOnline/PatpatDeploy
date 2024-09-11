// Wait till the browser is ready to render the game (avoids glitches)
window.requestAnimationFrame(function () {
  new GameManager(4, KeyboardInputManager, HTMLActuator, LocalStorageManager);
});

function switch_theme() {
  let mode = localStorage.getItem('color-mode') || 'light';
  if (mode === 'dark') {
    let dark = document.createElement('link');
    dark.rel = 'stylesheet';
    dark.type = 'text/css';
    dark.href = 'style/dark.css';
    dark.id = 'dark-mode';
    document.head.appendChild(dark);
  } else {
    let dark = document.getElementById('dark-mode');
    if (dark) {
      dark.remove();
    }
  }
}

switch_theme();

// watch for changes in the color-mode
window.addEventListener('storage', switch_theme);
