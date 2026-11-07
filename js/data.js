/* ============================================================
   Хлопчик — данные каталога
   ------------------------------------------------------------
   Товары хранятся в формате JSON. Это базовая коллекция:
   изменения из админ-панели сохраняются в localStorage
   и перекрывают её, не изменяя файл.
   ============================================================ */
window.HLOPCHIK = window.HLOPCHIK || {};

window.HLOPCHIK.categories = [
  { id: 'coffee',    title: 'Кофе' },
  { id: 'desserts',  title: 'Десерты' },
  { id: 'breakfast', title: 'Завтраки' }
];

window.HLOPCHIK.products = [
  {
    id: 'espresso',
    category: 'coffee',
    title: 'Эспрессо «Хлопчик»',
    description: 'Плотный, с нотами тёмного шоколада и вишни. Наш бленд: 70% бразильской арабики, 30% робусты.',
    price: 180,
    image: 'images/menu/espresso.jpg',
    badge: 'наш бленд',
  },
  {
    id: 'cappuccino',
    category: 'coffee',
    title: 'Капучино',
    description: 'Бархатная молочная пенка, мягкая горчинка и вкус, который держится до последнего глотка.',
    price: 260,
    image: 'images/menu/cappuccino.jpg',
    badge: null,
  },
  {
    id: 'latte-coconut',
    category: 'coffee',
    title: 'Латте на кокосовом',
    description: 'Кокосовое молоко, светлая обжарка и капля ванили. Для тех, кто не пьёт коровье.',
    price: 320,
    image: 'images/menu/latte-coconut.jpg',
    badge: null,
  },
  {
    id: 'raf-vanilla',
    category: 'coffee',
    title: 'Раф ванильный',
    description: 'Сливки, ваниль и щепотка соли. Взбиваем вручную — поэтому он такой бархатный.',
    price: 340,
    image: 'images/menu/raf-vanilla.jpg',
    badge: 'берут чаще всего',
  },
  {
    id: 'filter-ethiopia',
    category: 'coffee',
    title: 'Фильтр Эфиопия',
    description: 'Светлая обжарка: жасмин, персик и чайная терпкость. Завариваем в воронке V60.',
    price: 290,
    image: 'images/menu/filter-ethiopia.jpg',
    badge: null,
  },
  {
    id: 'croissant-almond',
    category: 'desserts',
    title: 'Круассан с миндалём',
    description: 'Печём к семи утра. Слоистый, с миндальным кремом и лепестками миндаля.',
    price: 240,
    image: 'images/menu/croissant-almond.jpg',
    badge: 'свежее',
  },
  {
    id: 'cheesecake-seabuckthorn',
    category: 'desserts',
    title: 'Чизкейк с облепихой',
    description: 'Нежный сырный крем, песочная основа и кисло-сладкая облепиха.',
    price: 320,
    image: 'images/menu/cheesecake-seabuckthorn.jpg',
    badge: null,
  },
  {
    id: 'cinnamon-roll',
    category: 'desserts',
    title: 'Синнабон',
    description: 'Мягкая булочка с корицей, сливочной глазурью и очень щедрой порцией корицы.',
    price: 280,
    image: 'images/menu/cinnamon-roll.jpg',
    badge: null,
  },
  {
    id: 'avocado-toast',
    category: 'breakfast',
    title: 'Тост с авокадо',
    description: 'Ржаной хлеб, авокадо, яйцо пашот и семена чиа. Подаём до полудня.',
    price: 420,
    image: 'images/menu/avocado-toast.jpg',
    badge: null,
  },
  {
    id: 'omelette-tomato',
    category: 'breakfast',
    title: 'Омлет с томатами',
    description: 'Три яйца, сливки, черри и зелёное масло. Со свежим хлебом из нашей пекарни.',
    price: 390,
    image: 'images/menu/omelette-tomato.jpg',
    badge: null,
  },
  {
    id: 'granola-berries',
    category: 'breakfast',
    title: 'Гранола с ягодами',
    description: 'Домашняя гранола, греческий йогурт и сезонные ягоды. Лёгкое начало дня.',
    price: 350,
    image: 'images/menu/granola-berries.jpg',
    badge: null,
  }
];
