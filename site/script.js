/* ============================================================
   Agent Skills — Core catalog
   Typewriter hero · screenshot probing + lightbox · filters · copy
   ============================================================ */
(function () {
  "use strict";

  document.documentElement.classList.add("js");

  var reduceMotion = window.matchMedia("(prefers-reduced-motion: reduce)").matches;

  /* ---------------------------------------------------------
     1. Hero typewriter — cycles the frontmatter of each skill
     --------------------------------------------------------- */
  var TYPED = [
    { name: "repo-docs-builder",    line: ["A repository that reads", "like somebody meant it."] },
    { name: "recipe-validator",     line: ["A script does the maths.", "You supply the judgment."] },
    { name: "task-router",          line: ["Size the job first,", "then pick the model."] },
    { name: "business-plan-builder",line: ["Eight passes, one gate,", "and every number sourced."] },
    { name: "news-images",          line: ["Cartoon-editorial news,", "eight ways."] },
    { name: "html-email-templates", line: ["Emails that survive the", "clients that strip CSS."] },
    { name: "video-downloader",     line: ["Quality, format, and", "audio-only when you want it."] },
    { name: "project-hub-scaffold", line: ["A clickable document tree,", "no build step required."] }
  ];

  function tokensFor(entry) {
    return [
      { t: "---\n", c: "c" },
      { t: "name: ", c: "k" }, { t: entry.name, c: "v" }, { t: "\n", c: "" },
      { t: "description: >-\n", c: "k" },
      { t: "  " + entry.line[0] + "\n", c: "s" },
      { t: "  " + entry.line[1] + "\n", c: "s" },
      { t: "---", c: "c" }
    ];
  }

  function escapeHtml(s) {
    return s.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;");
  }

  function renderTokens(tokens, count) {
    var out = "", left = count;
    for (var i = 0; i < tokens.length && left > 0; i++) {
      var tok = tokens[i];
      var take = Math.min(left, tok.t.length);
      var slice = escapeHtml(tok.t.slice(0, take));
      out += tok.c ? '<span class="' + tok.c + '">' + slice + "</span>" : slice;
      left -= take;
    }
    return out;
  }

  function totalLength(tokens) {
    return tokens.reduce(function (n, t) { return n + t.t.length; }, 0);
  }

  var typer = document.getElementById("typer");
  if (typer) {
    var index = 0, count = 0, dir = 1;

    var paint = function (tokens, n) { typer.innerHTML = renderTokens(tokens, n); };

    if (reduceMotion) {
      paint(tokensFor(TYPED[0]), totalLength(tokensFor(TYPED[0])));
    } else {
      var step = function () {
        var tokens = tokensFor(TYPED[index]);
        var total = totalLength(tokens);

        if (dir === 1) {
          count += 1;
          paint(tokens, count);
          if (count >= total) { dir = -1; return setTimeout(step, 2100); }
          return setTimeout(step, 26 + Math.random() * 26);
        }

        count -= 3;
        if (count <= 0) {
          count = 0; dir = 1;
          index = (index + 1) % TYPED.length;
          return setTimeout(step, 340);
        }
        paint(tokens, count);
        return setTimeout(step, 14);
      };
      paint(tokensFor(TYPED[0]), 0);
      setTimeout(step, 420);
    }
  }

  /* ---------------------------------------------------------
     2. Screenshot probing — find whatever images exist on disk
     --------------------------------------------------------- */
  var EXTS = ["png", "jpg", "webp", "jpeg"];
  var probeCache = {};

  function probeFile(base) {
    if (probeCache[base] !== undefined) return Promise.resolve(probeCache[base]);
    return new Promise(function (resolve) {
      var i = 0;
      (function tryNext() {
        if (i >= EXTS.length) { probeCache[base] = null; return resolve(null); }
        var url = "assets/img/" + base + "." + EXTS[i++];
        var img = new Image();
        img.onload = function () { probeCache[base] = url; resolve(url); };
        img.onerror = tryNext;
        img.src = url;
      })();
    });
  }

  // Extras (name-2, name-3, name-4) are only probed when a card is opened,
  // so a page load never fires a wall of 404s for screenshots that don't exist yet.
  function probeExtras(name) {
    return Promise.all([
      probeFile(name + "-2"),
      probeFile(name + "-3"),
      probeFile(name + "-4")
    ]).then(function (all) {
      return all.filter(Boolean);
    });
  }

  var gallery = {}; // skill name -> array of urls

  document.querySelectorAll(".shot").forEach(function (img) {
    var name = img.getAttribute("data-name");
    var media = img.closest(".card-media");
    if (!name || !media) return;

    probeFile(name).then(function (url) {
      if (!url) return;
      gallery[name] = [url];
      img.src = url;
      media.classList.add("has-shot");
    });
  });

  /* ---------------------------------------------------------
     3. Lightbox
     --------------------------------------------------------- */
  var lb = document.getElementById("lightbox");
  var lbImg = document.getElementById("lbImg");
  var lbCap = document.getElementById("lbCap");
  var lbPrev = lb && lb.querySelector(".lb-prev");
  var lbNext = lb && lb.querySelector(".lb-next");
  var lbState = { items: [], index: 0, name: "" };

  function showLightbox(name, index) {
    var items = gallery[name] || [];
    if (!items.length) return;
    lbState = { items: items, index: index || 0, name: name };
    paintLightbox();
    lb.hidden = false;
    document.body.style.overflow = "hidden";
    lb.querySelector(".lb-close").focus();

    probeExtras(name).then(function (extra) {
      if (!extra.length || lb.hidden) return;
      lbState.items = items.concat(extra);
      paintLightbox();
    });
  }

  function paintLightbox() {
    var url = lbState.items[lbState.index];
    lbImg.src = url;
    lbImg.alt = lbState.name + " — preview " + (lbState.index + 1);
    lbCap.textContent = lbState.name + "  ·  " + (lbState.index + 1) + " / " + lbState.items.length;
    var multi = lbState.items.length > 1;
    if (lbPrev) lbPrev.hidden = !multi;
    if (lbNext) lbNext.hidden = !multi;
  }

  function closeLightbox() {
    lb.hidden = true;
    lbImg.removeAttribute("src");
    document.body.style.overflow = "";
  }

  function stepLightbox(delta) {
    var n = lbState.items.length;
    if (n < 2) return;
    lbState.index = (lbState.index + delta + n) % n;
    paintLightbox();
  }

  if (lb) {
    document.querySelectorAll(".card-media").forEach(function (media) {
      media.addEventListener("click", function () {
        if (!media.classList.contains("has-shot")) return;
        var name = media.querySelector(".shot").getAttribute("data-name");
        showLightbox(name, 0);
      });
    });

    lb.querySelector(".lb-close").addEventListener("click", closeLightbox);
    if (lbPrev) lbPrev.addEventListener("click", function (e) { e.stopPropagation(); stepLightbox(-1); });
    if (lbNext) lbNext.addEventListener("click", function (e) { e.stopPropagation(); stepLightbox(1); });
    lb.addEventListener("click", function (e) { if (e.target === lb) closeLightbox(); });

    document.addEventListener("keydown", function (e) {
      if (lb.hidden) return;
      if (e.key === "Escape") closeLightbox();
      else if (e.key === "ArrowLeft") stepLightbox(-1);
      else if (e.key === "ArrowRight") stepLightbox(1);
    });
  }

  /* ---------------------------------------------------------
     4. Category filters
     --------------------------------------------------------- */
  var chips = document.querySelectorAll(".chip");
  var cards = document.querySelectorAll("#skillGrid .card");

  function applyFilter(value) {
    cards.forEach(function (card) {
      var match = value === "all" || card.getAttribute("data-category") === value;
      card.classList.toggle("is-hidden", !match);
      if (match && !reduceMotion && card.animate) {
        card.animate(
          [{ opacity: 0, transform: "translateY(12px)" }, { opacity: 1, transform: "none" }],
          { duration: 340, easing: "cubic-bezier(.22,1,.36,1)" }
        );
      }
    });
  }

  chips.forEach(function (chip) {
    chip.addEventListener("click", function () {
      chips.forEach(function (c) { c.classList.remove("is-active"); });
      chip.classList.add("is-active");
      applyFilter(chip.getAttribute("data-filter"));
    });
  });

  /* ---------------------------------------------------------
     5. Copy-to-clipboard
     --------------------------------------------------------- */
  function copyText(text) {
    if (navigator.clipboard && navigator.clipboard.writeText) {
      return navigator.clipboard.writeText(text);
    }
    return new Promise(function (resolve) {
      var ta = document.createElement("textarea");
      ta.value = text;
      ta.style.position = "fixed";
      ta.style.opacity = "0";
      document.body.appendChild(ta);
      ta.select();
      try { document.execCommand("copy"); } catch (e) {}
      document.body.removeChild(ta);
      resolve();
    });
  }

  document.querySelectorAll("[data-copy]").forEach(function (btn) {
    var original = btn.querySelector(".cmd-icon");
    var originalText = original ? original.textContent : null;

    btn.addEventListener("click", function () {
      copyText(btn.getAttribute("data-copy")).then(function () {
        btn.classList.add("is-copied");
        if (original) original.textContent = "copied";
        else btn.textContent = "copied";

        setTimeout(function () {
          btn.classList.remove("is-copied");
          if (original) original.textContent = originalText;
          else btn.textContent = "copy";
        }, 1400);
      });
    });
  });

  /* ---------------------------------------------------------
     6. Scroll reveal
     --------------------------------------------------------- */
  var revealables = document.querySelectorAll(".reveal");
  if (reduceMotion || !("IntersectionObserver" in window)) {
    revealables.forEach(function (el) { el.classList.add("is-in"); });
  } else {
    var io = new IntersectionObserver(function (entries) {
      entries.forEach(function (entry) {
        if (entry.isIntersecting) {
          entry.target.classList.add("is-in");
          io.unobserve(entry.target);
        }
      });
    }, { rootMargin: "0px 0px -8% 0px", threshold: 0.08 });

    revealables.forEach(function (el, i) {
      el.style.transitionDelay = Math.min(i % 4, 3) * 60 + "ms";
      io.observe(el);
    });
  }
})();
