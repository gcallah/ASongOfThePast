// A Song of the Past — small progressive enhancements.
// Without JavaScript the first excerpt still shows; this adds the excerpt tabs.

(function () {
  "use strict";

  // ----- Excerpt tabs -----
  var tabs = document.querySelectorAll('.tabs [role="tab"]');
  tabs.forEach(function (tab) {
    tab.addEventListener("click", function () {
      tabs.forEach(function (other) {
        var selected = other === tab;
        other.setAttribute("aria-selected", String(selected));
        other.tabIndex = selected ? 0 : -1;
        document.getElementById(other.getAttribute("aria-controls")).hidden = !selected;
      });
    });
    // Left/right arrow keys move between tabs.
    tab.addEventListener("keydown", function (event) {
      if (event.key !== "ArrowRight" && event.key !== "ArrowLeft") return;
      var list = Array.prototype.slice.call(tabs);
      var step = event.key === "ArrowRight" ? 1 : -1;
      var next = list[(list.indexOf(tab) + step + list.length) % list.length];
      next.focus();
      next.click();
    });
  });
})();
