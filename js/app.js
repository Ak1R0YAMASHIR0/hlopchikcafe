/* ============================================================
   Хлопчик — интерфейс и логика страниц
   ------------------------------------------------------------
   Один файл на все страницы: нужный модуль включается по
   атрибуту data-page у <body>.
   ============================================================ */
(function () {
  'use strict';

  Store.ensureSeed();

  var $ = function (selector, root) { return (root || document).querySelector(selector); };
  var $$ = function (selector, root) {
    return Array.prototype.slice.call((root || document).querySelectorAll(selector));
  };

  /* ---------- мелкие помощники -------------------------------- */

  function esc(value) {
    return String(value == null ? '' : value)
      .replace(/&/g, '&amp;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;')
      .replace(/"/g, '&quot;')
      .replace(/'/g, '&#39;');
  }

  function money(value) { return Store.money(value); }

  function plural(number, forms) {
    var n = Math.abs(number) % 100;
    var n1 = n % 10;
    if (n > 10 && n < 20) return forms[2];
    if (n1 > 1 && n1 < 5) return forms[1];
    if (n1 === 1) return forms[0];
    return forms[2];
  }

  var PLACEHOLDER_IMAGE = 'images/menu/placeholder.jpg';

  /* старые товары из localStorage могли хранить только art-символ */
  var ART_IMAGES = {
    'art-espresso': 'images/menu/espresso.jpg',
    'art-cappuccino': 'images/menu/cappuccino.jpg',
    'art-latte': 'images/menu/latte-coconut.jpg',
    'art-raf': 'images/menu/raf-vanilla.jpg',
    'art-filter': 'images/menu/filter-ethiopia.jpg',
    'art-croissant': 'images/menu/croissant-almond.jpg',
    'art-cheesecake': 'images/menu/cheesecake-seabuckthorn.jpg',
    'art-cinnamon': 'images/menu/cinnamon-roll.jpg',
    'art-toast': 'images/menu/avocado-toast.jpg',
    'art-omelette': 'images/menu/omelette-tomato.jpg',
    'art-granola': 'images/menu/granola-berries.jpg'
  };

  function imageMarkup(product) {
    var src = product.image || ART_IMAGES[product.art] || PLACEHOLDER_IMAGE;
    return '<img src="' + esc(src) + '" alt="' + esc(product.title) + '" loading="lazy" ' +
      'onerror="this.onerror=null;this.src=\'' + PLACEHOLDER_IMAGE + '\'">';
  }

  function toast(message, tone) {
    var box = $('#toasts');
    if (!box) return;
    var el = document.createElement('div');
    el.className = 'toast' + (tone ? ' toast--' + tone : '');
    el.textContent = message;
    box.appendChild(el);
    window.setTimeout(function () {
      el.classList.add('is-out');
      window.setTimeout(function () { el.remove(); }, 280);
    }, 3800);
  }

  function refreshCartBadge(bump) {
    var count = Store.cartCount();
    $$('[data-cart-count]').forEach(function (el) {
      el.textContent = count;
      if (bump) {
        el.classList.remove('is-bump');
        void el.offsetWidth;
        el.classList.add('is-bump');
      }
    });
  }

  /* ---------- модальные окна ---------------------------------- */

  var lastFocused = null;

  function openModal(selector) {
    var modal = $(selector);
    if (!modal) return;
    lastFocused = document.activeElement;
    modal.classList.add('is-open');
    modal.setAttribute('aria-hidden', 'false');
    document.body.classList.add('is-locked');
    var target = modal.querySelector('input:not([type="hidden"]), select, textarea');
    if (!target) target = modal.querySelector('button');
    if (target) window.setTimeout(function () { target.focus(); }, 80);
  }

  function closeModal(modal) {
    if (!modal) return;
    modal.classList.remove('is-open');
    modal.setAttribute('aria-hidden', 'true');
    if (!$('.modal.is-open')) document.body.classList.remove('is-locked');
    if (lastFocused && typeof lastFocused.focus === 'function') lastFocused.focus();
  }

  document.addEventListener('click', function (event) {
    var closer = event.target.closest('[data-close]');
    if (!closer) return;
    closeModal(closer.closest('.modal'));
  });

  document.addEventListener('keydown', function (event) {
    if (event.key === 'Escape') {
      $$('.modal.is-open').forEach(closeModal);
    }
  });

  /* ---------- валидация форм ---------------------------------- */

  var EMAIL_RE = /^[^\s@]+@[^\s@]+\.[a-zA-Zа-яА-Я]{2,}$/;

  function isEmail(value) { return EMAIL_RE.test(String(value).trim()); }

  function isPhone(value) {
    return String(value).replace(/\D/g, '').length >= 10;
  }

  function fieldOf(form, name) { return form.querySelector('[data-field="' + name + '"]'); }

  function setFieldError(form, name, message) {
    var field = fieldOf(form, name);
    if (!field) return;
    field.classList.toggle('is-invalid', Boolean(message));
    var err = field.querySelector('.field__err');
    if (err) err.textContent = message || '';
    var control = field.querySelector('.input, .select, .textarea');
    if (control) control.setAttribute('aria-invalid', message ? 'true' : 'false');
  }

  function clearErrors(form) {
    $$('[data-field]', form).forEach(function (field) {
      field.classList.remove('is-invalid');
      var err = field.querySelector('.field__err');
      if (err) err.textContent = '';
      var control = field.querySelector('.input, .select, .textarea');
      if (control) control.removeAttribute('aria-invalid');
    });
    var alert = form.querySelector('.alert');
    if (alert) {
      alert.classList.remove('is-visible');
      alert.textContent = '';
    }
  }

  function showAlert(form, message) {
    var alert = form.querySelector('.alert');
    if (!alert) { toast(message, 'err'); return; }
    alert.textContent = message;
    alert.classList.add('is-visible');
  }

  function focusFirstInvalid(form) {
    var field = form.querySelector('.field.is-invalid .input, .field.is-invalid .select, .field.is-invalid .textarea');
    if (field) field.focus();
  }

  /* ---------- шапка ------------------------------------------- */

  function initHead() {
    var nav = $('#nav');
    var burger = $('#burger');

    if (nav && burger) {
      burger.addEventListener('click', function () {
        var open = nav.classList.toggle('is-open');
        burger.setAttribute('aria-expanded', open ? 'true' : 'false');
        burger.setAttribute('aria-label', open ? 'Закрыть меню' : 'Открыть меню');
      });
      $$('a', nav).forEach(function (link) {
        link.addEventListener('click', function () {
          nav.classList.remove('is-open');
          burger.setAttribute('aria-expanded', 'false');
        });
      });
    }

    var page = document.body.dataset.page;
    $$('[data-nav]').forEach(function (link) {
      if (link.dataset.nav === page) {
        link.classList.add('is-active');
        link.setAttribute('aria-current', 'page');
      }
    });

    var head = $('#head');
    if (head) {
      var onScroll = function () {
        head.classList.toggle('is-scrolled', window.scrollY > 10);
      };
      window.addEventListener('scroll', onScroll, { passive: true });
      onScroll();
    }
  }

  /* ---------- появление блоков -------------------------------- */

  var revealObserver = null;

  function initReveal() {
    if (!('IntersectionObserver' in window)) {
      $$('.reveal').forEach(function (el) { el.classList.add('is-in'); });
      return;
    }
    revealObserver = new IntersectionObserver(function (entries) {
      entries.forEach(function (entry) {
        if (!entry.isIntersecting) return;
        entry.target.classList.add('is-in');
        revealObserver.unobserve(entry.target);
      });
    }, { rootMargin: '0px 0px -8% 0px', threshold: 0.06 });
  }

  function observeReveals() {
    if (!revealObserver) return;
    $$('.reveal:not(.is-in)').forEach(function (el, index) {
      el.style.transitionDelay = Math.min(index % 4, 3) * 70 + 'ms';
      revealObserver.observe(el);
    });
  }

  /* ---------- карточка товара --------------------------------- */

  function cardHTML(product, index) {
    return '' +
      '<article class="card reveal">' +
        '<div class="card__art">' +
          '<span class="card__num">' + String(index + 1).padStart(2, '0') + '</span>' +
          (product.badge ? '<span class="card__badge">' + esc(product.badge) + '</span>' : '') +
          imageMarkup(product) +
        '</div>' +
        '<div class="card__body">' +
          '<span class="card__cat">' + esc(Store.categoryTitle(product.category)) + '</span>' +
          '<h3 class="card__title">' + esc(product.title) + '</h3>' +
          '<p class="card__desc">' + esc(product.description) + '</p>' +
          '<div class="card__foot">' +
            '<span class="card__price">' + money(product.price) + '</span>' +
            '<button class="btn btn--ghost btn--sm" type="button" data-add="' + esc(product.id) + '">В корзину</button>' +
          '</div>' +
        '</div>' +
      '</article>';
  }

  /* ---------- добавление в корзину ---------------------------- */

  function initCartInteractions() {
    document.addEventListener('click', function (event) {
      var button = event.target.closest('[data-add]');
      if (!button) return;

      var id = button.dataset.add;
      var product = Store.getProduct(id);
      if (!product) return;

      Store.addToCart(id, 1);
      refreshCartBadge(true);
      toast(product.title + ' — в корзине');

      if (button.dataset.label === undefined) button.dataset.label = button.textContent;
      button.textContent = 'Добавлено';
      window.clearTimeout(button._timer);
      button._timer = window.setTimeout(function () {
        button.textContent = button.dataset.label;
      }, 1300);
    });
  }

  /* ---------- главная ----------------------------------------- */

  function initHome() {
    var box = $('#featured');
    if (!box) return;

    var all = Store.getProducts();
    var wanted = ['cappuccino', 'croissant-almond', 'filter-ethiopia'];
    var list = wanted.map(function (id) {
      return all.filter(function (p) { return p.id === id; })[0];
    }).filter(Boolean);

    if (list.length < 3) list = all.slice(0, 3);

    box.innerHTML = list.map(function (product, index) {
      return cardHTML(product, index);
    }).join('');

    observeReveals();
  }

  /* ---------- меню -------------------------------------------- */

  function initMenu() {
    var grid = $('#menu-grid');
    if (!grid) return;

    var filters = $('#menu-filters');
    var search = $('#menu-search');
    var countEl = $('#menu-count');
    var empty = $('#menu-empty');

    var state = {
      cat: 'all',
      query: ''
    };

    var hash = window.location.hash.replace('#', '');
    var validCats = Store.categories.map(function (c) { return c.id; });
    if (hash && validCats.indexOf(hash) !== -1) state.cat = hash;

    function renderPills() {
      var all = Store.getProducts();
      var items = [{ id: 'all', title: 'Всё' }].concat(Store.categories);

      filters.innerHTML = items.map(function (cat) {
        var count = cat.id === 'all'
          ? all.length
          : all.filter(function (p) { return p.category === cat.id; }).length;
        return '<button class="pill" type="button" data-cat="' + esc(cat.id) + '" aria-pressed="' +
          (state.cat === cat.id ? 'true' : 'false') + '">' + esc(cat.title) +
          ' <i>' + count + '</i></button>';
      }).join('');
    }

    function render() {
      var all = Store.getProducts();
      var query = state.query.trim().toLowerCase();
      var list = all.filter(function (product) {
        var byCat = state.cat === 'all' || product.category === state.cat;
        var byQuery = !query || product.title.toLowerCase().indexOf(query) !== -1;
        return byCat && byQuery;
      });

      grid.innerHTML = list.map(function (product) {
        return cardHTML(product, all.indexOf(product));
      }).join('');

      empty.hidden = list.length > 0;
      grid.hidden = list.length === 0;
      countEl.textContent = list.length + ' ' + plural(list.length, ['позиция', 'позиции', 'позиций']);

      renderPills();
      observeReveals();
    }

    if (filters) {
      filters.addEventListener('click', function (event) {
        var pill = event.target.closest('[data-cat]');
        if (!pill) return;
        state.cat = pill.dataset.cat;
        render();
      });
    }

    if (search) {
      search.addEventListener('input', function () {
        state.query = search.value;
        render();
      });
    }

    var reset = $('#menu-reset');
    if (reset) {
      reset.addEventListener('click', function () {
        state.cat = 'all';
        state.query = '';
        if (search) search.value = '';
        render();
      });
    }

    render();
  }

  /* ---------- корзина ----------------------------------------- */

  function cartItemHTML(item) {
    return '' +
      '<div class="cart-item" data-id="' + esc(item.id) + '">' +
        '<div class="cart-item__thumb">' + imageMarkup(item) + '</div>' +
        '<div>' +
          '<h3 class="cart-item__title">' + esc(item.title) + '</h3>' +
          '<p class="cart-item__meta">' + esc(Store.categoryTitle(item.category)) + ' · ' +
            money(item.price) + ' за порцию</p>' +
        '</div>' +
        '<div class="cart-item__side">' +
          '<div class="stepper">' +
            '<button type="button" data-dec aria-label="Уменьшить количество">−</button>' +
            '<span>' + item.qty + '</span>' +
            '<button type="button" data-inc aria-label="Увеличить количество">+</button>' +
          '</div>' +
          '<span class="cart-item__price">' + money(item.price * item.qty) + '</span>' +
          '<button type="button" class="text-btn" data-remove>Удалить</button>' +
        '</div>' +
      '</div>';
  }

  function initCart() {
    var listEl = $('#cart-list');
    if (!listEl) return;

    var layout = $('#cart-layout');
    var emptyEl = $('#cart-empty');
    var state = { method: 'delivery' };

    function updateSummary() {
      var subtotal = Store.subtotal();
      var fee = Store.deliveryFee(state.method);
      var total = subtotal + fee;

      $('#sum-subtotal').textContent = money(subtotal);
      $('#sum-delivery-label').textContent = state.method === 'pickup' ? 'Самовывоз' : 'Доставка';
      $('#sum-delivery').textContent = fee ? money(fee) : 'бесплатно';
      $('#sum-total').textContent = money(total);
      $('#checkout-total').textContent = money(total);
      $('#checkout-method').textContent = state.method === 'pickup' ? 'самовывоз' : 'доставка';

      var note = $('#summary-note');
      if (state.method === 'pickup') {
        note.textContent = 'Самовывоз с пр. Красной Армии, 12. Соберём заказ к указанному времени.';
      } else {
        var left = Store.freeDeliveryFrom - subtotal;
        note.textContent = left > 0
          ? 'До бесплатной доставки — ' + money(left) + '. Или выберите самовывоз.'
          : 'Доставка бесплатная. Оплата при получении или картой на месте.';
      }
    }

    function render() {
      var items = Store.cartItems();

      if (!items.length) {
        layout.hidden = true;
        emptyEl.hidden = false;
        return;
      }

      layout.hidden = false;
      emptyEl.hidden = true;
      listEl.innerHTML = items.map(cartItemHTML).join('');
      updateSummary();
    }

    listEl.addEventListener('click', function (event) {
      var row = event.target.closest('.cart-item');
      if (!row) return;
      var id = row.dataset.id;
      var item = Store.cartItems().filter(function (p) { return p.id === id; })[0];
      if (!item) return;

      if (event.target.closest('[data-inc]')) {
        Store.setQty(id, item.qty + 1);
      } else if (event.target.closest('[data-dec]')) {
        Store.setQty(id, item.qty - 1);
      } else if (event.target.closest('[data-remove]')) {
        Store.removeFromCart(id);
        toast(item.title + ' убран из корзины');
      } else {
        return;
      }

      render();
      refreshCartBadge();
    });

    $$('input[name="method"]').forEach(function (radio) {
      radio.addEventListener('change', function () {
        state.method = radio.value;
        updateSummary();
      });
    });

    var openCheckout = $('#checkout-open');
    if (openCheckout) {
      openCheckout.addEventListener('click', function () {
        if (!Store.cartItems().length) {
          toast('Корзина пуста — добавьте что-нибудь из меню', 'err');
          return;
        }

        var form = $('#checkout-form');
        form.reset();
        clearErrors(form);
        $('#checkout-wrap').hidden = false;
        $('#checkout-done').hidden = true;

        var user = Store.currentUser();
        if (user) {
          $('#co-name').value = user.name;
          $('#co-email').value = user.email;
          $('#co-phone').value = user.phone;
        }

        $('#co-address-field').hidden = state.method === 'pickup';
        updateSummary();
        openModal('#checkout');
      });
    }

    var checkoutForm = $('#checkout-form');
    if (checkoutForm) {
      checkoutForm.addEventListener('submit', function (event) {
        event.preventDefault();
        clearErrors(checkoutForm);

        var data = {
          name: $('#co-name').value.trim(),
          phone: $('#co-phone').value.trim(),
          email: $('#co-email').value.trim(),
          address: $('#co-address').value.trim(),
          comment: $('#co-comment').value.trim(),
          payment: $('#co-payment').value
        };

        var ok = true;

        if (data.name.length < 2) {
          setFieldError(checkoutForm, 'name', 'Как к вам обращаться? Хотя бы два символа.');
          ok = false;
        }
        if (!isPhone(data.phone)) {
          setFieldError(checkoutForm, 'phone', 'Номер не похож на телефон — нужно 10–11 цифр.');
          ok = false;
        }
        if (!isEmail(data.email)) {
          setFieldError(checkoutForm, 'email', 'Проверьте e-mail: без него не отправим чек.');
          ok = false;
        }
        if (state.method === 'delivery' && data.address.length < 5) {
          setFieldError(checkoutForm, 'address', 'Куда везти? Укажите улицу, дом и квартиру.');
          ok = false;
        }

        if (!ok) {
          showAlert(checkoutForm, 'Кажется, в форме есть неточности — проверьте подсвеченные поля.');
          focusFirstInvalid(checkoutForm);
          return;
        }

        try {
          var order = Store.createOrder({
            name: data.name,
            phone: data.phone,
            email: data.email,
            address: data.address,
            comment: data.comment,
            payment: data.payment,
            method: state.method
          });

          $('#order-number').textContent = '#' + order.number;
          $('#checkout-wrap').hidden = true;
          $('#checkout-done').hidden = false;
          refreshCartBadge();
          render();
          toast('Заказ #' + order.number + ' принят — спасибо!', 'ok');
        } catch (error) {
          showAlert(checkoutForm, error.message);
        }
      });
    }

    render();
  }

  /* ---------- личный кабинет ---------------------------------- */

  function orderRows(orders) {
    return orders.map(function (order) {
      var items = order.items.map(function (item) {
        return esc(item.title) + ' ×' + item.qty;
      }).join('<br>');
      return '' +
        '<tr>' +
          '<td class="table__num">#' + order.number + '</td>' +
          '<td class="table__muted">' + Store.date(order.createdAt) + '</td>' +
          '<td>' + items + '</td>' +
          '<td class="table__sum">' + money(order.total) + '</td>' +
          '<td><span class="status status--' + esc(order.status) + '">' +
            esc(Store.statusTitle(order.status)) + '</span></td>' +
        '</tr>';
    }).join('');
  }

  function initAccount() {
    var auth = $('#auth');
    if (!auth) return;

    var profile = $('#profile');
    var head = $('#account-head');
    var ordersBody = $('#orders-body');
    var ordersWrap = $('#orders-wrap');
    var ordersEmpty = $('#orders-empty');

    /* вкладки вход / регистрация */
    var tabs = $$('.tab', auth);
    tabs.forEach(function (tab) {
      tab.addEventListener('click', function () {
        tabs.forEach(function (other) {
          var selected = other === tab;
          other.setAttribute('aria-selected', selected ? 'true' : 'false');
          var panel = $('#' + other.getAttribute('aria-controls'));
          if (panel) panel.hidden = !selected;
        });
      });
    });

    function render() {
      var user = Store.currentUser();

      if (!user) {
        auth.hidden = false;
        profile.hidden = true;
        head.hidden = true;
        return;
      }

      auth.hidden = true;
      profile.hidden = false;
      head.hidden = false;

      var firstName = user.name.trim().split(/\s+/)[0] || 'гость';
      $('#head-name').textContent = firstName;
      $('#profile-avatar').textContent = user.name.trim().charAt(0).toUpperCase() || '—';
      $('#profile-name').textContent = user.name;
      $('#profile-email').textContent = user.email;

      $('#info-name').textContent = user.name;
      $('#info-email').textContent = user.email;
      $('#info-phone').textContent = user.phone || '—';
      $('#info-created').textContent = new Date(user.createdAt).toLocaleDateString('ru-RU', {
        day: '2-digit', month: 'long', year: 'numeric'
      });

      var since = new Date(user.createdAt);
      var days = Math.max(1, Math.round((Date.now() - since.getTime()) / 86400000));
      $('#profile-since').textContent = 'с нами ' + days + ' ' + plural(days, ['день', 'дня', 'дней']);
      $('#profile-admin-link').hidden = user.role !== 'admin';

      $('#pf-name').value = user.name;
      $('#pf-phone').value = user.phone || '';
      $('#pf-email').value = user.email;
      $('#profile-form').hidden = true;
      $('#edit-toggle').hidden = false;

      var orders = Store.getOrders(user.id);
      ordersBody.innerHTML = orderRows(orders);
      ordersWrap.hidden = orders.length === 0;
      ordersEmpty.hidden = orders.length > 0;
    }

    /* вход */
    var loginForm = $('#login-form');
    if (loginForm) {
      loginForm.addEventListener('submit', function (event) {
        event.preventDefault();
        clearErrors(loginForm);

        var email = $('#login-email').value.trim();
        var password = $('#login-password').value;

        var ok = true;
        if (!isEmail(email)) {
          setFieldError(loginForm, 'email', 'Введите e-mail в формате you@example.com.');
          ok = false;
        }
        if (!password) {
          setFieldError(loginForm, 'password', 'Пароль не может быть пустым.');
          ok = false;
        }
        if (!ok) {
          focusFirstInvalid(loginForm);
          return;
        }

        try {
          var user = Store.login(email, password);
          loginForm.reset();
          toast('С возвращением, ' + user.name.split(' ')[0] + '!', 'ok');
          render();
          observeReveals();
        } catch (error) {
          showAlert(loginForm, error.message);
        }
      });
    }

    /* регистрация */
    var registerForm = $('#register-form');
    if (registerForm) {
      registerForm.addEventListener('submit', function (event) {
        event.preventDefault();
        clearErrors(registerForm);

        var data = {
          name: $('#reg-name').value.trim(),
          email: $('#reg-email').value.trim(),
          phone: $('#reg-phone').value.trim(),
          password: $('#reg-password').value,
          password2: $('#reg-password2').value
        };

        var ok = true;

        if (data.name.length < 2) {
          setFieldError(registerForm, 'name', 'Имя нужно, чтобы бариста знал, кого звать.');
          ok = false;
        }
        if (!isEmail(data.email)) {
          setFieldError(registerForm, 'email', 'Проверьте e-mail — на него придёт чек.');
          ok = false;
        }
        if (!isPhone(data.phone)) {
          setFieldError(registerForm, 'phone', 'Телефон должен содержать 10–11 цифр.');
          ok = false;
        }
        if (data.password.length < 6) {
          setFieldError(registerForm, 'password', 'Минимум 6 символов — так безопаснее.');
          ok = false;
        }
        if (data.password !== data.password2) {
          setFieldError(registerForm, 'password2', 'Пароли не совпадают.');
          ok = false;
        }

        if (!ok) {
          focusFirstInvalid(registerForm);
          return;
        }

        try {
          var user = Store.register({
            name: data.name,
            email: data.email,
            phone: data.phone,
            password: data.password
          });
          registerForm.reset();
          toast('Аккаунт создан. Добро пожаловать, ' + user.name.split(' ')[0] + '!', 'ok');
          render();
          observeReveals();
        } catch (error) {
          showAlert(registerForm, error.message);
        }
      });
    }

    /* редактирование профиля */
    var editToggle = $('#edit-toggle');
    var editCancel = $('#edit-cancel');
    var profileForm = $('#profile-form');

    if (editToggle && profileForm) {
      editToggle.addEventListener('click', function () {
        profileForm.hidden = false;
        editToggle.hidden = true;
        clearErrors(profileForm);
        $('#pf-name').focus();
      });
    }

    if (editCancel && profileForm) {
      editCancel.addEventListener('click', function () {
        profileForm.hidden = true;
        editToggle.hidden = false;
        render();
      });
    }

    if (profileForm) {
      profileForm.addEventListener('submit', function (event) {
        event.preventDefault();
        clearErrors(profileForm);

        var data = {
          name: $('#pf-name').value.trim(),
          phone: $('#pf-phone').value.trim(),
          email: $('#pf-email').value.trim()
        };

        var ok = true;
        if (data.name.length < 2) {
          setFieldError(profileForm, 'name', 'Имя не может быть короче двух символов.');
          ok = false;
        }
        if (!isPhone(data.phone)) {
          setFieldError(profileForm, 'phone', 'Телефон должен содержать 10–11 цифр.');
          ok = false;
        }
        if (!isEmail(data.email)) {
          setFieldError(profileForm, 'email', 'Проверьте e-mail.');
          ok = false;
        }

        if (!ok) {
          focusFirstInvalid(profileForm);
          return;
        }

        try {
          Store.updateProfile(data);
          toast('Данные сохранены', 'ok');
          render();
        } catch (error) {
          showAlert(profileForm, error.message);
        }
      });
    }

    /* выход */
    var logout = $('#logout-btn');
    if (logout) {
      logout.addEventListener('click', function () {
        Store.logout();
        toast('Вы вышли из аккаунта');
        render();
      });
    }

    render();
  }

  /* ---------- обратная связь ---------------------------------- */

  function initFeedback() {
    var form = $('#feedback-form');
    if (!form) return;

    form.addEventListener('submit', function (event) {
      event.preventDefault();
      clearErrors(form);

      var data = {
        name: $('#fb-name').value.trim(),
        email: $('#fb-email').value.trim(),
        topic: $('#fb-topic').value,
        text: $('#fb-message').value.trim()
      };

      var ok = true;

      if (data.name.length < 2) {
        setFieldError(form, 'name', 'Как вас зовут? Хотя бы два символа.');
        ok = false;
      }
      if (!isEmail(data.email)) {
        setFieldError(form, 'email', 'Без корректного e-mail мы не сможем ответить.');
        ok = false;
      }
      if (data.text.length < 10) {
        setFieldError(form, 'message', 'Расскажите чуть подробнее — минимум 10 символов.');
        ok = false;
      }

      if (!ok) {
        focusFirstInvalid(form);
        return;
      }

      Store.addMessage(data);
      form.reset();
      toast('Сообщение отправлено. Ответим на почту в течение дня.', 'ok');
    });
  }

  /* ---------- админ-панель ------------------------------------ */

  function initAdmin() {
    var guard = $('#admin-guard');
    if (!guard) return;

    var app = $('#admin-app');

    function renderAccess() {
      var user = Store.currentUser();
      var isAdmin = Boolean(user && user.role === 'admin');

      guard.hidden = isAdmin;
      app.hidden = !isAdmin;

      $('#guard-signed-out').hidden = Boolean(user);
      $('#guard-signed-in').hidden = !user;

      if (user) {
        $('#guard-name').textContent = user.name;
      }

      if (isAdmin) {
        $('#admin-name').textContent = user.name;
        $('#admin-mail').textContent = user.email;
        renderOrders();
        renderMessages();
        renderProducts();
      }
    }

    /* ---- вкладки ---- */
    var tabs = $$('.admin-tab');
    tabs.forEach(function (tab) {
      tab.addEventListener('click', function () {
        tabs.forEach(function (other) {
          var selected = other === tab;
          other.setAttribute('aria-selected', selected ? 'true' : 'false');
          var panel = $('#' + other.getAttribute('aria-controls'));
          if (panel) panel.hidden = !selected;
        });
        if (tab.dataset.tab === 'orders') renderOrders();
        if (tab.dataset.tab === 'messages') renderMessages();
        if (tab.dataset.tab === 'products') renderProducts();
      });
    });

    /* ---- статистика ---- */
    function renderStats() {
      var orders = Store.getOrders();
      var counted = orders.filter(function (order) { return order.status !== 'canceled'; });
      var revenue = counted.reduce(function (sum, order) { return sum + Number(order.total || 0); }, 0);
      var average = counted.length ? Math.round(revenue / counted.length) : 0;
      var messages = Store.getMessages();
      var unread = messages.filter(function (message) { return !message.read; }).length;

      $('#stat-revenue').textContent = money(revenue);
      $('#stat-average').textContent = money(average);
      $('#stat-orders').textContent = orders.length;
      $('#stat-unread').textContent = unread;
    }

    /* ---- заказы ---- */
    function renderOrders() {
      var orders = Store.getOrders();
      var body = $('#admin-orders-body');
      if (!body) return;

      $('#count-orders').textContent = orders.length;
      renderStats();

      body.innerHTML = orders.map(function (order) {
        var statuses = ['new', 'cooking', 'ready', 'done', 'canceled'];
        var options = statuses.map(function (status) {
          return '<option value="' + status + '"' + (order.status === status ? ' selected' : '') + '>' +
            Store.statusTitle(status) + '</option>';
        }).join('');

        var composition = order.items.map(function (item) {
          return esc(item.title) + ' ×' + item.qty;
        }).join('<br>');

        return '' +
          '<tr>' +
            '<td class="table__num">#' + order.number + '</td>' +
            '<td class="table__muted">' + Store.date(order.createdAt) + '</td>' +
            '<td>' + esc(order.customer.name) +
              '<div class="table__muted">' + esc(order.customer.phone) + '</div>' +
              '<div class="table__muted">' + esc(order.customer.email) + '</div></td>' +
            '<td>' + composition + '</td>' +
            '<td class="table__sum">' + money(order.total) + '</td>' +
            '<td>' + (order.method === 'pickup' ? 'Самовывоз' : 'Доставка') +
              (order.method === 'delivery' && order.address
                ? '<div class="table__muted">' + esc(order.address) + '</div>' : '') + '</td>' +
            '<td><select class="select select--cell" data-status="' + esc(order.id) + '" aria-label="Статус заказа">' +
              options + '</select></td>' +
          '</tr>';
      }).join('');

      $('#admin-orders-empty').hidden = orders.length > 0;
    }

    var ordersBody = $('#admin-orders-body');
    if (ordersBody) {
      ordersBody.addEventListener('change', function (event) {
        var select = event.target.closest('[data-status]');
        if (!select) return;
        Store.updateOrderStatus(select.dataset.status, select.value);
        toast('Статус изменён: ' + Store.statusTitle(select.value), 'ok');
        renderOrders();
      });
    }

    /* ---- сообщения ---- */
    function renderMessages() {
      var messages = Store.getMessages();
      var box = $('#admin-messages');
      if (!box) return;

      var unread = messages.filter(function (m) { return !m.read; }).length;
      $('#count-messages').textContent = unread;

      box.innerHTML = messages.map(function (message) {
        return '' +
          '<article class="message-card' + (message.read ? '' : ' is-unread') + '">' +
            '<div>' +
              '<div class="message-card__top">' +
                '<span class="message-card__name">' + esc(message.name) + '</span>' +
                '<span class="message-card__mail">' + esc(message.email) + '</span>' +
                '<span class="message-card__topic">' + esc(message.topic) + '</span>' +
              '</div>' +
              '<p class="message-card__text">' + esc(message.text) + '</p>' +
            '</div>' +
            '<div style="text-align:right">' +
              '<div class="message-card__date">' + Store.date(message.createdAt) + '</div>' +
              (message.read ? '' : '<button class="text-btn" style="margin-top:10px" data-read="' +
                esc(message.id) + '">Отметить прочитанным</button>') +
            '</div>' +
          '</article>';
      }).join('');

      $('#admin-messages-empty').hidden = messages.length > 0;
      renderStats();
    }

    var messagesBox = $('#admin-messages');
    if (messagesBox) {
      messagesBox.addEventListener('click', function (event) {
        var button = event.target.closest('[data-read]');
        if (!button) return;
        Store.markMessageRead(button.dataset.read);
        renderMessages();
      });
    }

    /* ---- товары ---- */
    function renderProducts() {
      var products = Store.getProducts();
      var body = $('#admin-products-body');
      if (!body) return;

      body.innerHTML = products.map(function (product) {
        return '' +
          '<tr>' +
            '<td><div class="admin-thumb">' + imageMarkup(product) + '</div></td>' +
            '<td><b>' + esc(product.title) + '</b>' +
              (product.badge ? '<div class="table__muted">' + esc(product.badge) + '</div>' : '') + '</td>' +
            '<td>' + esc(Store.categoryTitle(product.category)) + '</td>' +
            '<td class="table__sum">' + money(product.price) + '</td>' +
            '<td><div class="row-actions">' +
              '<button class="text-btn" data-edit="' + esc(product.id) + '">Изменить</button>' +
              '<button class="text-btn" data-del="' + esc(product.id) + '">Удалить</button>' +
            '</div></td>' +
          '</tr>';
      }).join('');
    }

    var productsBody = $('#admin-products-body');
    if (productsBody) {
      productsBody.addEventListener('click', function (event) {
        var edit = event.target.closest('[data-edit]');
        var del = event.target.closest('[data-del]');

        if (edit) {
          var product = Store.getProduct(edit.dataset.edit);
          if (product) openProductModal(product);
        }

        if (del) {
          var target = Store.getProduct(del.dataset.del);
          if (!target) return;
          if (!window.confirm('Удалить «' + target.title + '» из меню?')) return;
          Store.saveProducts(Store.getProducts().filter(function (p) { return p.id !== target.id; }));
          renderProducts();
          toast('Товар удалён');
        }
      });
    }

    var productForm = $('#product-form');
    var productModalTitle = $('#product-modal-title');

    function fillProductSelects() {
      var catSelect = $('#pr-category');
      catSelect.innerHTML = Store.categories.map(function (cat) {
        return '<option value="' + cat.id + '">' + esc(cat.title) + '</option>';
      }).join('');
    }

    function openProductModal(product) {
      fillProductSelects();
      productForm.reset();
      clearErrors(productForm);

      if (product) {
        productModalTitle.textContent = 'Редактировать товар';
        productForm.elements.id.value = product.id;
        productForm.elements.title.value = product.title;
        productForm.elements.category.value = product.category;
        productForm.elements.price.value = product.price;
        productForm.elements.description.value = product.description;
        productForm.elements.badge.value = product.badge || '';
        productForm.elements.image.value = product.image || ART_IMAGES[product.art] || '';
      } else {
        productModalTitle.textContent = 'Новый товар';
        productForm.elements.id.value = '';
      }

      openModal('#product-modal');
    }

    var addProduct = $('#add-product');
    if (addProduct) addProduct.addEventListener('click', function () { openProductModal(null); });

    if (productForm) {
      productForm.addEventListener('submit', function (event) {
        event.preventDefault();
        clearErrors(productForm);

        var data = {
          id: productForm.elements.id.value,
          title: productForm.elements.title.value.trim(),
          category: productForm.elements.category.value,
          price: Number(productForm.elements.price.value),
          description: productForm.elements.description.value.trim(),
          badge: productForm.elements.badge.value.trim(),
          image: productForm.elements.image.value.trim()
        };

        var ok = true;
        if (data.title.length < 2) {
          setFieldError(productForm, 'title', 'Название — минимум два символа.');
          ok = false;
        }
        if (!data.price || data.price <= 0) {
          setFieldError(productForm, 'price', 'Цена должна быть больше нуля.');
          ok = false;
        }
        if (data.description.length < 5) {
          setFieldError(productForm, 'description', 'Опишите товар хотя бы в двух словах.');
          ok = false;
        }
        if (!ok) {
          focusFirstInvalid(productForm);
          return;
        }

        data.badge = data.badge || null;
        data.image = data.image || PLACEHOLDER_IMAGE;

        var list = Store.getProducts();
        var isNew = !data.id;

        if (!isNew) {
          list = list.map(function (product) {
            return product.id === data.id ? data : product;
          });
        } else {
          data.id = 'p_' + Date.now().toString(36);
          list.push(data);
        }

        Store.saveProducts(list);
        closeModal($('#product-modal'));
        renderProducts();
        toast(isNew ? 'Товар добавлен' : 'Товар сохранён', 'ok');
      });
    }

    var resetProducts = $('#reset-products');
    if (resetProducts) {
      resetProducts.addEventListener('click', function () {
        if (!window.confirm('Вернуть исходный каталог? Все изменения из админки будут потеряны.')) return;
        Store.resetProducts();
        renderProducts();
        toast('Каталог восстановлен');
      });
    }

    /* ---- вход администратора ---- */
    var adminLogin = $('#admin-login');
    if (adminLogin) {
      adminLogin.addEventListener('submit', function (event) {
        event.preventDefault();
        clearErrors(adminLogin);

        var email = $('#adm-email').value.trim();
        var password = $('#adm-password').value;

        var ok = true;
        if (!isEmail(email)) {
          setFieldError(adminLogin, 'email', 'Введите e-mail.');
          ok = false;
        }
        if (!password) {
          setFieldError(adminLogin, 'password', 'Введите пароль.');
          ok = false;
        }
        if (!ok) {
          focusFirstInvalid(adminLogin);
          return;
        }

        try {
          var user = Store.login(email, password);
          if (user.role !== 'admin') {
            showAlert(adminLogin, 'У этого аккаунта нет прав администратора.');
            return;
          }
          adminLogin.reset();
          document.activeElement.blur();
          toast('Добро пожаловать, ' + user.name, 'ok');
          renderAccess();
        } catch (error) {
          showAlert(adminLogin, error.message);
        }
      });
    }

    var guardLogout = $('#guard-logout');
    if (guardLogout) {
      guardLogout.addEventListener('click', function () {
        Store.logout();
        renderAccess();
      });
    }

    renderAccess();
  }

  /* ---------- запуск ------------------------------------------ */

  initHead();
  initReveal();
  initCartInteractions();
  refreshCartBadge();

  var page = document.body.dataset.page;

  if (page === 'home') initHome();
  if (page === 'menu') initMenu();
  if (page === 'cart') initCart();
  if (page === 'account') initAccount();
  if (page === 'contacts') initFeedback();
  if (page === 'admin') initAdmin();

  observeReveals();
})();
