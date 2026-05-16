(function () {
	var shell = document.querySelector(".cjd-shell");
	var toggle = document.querySelector(".cjd-shell__toggle");
	if (!shell || !toggle) {
		return;
	}
	toggle.addEventListener("click", function () {
		var open = shell.classList.toggle("is-nav-open");
		toggle.setAttribute("aria-expanded", open ? "true" : "false");
	});
})();
