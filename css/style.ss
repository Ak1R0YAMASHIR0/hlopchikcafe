@import url('https://fonts.googleapis.com/css2?family=Caveat:wght@500;600&family=Cormorant+Garamond:ital,wght@0,400;0,500;0,600;1,400;1,500&family=Golos+Text:wght@400;500;600&display=swap');

/* ---------- 1. Токены --------------------------------------- */
:root {
  --paper: #F7F1E6;
  --paper-2: #F1E7D7;
  --paper-3: #E8DAC6;
  --card: #FCF7EC;

  --ink: #231812;
  --ink-2: #5A4335;
  --ink-3: #8B7565;
  --rust: #A64B2A;
  --rust-2: #8A3A1E;
  --olive: #5E6B4C;
  --gold: #C2913F;

  --line: rgba(35, 24, 18, .16);
  --line-strong: rgba(35, 24, 18, .34);

  --serif: "Cormorant Garamond", "Times New Roman", Georgia, serif;
  --sans: "Golos Text", "Segoe UI", system-ui, -apple-system, sans-serif;
  --hand: "Caveat", "Segoe Script", cursive;

  --wrap: 1240px;
  --head-h: 78px;
  --radius: 5px;

  --ease: cubic-bezier(.22, .61, .36, 1);
}

/* ---------- 2. Сброс и база --------------------------------- */
*,
*::before,
*::after { box-sizing: border-box; }

html { scroll-behavior: smooth; }

body {
  margin: 0;
  background: var(--paper);
  color: var(--ink);
  font-family: var(--sans);
  font-size: 16px;
  line-height: 1.6;
  -webkit-font-smoothing: antialiased;
  text-rendering: optimizeLegibility;
  overflow-x: hidden;
  display: flex;
  flex-direction: column;
  min-height: 100vh;
}

main { flex: 1 0 auto; }

/* бумажное зерно поверх всего */
body::after {
  content: "";
  position: fixed;
  inset: 0;
  z-index: 1000;
  pointer-events: none;
  opacity: .5;
  mix-blend-mode: multiply;
  background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='160' height='160'%3E%3Cfilter id='n'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='.9' numOctaves='3' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='160' height='160' filter='url(%23n)' opacity='.16'/%3E%3C/svg%3E");
}

body.is-locked { overflow: hidden; }

img { max-width: 100%; display: block; }
svg { display: block; }
button { font: inherit; color: inherit; }
a { color: inherit; }
[hidden] { display: none !important; }
code {
  font-family: ui-monospace, "Cascadia Mono", Consolas, monospace;
  font-size: .88em;
  background: rgba(35, 24, 18, .06);
  padding: 1px 5px;
  border-radius: 2px;
}
::selection { background: var(--rust); color: var(--paper); }

:focus-visible {
  outline: 2px solid var(--rust);
  outline-offset: 3px;
}

.sr-only {
  position: absolute; width: 1px; height: 1px;
  padding: 0; margin: -1px; overflow: hidden;
  clip: rect(0 0 0 0); white-space: nowrap; border: 0;
}

.skip {
  position: fixed; left: 16px; top: -60px; z-index: 2000;
  background: var(--ink); color: var(--paper);
  padding: 10px 16px; border-radius: 3px;
  font-size: .85rem; text-decoration: none;
  transition: top .2s var(--ease);
}
.skip:focus { top: 16px; }

/* ---------- 3. Типографика и утилиты ------------------------ */
.wrap {
  width: 100%;
  max-width: var(--wrap);
  margin-inline: auto;
  padding-inline: clamp(18px, 4vw, 48px);
}

h1, h2, h3, h4 {
  font-family: var(--serif);
  font-weight: 500;
  margin: 0;
  letter-spacing: -.01em;
}

p { margin: 0; }

.eyebrow {
  display: inline-flex;
  align-items: center;
  gap: .75em;
  font-family: var(--sans);
  font-size: .68rem;
  font-weight: 500;
  letter-spacing: .2em;
  text-transform: uppercase;
  color: var(--ink-3);
}
.eyebrow::before {
  content: "";
  width: 26px;
  height: 1px;
  background: currentColor;
  opacity: .55;
}
.eyebrow--plain::before { display: none; }

.hand {
  font-family: var(--hand);
  font-size: 1.35rem;
  line-height: 1.1;
  color: var(--ink-2);
}

.lead {
  font-size: clamp(1rem, 1.25vw, 1.15rem);
  line-height: 1.65;
  color: var(--ink-2);
}

.muted { color: var(--ink-3); }
.small { font-size: .82rem; line-height: 1.55; }
.serif { font-family: var(--serif); }
.center { text-align: center; }

.section { padding-block: clamp(54px, 8vw, 112px); }
.section--tight { padding-block: clamp(38px, 5vw, 64px); }
.section--line { border-top: 1px solid var(--line); }
.band {
  background: var(--paper-2);
  border-block: 1px solid var(--line);
}

.section__head {
  display: flex;
  align-items: flex-end;
  justify-content: space-between;
  gap: 28px;
  margin-bottom: clamp(28px, 4vw, 54px);
}
.section__head > div { max-width: 640px; }
.section__title {
  font-size: clamp(1.9rem, 3.6vw, 3.1rem);
  line-height: 1.02;
  margin-top: 12px;
}
.section__link {
  flex: none;
  font-size: .74rem;
  font-weight: 500;
  letter-spacing: .12em;
  text-transform: uppercase;
  text-decoration: none;
  border-bottom: 1px solid var(--line-strong);
  padding-bottom: 6px;
  transition: color .2s, border-color .2s;
}
.section__link:hover { color: var(--rust); border-color: var(--rust); }

.grid { display: grid; gap: clamp(16px, 2vw, 28px); }
.grid--3 { grid-template-columns: repeat(3, minmax(0, 1fr)); }
.grid--2 { grid-template-columns: repeat(2, minmax(0, 1fr)); }

.stack { display: flex; flex-direction: column; }
.row { display: flex; align-items: center; gap: 12px; }

/* ---------- 4. Шапка ---------------------------------------- */
.head {
  position: sticky;
  top: 0;
  z-index: 60;
  background: var(--paper);
  border-bottom: 1px solid var(--line);
  transition: box-shadow .3s var(--ease);
}
.head.is-scrolled { box-shadow: 0 12px 30px -26px rgba(35, 24, 18, .9); }

.head__in {
  min-height: var(--head-h);
  display: flex;
  align-items: center;
  gap: 24px;
  justify-content: space-between;
}

.brand {
  display: inline-flex;
  align-items: center;
  gap: 12px;
  text-decoration: none;
  flex: none;
}
.brand__mark { width: 38px; height: 38px; color: var(--rust); flex: none; }
.brand__text { display: flex; flex-direction: column; line-height: 1; }
.brand__name {
  font-family: var(--serif);
  font-size: 1.5rem;
  font-weight: 600;
  letter-spacing: .005em;
}
.brand__sub {
  font-size: .56rem;
  letter-spacing: .24em;
  text-transform: uppercase;
  color: var(--ink-3);
  margin-top: 5px;
}

.nav { display: flex; align-items: center; gap: clamp(10px, 2.2vw, 30px); }
.nav a {
  position: relative;
  font-size: .78rem;
  font-weight: 500;
  letter-spacing: .1em;
  text-transform: uppercase;
  text-decoration: none;
  color: var(--ink-2);
  padding: 6px 0;
  transition: color .2s;
}
.nav a::after {
  content: "";
  position: absolute;
  left: 0; right: 100%;
  bottom: 0;
  height: 1px;
  background: var(--rust);
  transition: right .28s var(--ease);
}
.nav a:hover, .nav a.is-active { color: var(--ink); }
.nav a:hover::after, .nav a.is-active::after { right: 0; }

.head__actions { display: flex; align-items: center; gap: 10px; flex: none; }

.cart-pill {
  display: inline-flex;
  align-items: center;
  gap: 9px;
  height: 42px;
  padding: 0 8px 0 16px;
  border: 1px solid var(--line-strong);
  border-radius: 999px;
  text-decoration: none;
  font-size: .74rem;
  font-weight: 500;
  letter-spacing: .1em;
  text-transform: uppercase;
  transition: background .22s, color .22s, border-color .22s;
}
.cart-pill svg { width: 17px; height: 17px; }
.cart-pill:hover { background: var(--ink); color: var(--paper); border-color: var(--ink); }
.cart-pill__count {
  display: grid;
  place-items: center;
  min-width: 27px;
  height: 27px;
  padding: 0 6px;
  border-radius: 999px;
  background: var(--rust);
  color: var(--paper);
  font-size: .72rem;
  letter-spacing: 0;
  transition: transform .25s var(--ease);
}
.cart-pill__count.is-bump { animation: bump .35s var(--ease); }

.burger {
  display: none;
  width: 42px; height: 42px;
  border: 1px solid var(--line-strong);
  border-radius: 999px;
  background: transparent;
  padding: 0;
  place-items: center;
  cursor: pointer;
}
.burger span {
  display: block;
  width: 16px; height: 1.5px;
  background: var(--ink);
  margin: 2.5px auto;
  transition: transform .25s var(--ease), opacity .2s;
}
.burger[aria-expanded="true"] span:first-child { transform: translateY(3.2px) rotate(45deg); }
.burger[aria-expanded="true"] span:last-child { transform: translateY(-3.2px) rotate(-45deg); }

/* ---------- 5. Кнопки и ссылки ------------------------------ */
.btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: .6em;
  padding: 1.05em 1.6em;
  border: 1px solid var(--ink);
  border-radius: 3px;
  background: var(--ink);
  color: var(--paper);
  font-family: var(--sans);
  font-size: .73rem;
  font-weight: 600;
  letter-spacing: .12em;
  text-transform: uppercase;
  text-decoration: none;
  cursor: pointer;
  transition: background .22s, border-color .22s, color .22s, transform .18s;
}
.btn:hover { background: var(--rust); border-color: var(--rust); transform: translateY(-1px); }
.btn:active { transform: translateY(0); }
.btn--rust { background: var(--rust); border-color: var(--rust); }
.btn--rust:hover { background: var(--rust-2); border-color: var(--rust-2); }
.btn--ghost { background: transparent; color: var(--ink); }
.btn--ghost:hover { background: var(--ink); border-color: var(--ink); color: var(--paper); }
.btn--ghost-rust { background: transparent; border-color: var(--line-strong); color: var(--ink); }
.btn--ghost-rust:hover { border-color: var(--rust); background: transparent; color: var(--rust); }
.btn--sm { padding: .82em 1.15em; font-size: .66rem; }
.btn--block { width: 100%; }
.btn:disabled { opacity: .45; pointer-events: none; }

.link {
  font-size: .86rem;
  color: var(--ink-2);
  text-decoration: none;
  border-bottom: 1px solid var(--line-strong);
  padding-bottom: 2px;
  transition: color .2s, border-color .2s;
}
.link:hover { color: var(--rust); border-color: var(--rust); }

.text-btn {
  background: none;
  border: 0;
  padding: 0;
  font-size: .78rem;
  color: var(--ink-3);
  cursor: pointer;
  text-decoration: underline;
  text-underline-offset: 4px;
  transition: color .2s;
}
.text-btn:hover { color: var(--rust); }

/* ---------- 6. Главная: герой ------------------------------- */
.hero { position: relative; overflow: hidden; }
.hero__in {
  display: grid;
  grid-template-columns: 1.06fr .94fr;
  gap: clamp(28px, 5vw, 72px);
  align-items: center;
  padding-block: clamp(38px, 6vw, 84px) clamp(48px, 7vw, 96px);
}

.hero__eyebrow { margin-bottom: clamp(18px, 2.4vw, 28px); }

.hero h1 {
  font-size: clamp(2.9rem, 6.9vw, 6rem);
  line-height: .92;
  letter-spacing: -.025em;
  font-weight: 500;
}
.hero h1 em {
  font-style: italic;
  color: var(--rust);
  font-weight: 400;
}

.hero__lead {
  max-width: 33ch;
  margin-top: clamp(20px, 2.6vw, 30px);
  font-size: clamp(1rem, 1.15vw, 1.1rem);
  line-height: 1.68;
  color: var(--ink-2);
}

.hero__actions {
  display: flex;
  align-items: center;
  gap: 22px;
  flex-wrap: wrap;
  margin-top: clamp(26px, 3.4vw, 38px);
}

.hero__meta {
  display: flex;
  flex-wrap: wrap;
  gap: 10px 0;
  margin-top: clamp(30px, 4vw, 48px);
  padding-top: 22px;
  border-top: 1px solid var(--line);
  list-style: none;
  padding-left: 0;
  font-size: .76rem;
  letter-spacing: .06em;
  color: var(--ink-3);
  text-transform: uppercase;
}
.hero__meta li { display: flex; align-items: center; }
.hero__meta li + li::before {
  content: "";
  width: 3px; height: 3px;
  border-radius: 50%;
  background: var(--rust);
  margin: 0 14px;
  opacity: .8;
}

/* правая часть героя — «меню-карточка» */
.hero__art {
  position: relative;
  display: grid;
  place-items: center;
  min-height: clamp(400px, 46vw, 560px);
}
.hero__art::before {
  content: "";
  position: absolute;
  width: min(430px, 88%);
  aspect-ratio: 1;
  border: 1px solid var(--line);
  border-radius: 50%;
}
.hero__art::after {
  content: "";
  position: absolute;
  width: min(300px, 62%);
  aspect-ratio: 1;
  border-radius: 50%;
  background: var(--paper-2);
  z-index: 0;
}

.hero__card {
  position: relative;
  z-index: 1;
  width: min(340px, 82%);
  background: var(--card);
  border: 1px solid var(--line-strong);
  border-radius: var(--radius);
  padding: 20px 22px 18px;
  transform: rotate(-2.4deg);
  box-shadow: 0 34px 60px -46px rgba(35, 24, 18, .95);
}
.hero__card-top {
  display: flex;
  justify-content: space-between;
  font-size: .6rem;
  letter-spacing: .18em;
  text-transform: uppercase;
  color: var(--ink-3);
  border-bottom: 1px solid var(--line);
  padding-bottom: 12px;
}
.hero__card img {
  display: block;
  width: 100%;
  aspect-ratio: 4 / 3;
  object-fit: cover;
  margin: 10px 0 4px;
  border: 1px solid var(--line);
  border-radius: 2px;
}
.hero__card-foot {
  display: flex;
  align-items: baseline;
  justify-content: space-between;
  gap: 12px;
  border-top: 1px solid var(--line);
  padding-top: 12px;
}
.hero__card-foot span:first-child {
  font-family: var(--serif);
  font-size: 1.35rem;
  font-weight: 600;
}
.hero__card-foot span:last-child {
  font-family: var(--serif);
  font-size: 1.35rem;
  font-weight: 600;
  color: var(--rust);
}

.stamp {
  position: absolute;
  z-index: 2;
  right: -3%;
  bottom: -5%;
  width: 108px;
  height: 108px;
  display: grid;
  place-items: center;
  text-align: center;
  padding: 12px;
  border: 1.5px solid var(--rust);
  border-radius: 50%;
  color: var(--rust);
  font-size: .58rem;
  font-weight: 600;
  line-height: 1.5;
  letter-spacing: .16em;
  text-transform: uppercase;
  transform: rotate(9deg);
  background: rgba(247, 241, 230, .55);
}
.stamp::before {
  content: "";
  position: absolute;
  inset: 6px;
  border: 1px solid currentColor;
  border-radius: 50%;
  opacity: .45;
}

.hero__note {
  position: absolute;
  z-index: 2;
  left: -2%;
  top: 4%;
  transform: rotate(-7deg);
  text-align: right;
  color: var(--ink-3);
}

/* бегущая строка */
.ticker {
  border-block: 1px solid var(--line);
  background: var(--paper-2);
  overflow: hidden;
  padding-block: 13px;
}
.ticker__track {
  display: flex;
  align-items: center;
  gap: 40px;
  width: max-content;
  animation: ticker 46s linear infinite;
  font-size: .68rem;
  font-weight: 500;
  letter-spacing: .18em;
  text-transform: uppercase;
  color: var(--ink-2);
  white-space: nowrap;
}
.ticker__track span { display: inline-flex; align-items: center; gap: 40px; }
.ticker__track i {
  font-style: normal;
  color: var(--rust);
  font-size: .9rem;
  line-height: 1;
}

/* ---------- 7. Карточки товаров ----------------------------- */
.card {
  display: flex;
  flex-direction: column;
  background: var(--card);
  border: 1px solid var(--line);
  border-radius: var(--radius);
  overflow: hidden;
  transition: transform .3s var(--ease), box-shadow .3s var(--ease), border-color .3s;
}
.card:hover {
  transform: translateY(-5px);
  border-color: var(--line-strong);
  box-shadow: 0 26px 40px -38px rgba(35, 24, 18, 1);
}

.card__art {
  position: relative;
  aspect-ratio: 4 / 3;
  display: grid;
  place-items: center;
  background: var(--card);
  overflow: hidden;
  border-bottom: 1px solid var(--line);
}
.card:nth-child(3n + 1) .card__art { background: #F3E8D6; }
.card:nth-child(3n + 2) .card__art { background: #EEE2CE; }
.card:nth-child(3n) .card__art { background: #F2E5D2; }

.card__art::before {
  content: "";
  position: absolute;
  width: 66%;
  aspect-ratio: 1;
  border: 1px solid rgba(35, 24, 18, .13);
  border-radius: 50%;
}
.card__art::after {
  content: "";
  position: absolute;
  right: 7%;
  bottom: 6%;
  width: 30%;
  aspect-ratio: 1;
  border-radius: 50%;
  background: rgba(194, 145, 63, .15);
}
.card__art img {
  position: relative;
  z-index: 1;
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform .5s var(--ease);
}
.card:hover .card__art img { transform: scale(1.035); }

.card__num {
  position: absolute;
  z-index: 2;
  top: 13px; left: 15px;
  font-size: .64rem;
  font-weight: 500;
  letter-spacing: .16em;
  color: var(--ink-3);
}

.card__badge {
  position: absolute;
  z-index: 2;
  top: 11px; right: 11px;
  padding: 5px 9px;
  border: 1px solid var(--rust);
  border-radius: 2px;
  color: var(--rust);
  background: rgba(247, 241, 230, .7);
  font-size: .56rem;
  font-weight: 600;
  letter-spacing: .12em;
  text-transform: uppercase;
  transform: rotate(2deg);
}

.card__body {
  display: flex;
  flex-direction: column;
  flex: 1;
  gap: 9px;
  padding: 20px 20px 18px;
}
.card__cat {
  font-size: .62rem;
  font-weight: 500;
  letter-spacing: .18em;
  text-transform: uppercase;
  color: var(--rust);
}
.card__title { font-size: 1.45rem; line-height: 1.12; font-weight: 600; }
.card__desc {
  flex: 1;
  font-size: .86rem;
  line-height: 1.55;
  color: var(--ink-2);
}
.card__foot {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
  margin-top: 8px;
  padding-top: 14px;
  border-top: 1px solid var(--line);
}
.card__price {
  font-family: var(--serif);
  font-size: 1.5rem;
  font-weight: 600;
  line-height: 1;
  white-space: nowrap;
}

/* ---------- 8. Секции главной ------------------------------- */
/* о нас коротко */
.about-teaser {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: clamp(28px, 6vw, 90px);
  align-items: start;
}
.about-teaser__lead {
  font-family: var(--serif);
  font-size: clamp(1.6rem, 2.9vw, 2.5rem);
  line-height: 1.18;
  letter-spacing: -.015em;
}
.about-teaser__lead em { font-style: italic; color: var(--rust); }
.about-teaser__note {
  margin-top: 26px;
  padding-left: 22px;
  border-left: 1px solid var(--line-strong);
  max-width: 42ch;
  font-size: .92rem;
  line-height: 1.7;
  color: var(--ink-2);
}
.facts {
  list-style: none;
  margin: 0;
  padding: 0;
  border-top: 1px solid var(--line);
}
.facts li {
  display: flex;
  align-items: baseline;
  justify-content: space-between;
  gap: 18px;
  padding: 15px 0;
  border-bottom: 1px solid var(--line);
  font-size: .86rem;
  color: var(--ink-2);
}
.facts b {
  font-family: var(--serif);
  font-size: 1.55rem;
  font-weight: 600;
  color: var(--ink);
  white-space: nowrap;
}

/* шаги */
.steps {
  list-style: none;
  margin: 0;
  padding: 0;
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: clamp(18px, 3vw, 44px);
  counter-reset: step;
}
.steps li {
  padding-top: 22px;
  border-top: 1px solid var(--line-strong);
  position: relative;
}
.step__num {
  display: block;
  font-family: var(--serif);
  font-size: 2rem;
  font-style: italic;
  color: var(--rust);
  line-height: 1;
  margin-bottom: 14px;
}
.step__title { font-size: 1.28rem; font-weight: 600; margin-bottom: 8px; }
.step__text { font-size: .87rem; line-height: 1.6; color: var(--ink-2); }

/* цитата */
.quote {
  max-width: 780px;
  margin-inline: auto;
  text-align: center;
  position: relative;
  padding-top: 12px;
}
.quote__mark {
  font-family: var(--serif);
  font-size: 7rem;
  line-height: .45;
  color: var(--rust);
  opacity: .5;
  display: block;
  margin-bottom: 4px;
}
.quote p {
  font-family: var(--serif);
  font-size: clamp(1.5rem, 3vw, 2.35rem);
  line-height: 1.24;
  letter-spacing: -.012em;
}
.quote footer {
  margin-top: 24px;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 4px;
  font-size: .72rem;
  letter-spacing: .16em;
  text-transform: uppercase;
  color: var(--ink-3);
}
.quote footer b { font-weight: 500; color: var(--ink); }
.quote footer span.hand {
  font-size: 1.5rem;
  text-transform: none;
  letter-spacing: 0;
  color: var(--rust);
}

/* контактная полоса */
.visit {
  display: grid;
  grid-template-columns: 1.15fr .85fr;
  gap: clamp(28px, 5vw, 70px);
  align-items: center;
}
.visit h2 { font-size: clamp(2rem, 4.2vw, 3.4rem); line-height: 1; }
.visit h2 em { font-style: italic; color: var(--rust); }
.visit p { margin-top: 18px; max-width: 40ch; color: var(--ink-2); }
.visit__info { border-top: 1px solid var(--line); }
.visit__row {
  display: flex;
  justify-content: space-between;
  gap: 20px;
  padding: 14px 0;
  border-bottom: 1px solid var(--line);
  font-size: .88rem;
}
.visit__row span { color: var(--ink-3); }
.visit__row a { text-decoration: none; }
.visit__row a:hover { color: var(--rust); }
.visit__cta { margin-top: 26px; }

/* ---------- 9. Внутренние страницы -------------------------- */
.page-head {
  padding-block: clamp(38px, 6vw, 74px) clamp(28px, 4vw, 48px);
  border-bottom: 1px solid var(--line);
}
.page-head__in { display: flex; align-items: flex-end; justify-content: space-between; gap: 40px; }
.page-head h1 {
  font-size: clamp(2.4rem, 5.4vw, 4.6rem);
  line-height: .96;
  margin-top: 14px;
}
.page-head h1 em { font-style: italic; color: var(--rust); }
.page-head__aside { max-width: 32ch; font-size: .9rem; line-height: 1.65; color: var(--ink-2); padding-bottom: 6px; }

.crumbs {
  font-size: .68rem;
  letter-spacing: .14em;
  text-transform: uppercase;
  color: var(--ink-3);
  margin-bottom: 6px;
}
.crumbs a { text-decoration: none; }
.crumbs a:hover { color: var(--rust); }

/* панель фильтров */
.toolbar {
  position: sticky;
  top: var(--head-h);
  z-index: 40;
  background: var(--paper);
  border-bottom: 1px solid var(--line);
}
.toolbar__in {
  display: flex;
  align-items: center;
  gap: 18px;
  flex-wrap: wrap;
  padding-block: 15px;
}
.search { position: relative; flex: 1 1 250px; max-width: 330px; }
.search svg {
  position: absolute;
  left: 13px; top: 50%;
  transform: translateY(-50%);
  width: 16px; height: 16px;
  color: var(--ink-3);
  pointer-events: none;
}
.search input {
  width: 100%;
  height: 44px;
  padding: 0 14px 0 39px;
  border: 1px solid var(--line-strong);
  border-radius: 999px;
  background: var(--card);
  color: var(--ink);
  font: inherit;
  font-size: .88rem;
}
.search input::placeholder { color: var(--ink-3); }
.search input:focus { outline: none; border-color: var(--ink); }

.pills { display: flex; flex-wrap: wrap; gap: 8px; }
.pill {
  display: inline-flex;
  align-items: center;
  gap: 7px;
  height: 40px;
  padding: 0 16px;
  border: 1px solid var(--line-strong);
  border-radius: 999px;
  background: transparent;
  color: var(--ink-2);
  font-size: .74rem;
  font-weight: 500;
  letter-spacing: .06em;
  cursor: pointer;
  transition: background .2s, color .2s, border-color .2s;
}
.pill i {
  font-style: normal;
  font-size: .66rem;
  color: var(--ink-3);
  transition: color .2s;
}
.pill:hover { border-color: var(--ink); color: var(--ink); }
.pill[aria-pressed="true"] {
  background: var(--ink);
  border-color: var(--ink);
  color: var(--paper);
}
.pill[aria-pressed="true"] i { color: rgba(247, 241, 230, .6); }

.toolbar__count {
  margin-left: auto;
  font-size: .7rem;
  letter-spacing: .14em;
  text-transform: uppercase;
  color: var(--ink-3);
  white-space: nowrap;
}

.menu-grid { padding-top: clamp(26px, 4vw, 44px); }

.empty {
  padding: clamp(44px, 7vw, 90px) 20px;
  text-align: center;
  border: 1px dashed var(--line-strong);
  border-radius: var(--radius);
}
.empty h3 { font-size: 1.7rem; margin-bottom: 8px; }
.empty p { color: var(--ink-2); margin-bottom: 22px; font-size: .92rem; }

/* ---------- 10. Корзина ------------------------------------- */
.cart-layout {
  display: grid;
  grid-template-columns: minmax(0, 1fr) 384px;
  gap: clamp(24px, 4vw, 56px);
  align-items: start;
  padding-block: clamp(30px, 4vw, 52px) clamp(54px, 8vw, 100px);
}

.cart-list { border-top: 1px solid var(--line); }
.cart-item {
  display: grid;
  grid-template-columns: 86px minmax(0, 1fr) auto;
  gap: clamp(14px, 2vw, 24px);
  align-items: center;
  padding: 20px 0;
  border-bottom: 1px solid var(--line);
}
.cart-item__thumb {
  width: 86px;
  aspect-ratio: 1;
  display: grid;
  place-items: center;
  border: 1px solid var(--line);
  border-radius: 4px;
  background: var(--paper-2);
  overflow: hidden;
}
.cart-item__thumb img { width: 100%; height: 100%; object-fit: cover; }
.cart-item__title { font-family: var(--serif); font-size: 1.28rem; font-weight: 600; line-height: 1.15; }
.cart-item__meta { font-size: .75rem; color: var(--ink-3); margin-top: 4px; letter-spacing: .04em; }
.cart-item__price {
  font-family: var(--serif);
  font-size: 1.25rem;
  font-weight: 600;
  white-space: nowrap;
  text-align: right;
}
.cart-item__side {
  display: flex;
  flex-direction: column;
  align-items: flex-end;
  gap: 10px;
}

.stepper {
  display: inline-flex;
  align-items: center;
  height: 38px;
  border: 1px solid var(--line-strong);
  border-radius: 999px;
  overflow: hidden;
}
.stepper button {
  width: 34px;
  height: 100%;
  border: 0;
  background: transparent;
  cursor: pointer;
  font-size: 1.05rem;
  line-height: 1;
  color: var(--ink-2);
  transition: background .18s, color .18s;
}
.stepper button:hover { background: var(--paper-2); color: var(--ink); }
.stepper span {
  min-width: 28px;
  text-align: center;
  font-size: .86rem;
  font-weight: 500;
  font-variant-numeric: tabular-nums;
}

.summary {
  position: sticky;
  top: calc(var(--head-h) + 22px);
  background: var(--paper-2);
  border: 1px solid var(--line);
  border-radius: var(--radius);
  padding: clamp(20px, 2.4vw, 30px);
}
.summary__title {
  font-size: 1.55rem;
  font-weight: 600;
  margin-bottom: 18px;
}

.seg {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 4px;
  padding: 4px;
  border: 1px solid var(--line);
  border-radius: 999px;
  background: rgba(252, 247, 236, .6);
  margin-bottom: 20px;
}
.seg label { position: relative; }
.seg input { position: absolute; opacity: 0; pointer-events: none; }
.seg span {
  display: block;
  text-align: center;
  padding: 8px 6px;
  border-radius: 999px;
  font-size: .72rem;
  font-weight: 500;
  letter-spacing: .08em;
  text-transform: uppercase;
  color: var(--ink-3);
  cursor: pointer;
  transition: background .2s, color .2s;
}
.seg input:checked + span { background: var(--ink); color: var(--paper); }
.seg input:focus-visible + span { outline: 2px solid var(--rust); outline-offset: 2px; }

.summary__rows { margin: 0; }
.summary__rows > div {
  display: flex;
  align-items: baseline;
  justify-content: space-between;
  gap: 14px;
  padding: 10px 0;
  border-bottom: 1px dashed var(--line);
  font-size: .87rem;
}
.summary__rows dt { color: var(--ink-2); }
.summary__rows dd { margin: 0; font-variant-numeric: tabular-nums; }

.summary__total {
  display: flex;
  align-items: baseline;
  justify-content: space-between;
  gap: 16px;
  margin-top: 16px;
  padding-top: 16px;
  border-top: 1px solid var(--line-strong);
  font-size: .78rem;
  letter-spacing: .12em;
  text-transform: uppercase;
  color: var(--ink-2);
}
.summary__total strong {
  font-family: var(--serif);
  font-size: 2rem;
  font-weight: 600;
  letter-spacing: 0;
  text-transform: none;
  color: var(--ink);
  font-variant-numeric: tabular-nums;
}
.summary__cta { margin-top: 20px; }
.summary__note {
  margin-top: 14px;
  font-size: .72rem;
  line-height: 1.55;
  color: var(--ink-3);
}

/* успех оформления */
.success { text-align: center; padding: 10px 0 4px; }
.success__mark {
  width: 74px; height: 74px;
  margin: 0 auto 20px;
  display: grid;
  place-items: center;
  border: 1px solid var(--rust);
  border-radius: 50%;
  color: var(--rust);
}
.success__mark svg { width: 30px; height: 30px; }
.success h3 { font-size: 2rem; margin-bottom: 10px; }
.success p { color: var(--ink-2); font-size: .92rem; max-width: 38ch; margin-inline: auto; }
.success__num {
  font-family: var(--serif);
  font-size: 1.4rem;
  color: var(--ink);
  margin-top: 6px;
}
.success__actions {
  display: flex;
  gap: 12px;
  justify-content: center;
  flex-wrap: wrap;
  margin-top: 26px;
}

/* ---------- 11. Формы --------------------------------------- */
.form { display: flex; flex-direction: column; gap: 18px; }
.form__grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 16px;
}
.form__full { grid-column: 1 / -1; }

.field { display: flex; flex-direction: column; gap: 6px; }
.field label {
  font-size: .64rem;
  font-weight: 500;
  letter-spacing: .14em;
  text-transform: uppercase;
  color: var(--ink-2);
}
.input,
.select,
.textarea {
  width: 100%;
  background: var(--card);
  border: 1px solid var(--line-strong);
  border-radius: 3px;
  padding: .8em .95em;
  color: var(--ink);
  font: inherit;
  font-size: .92rem;
  transition: border-color .2s, box-shadow .2s, background .2s;
}
.textarea { min-height: 118px; resize: vertical; line-height: 1.55; }
.select {
  appearance: none;
  padding-right: 34px;
  background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='8' viewBox='0 0 12 8'%3E%3Cpath d='M1 1l5 5 5-5' fill='none' stroke='%235A4335' stroke-width='1.4' stroke-linecap='round'/%3E%3C/svg%3E");
  background-repeat: no-repeat;
  background-position: right 13px center;
  cursor: pointer;
}
.input::placeholder,
.textarea::placeholder { color: #A99583; }
.input:focus,
.select:focus,
.textarea:focus {
  outline: none;
  border-color: var(--ink);
  box-shadow: 0 0 0 3px rgba(166, 75, 42, .12);
}
.field__err {
  display: none;
  font-size: .73rem;
  line-height: 1.4;
  color: var(--rust-2);
}
.field.is-invalid .input,
.field.is-invalid .select,
.field.is-invalid .textarea {
  border-color: var(--rust);
  background: #FBF1E9;
}
.field.is-invalid .field__err { display: block; }

.field__hint { font-size: .7rem; color: var(--ink-3); }

.check {
  display: flex;
  align-items: flex-start;
  gap: 10px;
  font-size: .78rem;
  line-height: 1.5;
  color: var(--ink-2);
  cursor: pointer;
}
.check input { margin-top: 3px; accent-color: var(--rust); }

.form__foot {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 16px;
  flex-wrap: wrap;
  margin-top: 4px;
}
.form__notice {
  font-size: .72rem;
  color: var(--ink-3);
  max-width: 36ch;
}

.form-card {
  background: var(--card);
  border: 1px solid var(--line);
  border-radius: var(--radius);
  padding: clamp(22px, 3vw, 36px);
}

.alert {
  display: none;
  padding: 12px 14px;
  border-left: 2px solid var(--rust);
  background: #FBF1E9;
  font-size: .82rem;
  color: var(--rust-2);
}
.alert.is-visible { display: block; }

/* ---------- 12. Личный кабинет ------------------------------ */
.auth {
  display: grid;
  grid-template-columns: 1fr .92fr;
  gap: clamp(30px, 6vw, 96px);
  align-items: start;
  padding-block: clamp(34px, 5vw, 64px) clamp(54px, 8vw, 100px);
}
.auth__lead h1 {
  font-size: clamp(2.2rem, 4.4vw, 3.8rem);
  line-height: 1;
}
.auth__lead h1 em { font-style: italic; color: var(--rust); }
.auth__lead > p {
  margin-top: 18px;
  max-width: 38ch;
  color: var(--ink-2);
  font-size: .95rem;
  line-height: 1.7;
}
.auth__benefits {
  list-style: none;
  margin: 30px 0 0;
  padding: 0;
  border-top: 1px solid var(--line);
}
.auth__benefits li {
  display: flex;
  gap: 12px;
  padding: 14px 0;
  border-bottom: 1px solid var(--line);
  font-size: .87rem;
  color: var(--ink-2);
}
.auth__benefits li::before {
  content: "—";
  color: var(--rust);
  flex: none;
}
.auth__demo {
  margin-top: 26px;
  padding: 14px 16px;
  border: 1px dashed var(--line-strong);
  border-radius: 3px;
  font-size: .76rem;
  line-height: 1.6;
  color: var(--ink-2);
}
.auth__demo b { font-weight: 600; color: var(--ink); }

.tabs {
  display: flex;
  gap: 4px;
  border-bottom: 1px solid var(--line);
  margin-bottom: 24px;
}
.tab {
  position: relative;
  padding: 11px 14px;
  border: 0;
  border-bottom: 2px solid transparent;
  margin-bottom: -1px;
  background: none;
  color: var(--ink-3);
  font-size: .72rem;
  font-weight: 500;
  letter-spacing: .12em;
  text-transform: uppercase;
  cursor: pointer;
  transition: color .2s, border-color .2s;
}
.tab:hover { color: var(--ink); }
.tab[aria-selected="true"] { color: var(--ink); border-color: var(--rust); }

.panel[hidden] { display: none; }

.profile-layout {
  display: grid;
  grid-template-columns: 300px minmax(0, 1fr);
  gap: clamp(24px, 4vw, 48px);
  align-items: start;
  padding-block: clamp(30px, 4vw, 52px) clamp(54px, 8vw, 100px);
}

.profile-card {
  background: var(--paper-2);
  border: 1px solid var(--line);
  border-radius: var(--radius);
  padding: 26px;
  position: sticky;
  top: calc(var(--head-h) + 22px);
}
.avatar {
  width: 68px; height: 68px;
  display: grid;
  place-items: center;
  border: 1px solid var(--line-strong);
  border-radius: 50%;
  font-family: var(--serif);
  font-size: 1.5rem;
  font-weight: 600;
  color: var(--rust);
  background: var(--card);
  margin-bottom: 16px;
}
.profile-card__name { font-family: var(--serif); font-size: 1.6rem; font-weight: 600; line-height: 1.15; }
.profile-card__mail { font-size: .78rem; color: var(--ink-3); margin-top: 4px; word-break: break-all; }
.profile-card__meta {
  margin-top: 18px;
  padding-top: 14px;
  border-top: 1px solid var(--line);
  font-size: .74rem;
  color: var(--ink-3);
  line-height: 1.7;
}
.profile-card__actions { margin-top: 20px; display: flex; flex-direction: column; gap: 10px; }

.panel-head {
  display: flex;
  align-items: flex-end;
  justify-content: space-between;
  gap: 18px;
  flex-wrap: wrap;
  padding-bottom: 14px;
  border-bottom: 1px solid var(--line-strong);
  margin-bottom: 6px;
}
.panel-head h2 { font-size: 1.75rem; font-weight: 600; }
.panel-head p { font-size: .78rem; color: var(--ink-3); margin-top: 4px; }

.info-list { border-top: 1px solid var(--line); margin-top: 6px; }
.info-row {
  display: grid;
  grid-template-columns: 150px minmax(0, 1fr);
  gap: 16px;
  padding: 15px 0;
  border-bottom: 1px solid var(--line);
  font-size: .9rem;
  align-items: baseline;
}
.info-row dt { font-size: .68rem; letter-spacing: .14em; text-transform: uppercase; color: var(--ink-3); }
.info-row dd { margin: 0; }

.profile-form { margin-top: 24px; padding-top: 22px; border-top: 1px solid var(--line); }

/* таблицы */
.table-wrap { width: 100%; overflow-x: auto; }
.table {
  width: 100%;
  border-collapse: collapse;
  font-size: .85rem;
  min-width: 620px;
}
.table th {
  text-align: left;
  padding: 11px 12px;
  border-bottom: 1px solid var(--line-strong);
  font-size: .62rem;
  font-weight: 600;
  letter-spacing: .14em;
  text-transform: uppercase;
  color: var(--ink-3);
  white-space: nowrap;
}
.table td {
  padding: 14px 12px;
  border-bottom: 1px solid var(--line);
  vertical-align: top;
  line-height: 1.5;
}
.table th:first-child, .table td:first-child { padding-left: 0; }
.table th:last-child, .table td:last-child { padding-right: 0; }
.table tbody tr:hover { background: rgba(241, 231, 215, .5); }
.table__num { font-family: var(--serif); font-size: 1.1rem; font-weight: 600; white-space: nowrap; }
.table__sum { white-space: nowrap; font-variant-numeric: tabular-nums; }
.table__muted { color: var(--ink-3); font-size: .78rem; }
.select--cell {
  width: auto;
  min-width: 128px;
  padding: .45em 28px .45em .6em;
  font-size: .78rem;
  background-position: right 9px center;
}

.status {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  padding: 4px 10px;
  border: 1px solid var(--line-strong);
  border-radius: 999px;
  font-size: .66rem;
  font-weight: 500;
  letter-spacing: .06em;
  white-space: nowrap;
}
.status::before {
  content: "";
  width: 5px; height: 5px;
  border-radius: 50%;
  background: currentColor;
}
.status--new { color: var(--rust); border-color: rgba(166, 75, 42, .45); }
.status--cooking { color: #986C22; border-color: rgba(194, 145, 63, .55); }
.status--ready { color: var(--olive); border-color: rgba(94, 107, 76, .5); }
.status--done { color: var(--ink-3); }
.status--canceled { color: var(--ink-3); text-decoration: line-through; }

/* ---------- 13. Админ-панель -------------------------------- */
.admin-head {
  display: flex;
  align-items: flex-end;
  justify-content: space-between;
  gap: 26px;
  flex-wrap: wrap;
  padding-block: clamp(30px, 4vw, 48px) 0;
}
.admin-head h1 { font-size: clamp(2rem, 3.8vw, 3rem); line-height: 1; margin-top: 12px; }
.admin-head h1 em { font-style: italic; color: var(--rust); }
.admin-user { text-align: right; font-size: .78rem; color: var(--ink-3); line-height: 1.6; }
.admin-user b { display: block; color: var(--ink); font-weight: 500; font-size: .9rem; }

.admin-stats {
  display: grid;
  grid-template-columns: repeat(4, minmax(0, 1fr));
  gap: 1px;
  margin-top: clamp(24px, 3vw, 34px);
  border: 1px solid var(--line);
  border-radius: var(--radius);
  overflow: hidden;
  background: var(--line);
}
.admin-stat {
  display: flex;
  flex-direction: column;
  gap: 7px;
  padding: 16px 18px;
  background: var(--card);
}
.admin-stat span {
  font-size: .62rem;
  letter-spacing: .14em;
  text-transform: uppercase;
  color: var(--ink-3);
}
.admin-stat b {
  font-family: var(--serif);
  font-size: clamp(1.35rem, 2.2vw, 1.8rem);
  font-weight: 500;
  line-height: 1;
}

.admin-tabs {
  display: flex;
  gap: clamp(6px, 1.5vw, 18px);
  border-bottom: 1px solid var(--line-strong);
  margin-top: clamp(24px, 3vw, 36px);
  flex-wrap: wrap;
}
.admin-tab {
  position: relative;
  display: inline-flex;
  align-items: center;
  gap: 8px;
  padding: 13px 2px;
  margin-bottom: -1px;
  margin-right: clamp(10px, 2vw, 24px);
  border: 0;
  border-bottom: 2px solid transparent;
  background: none;
  font-size: .74rem;
  font-weight: 500;
  letter-spacing: .11em;
  text-transform: uppercase;
  color: var(--ink-3);
  cursor: pointer;
}
.admin-tab:hover { color: var(--ink); }
.admin-tab[aria-selected="true"] { color: var(--ink); border-color: var(--rust); }
.admin-tab b {
  display: inline-grid;
  place-items: center;
  min-width: 20px;
  height: 20px;
  padding: 0 5px;
  border-radius: 999px;
  background: var(--rust);
  color: var(--paper);
  font-size: .62rem;
  letter-spacing: 0;
}

.admin-body { padding-block: clamp(24px, 3vw, 36px) clamp(54px, 8vw, 100px); }
.admin-toolbar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 16px;
  flex-wrap: wrap;
  margin-bottom: 18px;
}
.admin-toolbar p { font-size: .8rem; color: var(--ink-3); }
.admin-actions { display: flex; gap: 12px; flex-wrap: wrap; }

.admin-products td { vertical-align: middle; }
.admin-thumb {
  width: 54px; height: 42px;
  display: grid;
  place-items: center;
  border: 1px solid var(--line);
  border-radius: 3px;
  background: var(--paper-2);
  overflow: hidden;
}
.admin-thumb img { width: 100%; height: 100%; object-fit: cover; }
.row-actions { display: flex; gap: 12px; white-space: nowrap; }
.row-actions .text-btn { font-size: .74rem; }

.message-card {
  padding: 20px 0;
  border-bottom: 1px solid var(--line);
  display: grid;
  grid-template-columns: minmax(0, 1fr) auto;
  gap: 20px;
  align-items: start;
}
.message-card__top {
  display: flex;
  align-items: baseline;
  gap: 12px;
  flex-wrap: wrap;
}
.message-card__name { font-family: var(--serif); font-size: 1.3rem; font-weight: 600; }
.message-card__mail { font-size: .76rem; color: var(--ink-3); }
.message-card__topic {
  font-size: .62rem;
  letter-spacing: .1em;
  text-transform: uppercase;
  color: var(--rust);
  border: 1px solid rgba(166, 75, 42, .35);
  border-radius: 2px;
  padding: 3px 7px;
}
.message-card__text { margin-top: 10px; font-size: .89rem; line-height: 1.65; color: var(--ink-2); max-width: 70ch; }
.message-card__date { font-size: .7rem; color: var(--ink-3); white-space: nowrap; }
.message-card.is-unread .message-card__name::after {
  content: "новое";
  display: inline-block;
  margin-left: 10px;
  padding: 2px 7px;
  border-radius: 999px;
  background: var(--rust);
  color: var(--paper);
  font-family: var(--sans);
  font-size: .58rem;
  font-weight: 600;
  letter-spacing: .08em;
  vertical-align: middle;
}

.admin-guard {
  max-width: 520px;
  margin: clamp(50px, 10vw, 120px) auto;
  text-align: center;
  padding: 40px 26px;
  border: 1px solid var(--line);
  border-radius: var(--radius);
  background: var(--card);
}
.admin-guard h1 { font-size: 2rem; margin-bottom: 12px; line-height: 1.05; }
.admin-guard h1 em { font-style: italic; color: var(--rust); }
.admin-guard p { color: var(--ink-2); font-size: .92rem; margin-bottom: 24px; }
.admin-guard .form { text-align: left; margin-top: 22px; }

/* ---------- 14. Контакты ------------------------------------ */
.contacts-grid {
  display: grid;
  grid-template-columns: .95fr 1.05fr;
  gap: clamp(28px, 5vw, 72px);
  align-items: start;
  padding-block: clamp(34px, 5vw, 60px) clamp(54px, 8vw, 96px);
}
.contacts-info h2 { font-size: clamp(1.7rem, 2.8vw, 2.3rem); margin-bottom: 18px; }
.contact-block { border-top: 1px solid var(--line); }
.contact-row {
  display: grid;
  grid-template-columns: 122px minmax(0, 1fr);
  gap: 18px;
  padding: 16px 0;
  border-bottom: 1px solid var(--line);
  font-size: .9rem;
  line-height: 1.6;
}
.contact-row dt {
  font-size: .64rem;
  letter-spacing: .15em;
  text-transform: uppercase;
  color: var(--ink-3);
  padding-top: 4px;
}
.contact-row dd { margin: 0; }
.contact-row a { text-decoration: none; border-bottom: 1px solid var(--line); }
.contact-row a:hover { color: var(--rust); border-color: var(--rust); }

.map {
  position: relative;
  margin-top: 26px;
  border: 1px solid var(--line);
  border-radius: var(--radius);
  overflow: hidden;
  background: var(--paper-2);
  aspect-ratio: 16 / 10;
}
.map iframe {
  display: block;
  width: 100%;
  height: 100%;
  border: 0;
}

.feedback { background: var(--paper-2); border: 1px solid var(--line); border-radius: var(--radius); padding: clamp(22px, 3vw, 38px); }
.feedback h2 { font-size: clamp(1.7rem, 2.8vw, 2.2rem); }
.feedback > p { margin-top: 8px; font-size: .87rem; color: var(--ink-2); margin-bottom: 22px; }

/* ---------- 15. О нас --------------------------------------- */
.story {
  display: grid;
  grid-template-columns: .8fr 1.2fr;
  gap: clamp(28px, 5vw, 80px);
  align-items: start;
  padding-block: clamp(40px, 6vw, 84px);
}
.story__aside { position: sticky; top: calc(var(--head-h) + 30px); }
.story__aside h2 { font-size: clamp(1.9rem, 3.2vw, 2.8rem); line-height: 1.05; margin-top: 12px; }
.story__aside .hand { margin-top: 20px; color: var(--rust); font-size: 1.55rem; transform: rotate(-3deg); display: inline-block; }
.story__text p { font-size: .98rem; line-height: 1.8; color: var(--ink-2); }
.story__text p + p { margin-top: 18px; }
.story__text p:first-of-type::first-letter {
  float: left;
  font-family: var(--serif);
  font-size: 3.6rem;
  line-height: .82;
  padding: 6px 10px 0 0;
  color: var(--rust);
}
.story__sign {
  margin-top: 26px;
  font-family: var(--hand);
  font-size: 1.7rem;
  color: var(--ink-2);
  transform: rotate(-2deg);
}

.timeline {
  list-style: none;
  margin: 0;
  padding: 0;
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: clamp(16px, 2.4vw, 34px);
}
.timeline li { padding-top: 18px; border-top: 1px solid var(--line-strong); }
.timeline b {
  display: block;
  font-family: var(--serif);
  font-size: 1.9rem;
  font-weight: 500;
  color: var(--rust);
  line-height: 1;
  margin-bottom: 10px;
}
.timeline p { font-size: .84rem; line-height: 1.6; color: var(--ink-2); }

.values { display: grid; grid-template-columns: repeat(3, 1fr); gap: clamp(20px, 3vw, 44px); }
.value { padding-top: 20px; border-top: 1px solid var(--line-strong); }
.value__num {
  font-family: var(--serif);
  font-style: italic;
  font-size: 1.1rem;
  color: var(--rust);
}
.value h3 { font-size: 1.35rem; font-weight: 600; margin: 8px 0 8px; }
.value p { font-size: .87rem; line-height: 1.65; color: var(--ink-2); }

.team { display: grid; grid-template-columns: repeat(3, 1fr); gap: clamp(20px, 3vw, 40px); }
.member { display: flex; flex-direction: column; gap: 14px; }
.member__ava {
  width: 88px; height: 88px;
  display: grid;
  place-items: center;
  border-radius: 50%;
  border: 1px solid var(--line-strong);
  background: var(--card);
  font-family: var(--serif);
  font-size: 1.7rem;
  color: var(--rust);
}
.member h3 { font-size: 1.3rem; font-weight: 600; }
.member p { font-size: .82rem; color: var(--ink-3); line-height: 1.55; }

/* ---------- 16. Подвал -------------------------------------- */
.foot {
  background: var(--ink);
  color: var(--paper);
  margin-top: 0;
  position: relative;
}
.foot::before {
  content: "";
  position: absolute;
  inset: 0 0 auto;
  height: 3px;
  background: var(--rust);
}
.foot__top {
  display: grid;
  grid-template-columns: 1.1fr 1.4fr;
  gap: clamp(32px, 6vw, 90px);
  padding-block: clamp(40px, 6vw, 72px) clamp(30px, 4vw, 48px);
}
.foot__brand { max-width: 320px; }
.foot__word {
  font-family: var(--serif);
  font-size: 2.6rem;
  font-weight: 600;
  line-height: .95;
  letter-spacing: -.01em;
}
.foot__tag {
  margin-top: 14px;
  font-size: .85rem;
  line-height: 1.65;
  color: rgba(247, 241, 230, .6);
}
.foot__cols {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 24px;
}
.foot__col h3 {
  font-family: var(--sans);
  font-size: .6rem;
  font-weight: 600;
  letter-spacing: .2em;
  text-transform: uppercase;
  color: rgba(247, 241, 230, .45);
  margin-bottom: 14px;
}
.foot__col a,
.foot__col span {
  display: block;
  font-size: .84rem;
  line-height: 1.9;
  color: rgba(247, 241, 230, .82);
  text-decoration: none;
}
.foot__col a:hover { color: #E9A98F; }

.foot__bottom {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 18px;
  flex-wrap: wrap;
  padding-block: 18px 34px;
  border-top: 1px solid rgba(247, 241, 230, .14);
  font-size: .7rem;
  letter-spacing: .04em;
  color: rgba(247, 241, 230, .45);
}
.foot__bottom a { color: inherit; text-decoration: none; }
.foot__bottom a:hover { color: var(--paper); }

/* ---------- 17. Модальные окна и тосты ---------------------- */
.modal {
  position: fixed;
  inset: 0;
  z-index: 200;
  display: none;
  padding: clamp(12px, 3vw, 32px);
  overflow-y: auto;
}
.modal.is-open { display: grid; place-items: center; }
.modal__backdrop {
  position: fixed;
  inset: 0;
  background: rgba(28, 19, 14, .58);
  animation: fade .2s var(--ease);
}
.modal__panel {
  position: relative;
  width: min(660px, 100%);
  max-height: calc(100vh - 40px);
  overflow-y: auto;
  background: var(--paper);
  border: 1px solid var(--line-strong);
  border-radius: 6px;
  padding: clamp(22px, 3vw, 38px);
  box-shadow: 0 40px 80px -50px rgba(0, 0, 0, .9);
  animation: panel .26s var(--ease);
}
.modal__panel--narrow { width: min(480px, 100%); }
.modal__x {
  position: absolute;
  top: 14px; right: 14px;
  width: 34px; height: 34px;
  display: grid;
  place-items: center;
  border: 1px solid var(--line);
  border-radius: 50%;
  background: transparent;
  color: var(--ink-3);
  font-size: 1.1rem;
  line-height: 1;
  cursor: pointer;
  transition: color .2s, border-color .2s, transform .2s;
}
.modal__x:hover { color: var(--rust); border-color: var(--rust); transform: rotate(90deg); }
.modal__title { font-size: clamp(1.7rem, 3vw, 2.2rem); margin: 8px 0 20px; }

.toasts {
  position: fixed;
  left: 20px;
  bottom: 20px;
  z-index: 300;
  display: flex;
  flex-direction: column;
  gap: 10px;
  max-width: min(360px, calc(100vw - 40px));
}
.toast {
  display: flex;
  align-items: flex-start;
  gap: 12px;
  padding: 13px 16px;
  background: var(--ink);
  color: var(--paper);
  border-left: 3px solid var(--gold);
  border-radius: 2px;
  font-size: .82rem;
  line-height: 1.5;
  box-shadow: 0 20px 30px -22px rgba(0, 0, 0, .9);
  animation: toastIn .28s var(--ease);
}
.toast.is-out { animation: toastOut .25s var(--ease) forwards; }
.toast--err { border-left-color: var(--rust); }
.toast--ok { border-left-color: #A8BF86; }

/* ---------- 18. Анимации и адаптив -------------------------- */
.reveal {
  opacity: 0;
  transform: translateY(18px);
  transition: opacity .7s var(--ease), transform .7s var(--ease);
}
.reveal.is-in { opacity: 1; transform: none; }

@keyframes ticker { to { transform: translateX(-50%); } }
@keyframes bump { 40% { transform: scale(1.28); } 100% { transform: scale(1); } }
@keyframes fade { from { opacity: 0; } }
@keyframes panel { from { opacity: 0; transform: translateY(14px) scale(.99); } }
@keyframes toastIn { from { opacity: 0; transform: translateY(10px); } }
@keyframes toastOut { to { opacity: 0; transform: translateY(6px); } }

@media (prefers-reduced-motion: reduce) {
  html { scroll-behavior: auto; }
  *, *::before, *::after {
    animation-duration: .01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: .01ms !important;
  }
  .reveal { opacity: 1; transform: none; }
  .ticker__track { animation: none; }
}

/* --- 1180 --- */
@media (max-width: 1180px) {
  .hero__note { display: none; }
  .cart-layout { grid-template-columns: minmax(0, 1fr) 340px; }
  .profile-layout { grid-template-columns: 260px minmax(0, 1fr); }
}

/* --- 1020 --- */
@media (max-width: 1020px) {
  :root { --head-h: 70px; }
  .nav { gap: 16px; }
  .grid--3 { grid-template-columns: repeat(2, minmax(0, 1fr)); }
  .steps { grid-template-columns: 1fr; gap: 22px; }
  .steps li { display: grid; grid-template-columns: 56px 1fr; column-gap: 14px; }
  .step__num { grid-row: span 2; margin: 0; font-size: 1.6rem; }
  .timeline { grid-template-columns: repeat(2, 1fr); }
  .values, .team { grid-template-columns: repeat(2, 1fr); }
  .cart-layout { grid-template-columns: 1fr; }
  .summary { position: static; }
  .profile-layout { grid-template-columns: 1fr; }
  .profile-card { position: static; display: grid; grid-template-columns: auto 1fr; gap: 0 18px; align-items: center; }
  .avatar { grid-row: span 3; margin: 0; }
  .profile-card__meta { grid-column: 1 / -1; }
  .profile-card__actions { grid-column: 1 / -1; flex-direction: row; flex-wrap: wrap; }
  .profile-card__actions .btn { flex: 1 1 140px; }
}

/* --- 900 --- */
@media (max-width: 900px) {
  .nav {
    position: absolute;
    top: 100%;
    left: 0; right: 0;
    flex-direction: column;
    align-items: stretch;
    gap: 0;
    background: var(--paper);
    border-bottom: 1px solid var(--line);
    padding: 6px clamp(18px, 4vw, 48px) 14px;
    display: none;
    box-shadow: 0 24px 40px -34px rgba(35, 24, 18, .8);
  }
  .nav.is-open { display: flex; }
  .nav a {
    padding: 14px 0;
    border-bottom: 1px solid var(--line);
    font-size: .8rem;
  }
  .nav a::after { display: none; }
  .nav a.is-active { color: var(--rust); }
  .burger { display: grid; }
  .head__in { gap: 12px; }

  .hero__in { grid-template-columns: 1fr; gap: 10px; }
  .hero__art { min-height: 400px; order: 2; }
  .hero__card { width: min(320px, 74%); }
  .hero__lead { max-width: 46ch; }
  .hero__meta { font-size: .7rem; }

  .about-teaser { grid-template-columns: 1fr; }
  .visit { grid-template-columns: 1fr; }
  .page-head__in { flex-direction: column; align-items: flex-start; gap: 18px; }
  .page-head__aside { max-width: 48ch; }
  .auth { grid-template-columns: 1fr; }
  .story { grid-template-columns: 1fr; }
  .story__aside { position: static; }
  .contacts-grid { grid-template-columns: 1fr; }
  .foot__top { grid-template-columns: 1fr; }
  .section__head { flex-direction: column; align-items: flex-start; gap: 16px; }
  .admin-head { align-items: flex-start; }
  .admin-user { text-align: left; }
}

/* --- 640 --- */
@media (max-width: 640px) {
  body { font-size: 15.5px; }
  .cart-pill__label { display: none; }
  .cart-pill { padding: 0 6px 0 12px; gap: 6px; }
  .brand__sub { display: none; }

  .hero__in { padding-block: 30px 48px; }
  .hero__actions { gap: 14px; }
  .hero__actions .btn { flex: 1 1 100%; }
  .hero__meta { flex-direction: column; align-items: flex-start; gap: 8px; }
  .hero__meta li + li::before { display: none; }
  .hero__art { min-height: 350px; }
  .stamp { right: -2%; bottom: 8%; width: 98px; height: 98px; font-size: .52rem; }

  .grid--3, .grid--2 { grid-template-columns: 1fr; }
  .form__grid { grid-template-columns: 1fr; }
  .timeline, .values, .team { grid-template-columns: 1fr; }
  .toolbar { position: static; }
  .toolbar__in { padding-block: 12px; }
  .search { max-width: none; }
  .toolbar__count { width: 100%; margin-left: 0; }
  .pills { width: 100%; }
  .pill { height: 36px; padding: 0 13px; font-size: .7rem; }

  .cart-item { grid-template-columns: 64px minmax(0, 1fr); }
  .cart-item__thumb { width: 64px; }
  .cart-item__side {
    grid-column: 1 / -1;
    flex-direction: row;
    align-items: center;
    justify-content: space-between;
  }
  .cart-item__price { font-size: 1.15rem; }

  .info-row { grid-template-columns: 1fr; gap: 4px; }
  .contact-row { grid-template-columns: 1fr; gap: 4px; }
  .contact-row dt { padding-top: 0; }

  .quote p { font-size: 1.3rem; }
  .foot__cols { grid-template-columns: 1fr 1fr; }
  .foot__bottom { flex-direction: column; align-items: flex-start; }

  .modal__panel { padding: 24px 18px; }
  .toasts { left: 12px; bottom: 12px; }

  .admin-stats { grid-template-columns: repeat(2, minmax(0, 1fr)); }
  .admin-stat { padding: 14px 16px; }

  .table { min-width: 540px; }
  .message-card { grid-template-columns: 1fr; gap: 6px; }
}
