/* ============================================================
   Хлопчик — слой хранения
   ------------------------------------------------------------
   Имитация серверной части: корзина, пользователи, заказы,
   сообщения и каталог живут в localStorage.
   Пароли не хранятся в открытом виде — только соль и хеш
   (учебная имитация, не криптостойкая защита).
   ============================================================ */
(function () {
  'use strict';

  var KEYS = {
    cart:     'hlopchik.cart.v1',
    users:    'hlopchik.users.v1',
    session:  'hlopchik.session.v1',
    orders:   'hlopchik.orders.v1',
    messages: 'hlopchik.messages.v1',
    products: 'hlopchik.products.v1',
    seeded:   'hlopchik.seeded.v1'
  };

  var DELIVERY_FEE = 199;
  var FREE_DELIVERY_FROM = 1500;

  var BASE_PRODUCTS = (window.HLOPCHIK && window.HLOPCHIK.products) || [];
  var CATEGORIES = (window.HLOPCHIK && window.HLOPCHIK.categories) || [];

  /* ---------- низкоуровневые операции ---------------------------- */

  function read(key, fallback) {
    try {
      var raw = window.localStorage.getItem(key);
      return raw ? JSON.parse(raw) : fallback;
    } catch (err) {
      return fallback;
    }
  }

  function write(key, value) {
    try {
      window.localStorage.setItem(key, JSON.stringify(value));
      return true;
    } catch (err) {
      return false;
    }
  }

  function uid(prefix) {
    return prefix + '_' + Date.now().toString(36) + Math.random().toString(36).slice(2, 7);
  }

  function clone(value) {
    return JSON.parse(JSON.stringify(value));
  }

  /* ---------- «хеширование» пароля ------------------------------- */

  function hashPassword(password, salt) {
    var source = salt + '::' + password + '::hlopchik';
    var h1 = 2166136261;
    var h2 = 5381;
    for (var i = 0; i < source.length; i++) {
      var code = source.charCodeAt(i);
      h1 ^= code;
      h1 = Math.imul(h1, 16777619);
      h2 = (Math.imul(h2, 33) + code) | 0;
    }
    return (h1 >>> 0).toString(16) + (h2 >>> 0).toString(16);
  }

  function makeSalt() {
    return Math.random().toString(36).slice(2, 10) + Date.now().toString(36);
  }

  function publicUser(user) {
    if (!user) return null;
    return {
      id: user.id,
      name: user.name,
      email: user.email,
      phone: user.phone,
      role: user.role,
      createdAt: user.createdAt
    };
  }

  /* ---------- корзина -------------------------------------------- */

  function rawCart() {
    var list = read(KEYS.cart, []);
    return Array.isArray(list) ? list : [];
  }

  function saveCart(list) {
    write(KEYS.cart, list);
  }

  /* ---------- имитация серверной части ---------------------------- */

  function seed() {
    if (read(KEYS.seeded, false)) return;

    var now = Date.now();
    var users = read(KEYS.users, []);
    if (!Array.isArray(users) || !users.length) {
      var demoSalt = makeSalt();
      var adminSalt = makeSalt();
      users = [
        {
          id: 'u_demo',
          name: 'Аня Соколова',
          email: 'demo@hlopchik.ru',
          phone: '+7 916 204-18-32',
          salt: demoSalt,
          hash: hashPassword('demo1234', demoSalt),
          role: 'customer',
          createdAt: new Date(now - 1000 * 60 * 60 * 24 * 120).toISOString()
        },
        {
          id: 'u_admin',
          name: 'Администратор',
          email: 'admin@hlopchik.ru',
          phone: '+7 495 120-14-14',
          salt: adminSalt,
          hash: hashPassword('admin1234', adminSalt),
          role: 'admin',
          createdAt: new Date(now - 1000 * 60 * 60 * 24 * 400).toISOString()
        }
      ];
      write(KEYS.users, users);
    }

    function find(id) {
      var list = read(KEYS.products, null) || BASE_PRODUCTS;
      for (var i = 0; i < list.length; i++) if (list[i].id === id) return list[i];
      return null;
    }

    function orderItems(pairs) {
      return pairs.map(function (pair) {
        var product = find(pair[0]);
        return {
          id: pair[0],
          title: product ? product.title : pair[0],
          price: product ? product.price : 0,
          qty: pair[1]
        };
      });
    }

    function build(number, daysAgo, pairs, status, method, payment, comment) {
      var items = orderItems(pairs);
      var subtotal = items.reduce(function (sum, item) { return sum + item.price * item.qty; }, 0);
      var delivery = method === 'pickup' ? 0 : (subtotal >= FREE_DELIVERY_FROM ? 0 : DELIVERY_FEE);
      return {
        id: 'o_' + number,
        number: number,
        userId: 'u_demo',
        customer: { name: 'Аня Соколова', phone: '+7 916 204-18-32', email: 'demo@hlopchik.ru' },
        items: items,
        subtotal: subtotal,
        delivery: delivery,
        total: subtotal + delivery,
        method: method,
        address: method === 'pickup' ? '' : 'Сергиев Посад, пр. Красной Армии, 12, кв. 27',
        comment: comment || '',
        payment: payment,
        status: status,
        createdAt: new Date(now - daysAgo * 86400000).toISOString()
      };
    }

    var orders = read(KEYS.orders, []);
    if (!Array.isArray(orders) || !orders.length) {
      write(KEYS.orders, [
        build(1042, 2, [['latte-coconut', 1], ['cheesecake-seabuckthorn', 1]], 'ready', 'pickup', 'card', 'Позвонить за 10 минут'),
        build(1041, 18, [['cappuccino', 2], ['croissant-almond', 2]], 'done', 'delivery', 'cash', '')
      ]);
    }

    var messages = read(KEYS.messages, []);
    if (!Array.isArray(messages) || !messages.length) {
      write(KEYS.messages, [
        {
          id: uid('m'),
          name: 'Марина',
          email: 'marina.k@example.com',
          topic: 'Вопрос по заказу',
          text: 'Добрый день! Можно ли забрать заказ не в 9:00, а в 8:30? Очень нужно успеть на поезд.',
          createdAt: new Date(now - 1000 * 60 * 60 * 26).toISOString(),
          read: false
        }
      ]);
    }

    write(KEYS.seeded, true);
  }

  /* ---------- публичный интерфейс -------------------------------- */

  var Store = {

    /* --- каталог --- */
    categories: CATEGORIES,

    categoryTitle: function (id) {
      for (var i = 0; i < CATEGORIES.length; i++) {
        if (CATEGORIES[i].id === id) return CATEGORIES[i].title;
      }
      return 'Меню';
    },

    getProducts: function () {
      var saved = read(KEYS.products, null);
      if (Array.isArray(saved) && saved.length) return clone(saved);
      return clone(BASE_PRODUCTS);
    },

    getProduct: function (id) {
      return Store.getProducts().filter(function (p) { return p.id === id; })[0] || null;
    },

    saveProducts: function (list) {
      write(KEYS.products, list);
    },

    resetProducts: function () {
      try { window.localStorage.removeItem(KEYS.products); } catch (err) {}
    },

    /* --- корзина --- */
    getCart: function () {
      var products = Store.getProducts();
      var map = {};
      products.forEach(function (p) { map[p.id] = p; });
      return rawCart()
        .filter(function (line) { return map[line.id] && line.qty > 0; })
        .map(function (line) { return { id: line.id, qty: Math.min(20, line.qty) }; });
    },

    addToCart: function (id, qty) {
      if (!Store.getProduct(id)) return false;
      var amount = Math.max(1, Number(qty) || 1);
      var list = Store.getCart();
      var found = null;
      for (var i = 0; i < list.length; i++) if (list[i].id === id) found = list[i];
      if (found) {
        found.qty = Math.min(20, found.qty + amount);
      } else {
        list.push({ id: id, qty: Math.min(20, amount) });
      }
      saveCart(list);
      return true;
    },

    setQty: function (id, qty) {
      var list = Store.getCart();
      if (Number(qty) <= 0) {
        list = list.filter(function (line) { return line.id !== id; });
      } else {
        list.forEach(function (line) {
          if (line.id === id) line.qty = Math.min(20, Number(qty));
        });
      }
      saveCart(list);
    },

    removeFromCart: function (id) {
      saveCart(Store.getCart().filter(function (line) { return line.id !== id; }));
    },

    clearCart: function () {
      saveCart([]);
    },

    cartItems: function () {
      var products = Store.getProducts();
      var map = {};
      products.forEach(function (p) { map[p.id] = p; });
      return Store.getCart().map(function (line) {
        var item = clone(map[line.id]);
        item.qty = line.qty;
        return item;
      });
    },

    cartCount: function () {
      return Store.getCart().reduce(function (sum, line) { return sum + line.qty; }, 0);
    },

    subtotal: function () {
      return Store.cartItems().reduce(function (sum, item) { return sum + item.price * item.qty; }, 0);
    },

    deliveryFee: function (method) {
      if (method === 'pickup') return 0;
      var sum = Store.subtotal();
      if (!sum) return 0;
      return sum >= FREE_DELIVERY_FROM ? 0 : DELIVERY_FEE;
    },

    total: function (method) {
      return Store.subtotal() + Store.deliveryFee(method);
    },

    freeDeliveryFrom: FREE_DELIVERY_FROM,
    deliveryPrice: DELIVERY_FEE,

    /* --- пользователи --- */
    register: function (data) {
      var users = read(KEYS.users, []);
      var email = String(data.email || '').trim().toLowerCase();
      var exists = users.some(function (u) { return u.email === email; });
      if (exists) throw new Error('Пользователь с таким e-mail уже зарегистрирован.');
      var salt = makeSalt();
      var user = {
        id: uid('u'),
        name: String(data.name || '').trim(),
        email: email,
        phone: String(data.phone || '').trim(),
        salt: salt,
        hash: hashPassword(data.password, salt),
        role: 'customer',
        createdAt: new Date().toISOString()
      };
      users.push(user);
      write(KEYS.users, users);
      write(KEYS.session, { userId: user.id });
      return publicUser(user);
    },

    login: function (email, password) {
      var users = read(KEYS.users, []);
      var normalized = String(email || '').trim().toLowerCase();
      var user = users.filter(function (u) { return u.email === normalized; })[0];
      if (!user) throw new Error('Такого пользователя нет. Проверьте e-mail.');
      if (hashPassword(password, user.salt) !== user.hash) {
        throw new Error('Неверный пароль. Попробуйте ещё раз.');
      }
      write(KEYS.session, { userId: user.id });
      return publicUser(user);
    },

    logout: function () {
      try { window.localStorage.removeItem(KEYS.session); } catch (err) {}
    },

    currentUser: function () {
      var session = read(KEYS.session, null);
      if (!session || !session.userId) return null;
      var users = read(KEYS.users, []);
      return publicUser(users.filter(function (u) { return u.id === session.userId; })[0] || null);
    },

    updateProfile: function (patch) {
      var user = Store.currentUser();
      if (!user) throw new Error('Нужно войти в аккаунт.');
      var users = read(KEYS.users, []);
      var target = null;
      users.forEach(function (u) { if (u.id === user.id) target = u; });
      if (!target) throw new Error('Пользователь не найден.');
      if (patch.name !== undefined) target.name = String(patch.name).trim();
      if (patch.phone !== undefined) target.phone = String(patch.phone).trim();
      if (patch.email !== undefined) {
        var email = String(patch.email).trim().toLowerCase();
        var busy = users.some(function (u) { return u.email === email && u.id !== target.id; });
        if (busy) throw new Error('Этот e-mail уже занят.');
        target.email = email;
      }
      write(KEYS.users, users);
      return publicUser(target);
    },

    /* --- заказы --- */
    createOrder: function (data) {
      var items = Store.cartItems().map(function (item) {
        return { id: item.id, title: item.title, price: item.price, qty: item.qty };
      });
      if (!items.length) throw new Error('Корзина пуста.');

      var orders = read(KEYS.orders, []);
      var subtotal = items.reduce(function (sum, item) { return sum + item.price * item.qty; }, 0);
      var method = data.method === 'pickup' ? 'pickup' : 'delivery';
      var delivery = method === 'pickup' ? 0 : (subtotal >= FREE_DELIVERY_FROM ? 0 : DELIVERY_FEE);
      var user = Store.currentUser();
      var number = 1000 + orders.length + 1;
      var order = {
        id: uid('o'),
        number: number,
        userId: user ? user.id : null,
        customer: {
          name: data.name,
          phone: data.phone,
          email: data.email
        },
        items: items,
        subtotal: subtotal,
        delivery: delivery,
        total: subtotal + delivery,
        method: method,
        address: method === 'pickup' ? '' : (data.address || ''),
        comment: data.comment || '',
        payment: data.payment || 'cash',
        status: 'new',
        createdAt: new Date().toISOString()
      };
      orders.push(order);
      write(KEYS.orders, orders);
      Store.clearCart();
      return order;
    },

    getOrders: function (userId) {
      var orders = read(KEYS.orders, []);
      if (userId) orders = orders.filter(function (o) { return o.userId === userId; });
      return orders.slice().sort(function (a, b) {
        return new Date(b.createdAt) - new Date(a.createdAt);
      });
    },

    updateOrderStatus: function (id, status) {
      var orders = read(KEYS.orders, []);
      orders.forEach(function (o) { if (o.id === id) o.status = status; });
      write(KEYS.orders, orders);
    },

    statusTitle: function (status) {
      var titles = {
        new: 'Новый',
        cooking: 'Готовится',
        ready: 'Готов',
        done: 'Выдан',
        canceled: 'Отменён'
      };
      return titles[status] || 'Новый';
    },

    /* --- сообщения --- */
    addMessage: function (data) {
      var messages = read(KEYS.messages, []);
      var message = {
        id: uid('m'),
        name: data.name,
        email: data.email,
        topic: data.topic || 'Другое',
        text: data.text,
        createdAt: new Date().toISOString(),
        read: false
      };
      messages.push(message);
      write(KEYS.messages, messages);
      return message;
    },

    getMessages: function () {
      return read(KEYS.messages, []).slice().sort(function (a, b) {
        return new Date(b.createdAt) - new Date(a.createdAt);
      });
    },

    markMessageRead: function (id) {
      var messages = read(KEYS.messages, []);
      messages.forEach(function (m) { if (m.id === id) m.read = true; });
      write(KEYS.messages, messages);
    },

    /* --- утилиты --- */
    money: function (value) {
      return new Intl.NumberFormat('ru-RU').format(Math.round(Number(value) || 0)) + ' \u20BD';
    },

    date: function (iso) {
      var date = new Date(iso);
      return new Intl.DateTimeFormat('ru-RU', {
        day: '2-digit', month: '2-digit', year: 'numeric',
        hour: '2-digit', minute: '2-digit'
      }).format(date);
    },

    ensureSeed: seed
  };

  window.Store = Store;
})();
