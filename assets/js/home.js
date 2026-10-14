const sections = [...document.querySelectorAll(".hero, .chapter, .footer")];
if (!sections.length) {
  document.documentElement.style.scrollSnapType = "none";
} else {
  const tracker = document.createElement("nav");
  tracker.className = "rail";
  tracker.setAttribute("aria-label", "Chapters");
  const pad = (n) => String(n).padStart(2, "0");
  const names = sections.map((sec) => sec.querySelector(".eyebrow")?.textContent.trim() ?? "");
  const links = sections.map((sec, i) => {
    sec.id ||= `chapter-${i}`;
    const a = document.createElement("a");
    a.href = `#${sec.id}`;
    a.innerHTML = `<span class="name"></span>`;
    a.querySelector(".name").textContent = `${pad(i + 1)} ${names[i]}`;
    a.setAttribute("aria-label", names[i] || `Chapter ${i + 1}`);
    tracker.appendChild(a);
    return a;
  });
  document.body.appendChild(tracker);

  const nav = document.querySelector(".nav");
  const syncNav = () => {
    if (nav) document.documentElement.style.setProperty("--nav", `${nav.offsetHeight}px`);
  };
  syncNav();
  addEventListener("resize", syncNav);

  const count = document.querySelector(".count");
  const update = () => {
    const mid = innerHeight * 0.45;
    let idx = 0;
    sections.forEach((sec, i) => {
      if (sec.getBoundingClientRect().top <= mid) idx = i;
    });
    links.forEach((a, i) => a.classList.toggle("active", i === idx));
    if (count) count.innerHTML = `<b>${pad(idx + 1)}</b> / ${pad(sections.length)}`;
  };
  update();
  addEventListener("scroll", update, { passive: true });
}
